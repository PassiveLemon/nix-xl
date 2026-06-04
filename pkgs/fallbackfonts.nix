{ version
, src
, stdenv
}:
stdenv.mkDerivation {
  pname = "fallbackfonts";
  inherit version src;

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
}

