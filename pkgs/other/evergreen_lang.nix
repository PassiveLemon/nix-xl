{ name
, languages
, deps
, version
, src
, lib
, stdenv
, git
, python3
, unzip
, writers
}:
let
  inherit (lib) concatStringsSep optionalString;

  nts = lib.NXLPkgs.nts;

  langPkg = languages.${name};
  # Some Evergreen languages pull highlights.scm directly from nvim-ts, this is the condition for that
  langNotIncluded = langPkg != "";

  depsCopyCmds = concatStringsSep "\n" (map (name:
    optionalString (languages.${name} != "") "cp -r ${languages.${name}} build/${name}"
  ) deps);

  # We need to write our own init.lua files for included languages
  # USERDIR is a Lite-XL global
  pathInit = name: writers.writeLua "init.lua" { } ''
    -- mod-version: 3
    -- luacheck: globals USERDIR

    local evergreen_languages = require 'plugins.evergreen.languages'

    local pkg_name = ...
    local path = pkg_name:gsub('%.', '/')

    evergreen_languages.addDef {
      name = '${name}',
      files = {  },
      path = USERDIR .. '/' .. path,
      soFile = nil,
      queryFiles = {},
    }
  '';

  installCmd = (
    if langNotIncluded
    then ''
      unzip dist/evergreen_${name}.zip -d $out
    ''
    else ''
      mkdir -p $out/queries/
      cp ${nts}/queries/${name}/highlights.scm $out/queries/highlights.scm
      cp ${pathInit name} $out/init.lua
    ''
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "evergreen_${name}";
  inherit version src;

  # TODO: Turn these into patch files
  # 1 Patch out outgoing git calls due to nix sandbox
  # 2 Patch in language details
  # 3 Remove platform from zip name
  # 4 Python Zip doesn't like timestamps before 1980 so all the files are touched to update the last modified date
  postPatch = optionalString langNotIncluded ''
    mkdir build
    cp -r ${nts} build/nvim-treesitter
    ${depsCopyCmds}

    # 1
    substituteInPlace package_sources.py \
      --replace-fail 'subprocess.run(["git", "clone", "--depth", "1", NVTS_URL, NVTS_DIR])' 'return True' \
      --replace-fail 'cmt = git_remote_commit(opts["remote"])' 'cmt = "${langPkg.rev}"' \
      --replace-fail 'nvts_update, nvts_commit = check_nvts(lock.get("nvim-treesitter"))' 'nvts_update, nvts_commit = False, "${nts.rev}"'

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

  buildPhase = optionalString langNotIncluded ''
    runHook preBuild

    python package_sources.py
    python build.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ${installCmd}

    runHook postInstall
  '';
})

