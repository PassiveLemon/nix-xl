{ version
, src
, stdenv
}:
stdenv.mkDerivation {
  pname = "devicons";
  inherit version src;

  buildPhase = "";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp $src/devicons.lua $out/init.lua
    cp $src/fontello-974160e7/font/devicons.ttf $out/devicons.ttf

    runHook postInstall
  '';
}

