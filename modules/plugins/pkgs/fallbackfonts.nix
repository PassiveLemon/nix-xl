{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fallbackfonts";
  version = "281cafc014f7931f041046f76496797695678bb4";

  src = fetchFromGitHub {
    owner = "takase1121";
    repo = "lite-fallback-fonts";
    rev = finalAttrs.version;
    hash = "sha256-zkgysv+pat+FjMmubb573gsQ3PLb+Y9oM81bH45cxwA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace init.lua \
      --replace-fail 'local PLUGINDIR = path(EXEDIR .. "/data/plugins/fallbackfonts")' 'local PLUGINDIR = path(USERDIR .. "/plugins/fallbackfonts")'
  '';

  buildPhase = ''
    runHook preBuild

    bash build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp init.lua $out/init.lua
    cp $src/utfhelper.lua $out/utfhelper.lua
    mv mkfontmap $out/mkfontmap

    runHook postInstall
  '';
})

