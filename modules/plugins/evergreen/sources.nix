{ name
, languages
, deps
, lib
, stdenv
, fetchFromGitHub
, fetchgit
, git
, python3
, unzip
}:
let
  inherit (lib) elem getAttr foldl' concatStringsSep;

  buildLang = languages.${name};

  getDeps = (lang: visited:
    if elem lang visited
    then visited
    else
      let
        direct = getAttr lang deps;
        nextVisited = visited ++ [ lang ];
      in
        foldl' (acc: dep: getDeps dep acc)
          nextVisited
          direct);

  allDeps = getDeps name [ ];

  depsCpList = map (dep: (
    if languages.${dep} != ""
    then "cp -r ${languages.${dep}} build/${dep}"
    else "")
  ) allDeps;

  depsCopy = concatStringsSep "\n" depsCpList;

  nvim-ts = fetchgit {
    url = "https://github.com/nvim-treesitter/nvim-treesitter";
    rev = "42fc28ba918343ebfd5565147a42a26580579482";
    hash = "sha256-CVs9FTdg3oKtRjz2YqwkMr0W5qYLGfVyxyhE3qnGYbI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "evergreen_${name}";
  version = "4f22fd68344ca8e134963211695c1c45393888e7";

  src = fetchFromGitHub {
    owner = "Evergreen-lxl";
    repo = "evergreen-languages";
    rev = finalAttrs.version;
    hash = "sha256-UIiaBcvWJLK2mV40T0+L00XRFCqXT0c2z6pSl1Rr9h4=";
  };

  # TODO: Turn these into patch files
  # 1 Patch out outgoing git calls due to nix sandbox
  # 2 Patch in language details
  # 3 Remove platform from zip name
  # 4 Python Zip doesn't link timestamps before 1980 so all the files are touched to update the last modified date
  postPatch = ''
    mkdir build
    cp -r ${nvim-ts} build/nvim-treesitter
    ${depsCopy}

    # 1
    substituteInPlace package_sources.py \
      --replace-fail 'subprocess.run(["git", "clone", "--depth", "1", NVTS_URL, NVTS_DIR])' 'return True' \
      --replace-fail 'cmt = git_remote_commit(opts["remote"])' 'cmt = "${buildLang.rev}"' \
      --replace-fail 'nvts_update, nvts_commit = check_nvts(lock.get("nvim-treesitter"))' 'nvts_update, nvts_commit = False, "${nvim-ts.rev}"'

    substituteInPlace language.py \
      --replace-fail 'subprocess.run(["git", "clone", "--depth", "1", self.remote, path])' ""

    # 2
    substituteInPlace package_sources.py \
      --replace-fail "for name, opts in config.items():" "if True:" \
      --replace-fail "lang_lock = langs_lock.get(name, {})" 'name, opts, lang_lock = "${name}", config["${name}"], langs_lock.get("${name}", {})' \
      --replace-fail "if lang_update:" "if True:" \

    # 3
    substituteInPlace build.py \
      --replace-fail 'DIST_DIR / f"{NAME_PREFIX}{name}-{PLATFORM}.zip",' 'DIST_DIR / f"{NAME_PREFIX}{name}.zip",'

    # 4
    touch `find ./build -type f`
  '';

  nativeBuildInputs = [
    git
    python3
    unzip
  ];

  buildPhase = ''
    runHook preBuild

    python package_sources.py
    python build.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    ls dist

    unzip dist/evergreen_${name}.zip -d $out

    runHook postInstall
  '';
})

