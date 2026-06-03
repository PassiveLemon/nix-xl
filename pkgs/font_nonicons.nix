{ src
, stdenv
}:
stdenv.mkDerivation {
  name = "nonicons";
  inherit src;
  
  buildPhase = "";
  
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp $src/plugins/font_nonicons.lua $out/init.lua

    runHook postInstall
  '';
}

