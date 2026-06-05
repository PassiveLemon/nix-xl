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
  system = stdenv.hostPlatform.system;

  langPkg = languages.${name};
  # Some Evergreen languages pull highlights.scm directly from nvim-ts, this is the check condition for that
  langNotIncluded = langPkg != "";

  depsCopyCmds = concatStringsSep "\n" (map (name:
    optionalString (languages.${name} != "") "cp -r ${languages.${name}} build/${name}"
  ) deps);

  # We need to write our own init.lua files for nvim-ts included languages
  # USERDIR is a Lite-XL global
  luaInit = name: writers.writeLua "init.lua" { } ''
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
      unzip dist/evergreen_${name}-${system}.zip -d $out
    ''
    else ''
      mkdir -p $out/queries/
      cp ${nts}/queries/${name}/highlights.scm $out/queries/highlights.scm
      cp ${luaInit name} $out/init.lua
    ''
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "evergreen_${name}";
  inherit version src;

  # 1 Add in our custom source packaging script and build deps
  # 2 Sub in language details
  # 3 Touch all files because Python Zip doesn't support timestamps before 1980
  postPatch = optionalString langNotIncluded ''
    mkdir build

    # 1
    cp ${./package_sources.py} new_package_sources.py

    cp -r ${nts} build/nvim-treesitter
    ${depsCopyCmds}

    # 1
    substituteInPlace new_package_sources.py \
      --replace-fail 'Language()' 'Language("${name}", None, NVTS_QUERY_DIR / "${name}", config.get("${name}").get("files"))' \

    # 2
    touch `find . -type f`
  '';

  nativeBuildInputs = [
    git
    python3
    unzip
  ];

  buildPhase = optionalString langNotIncluded ''
    runHook preBuild

    mkdir srcpkg

    python new_package_sources.py
    PLATFORM=${system} python build.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ${installCmd}

    runHook postInstall
  '';
})

