{ version
, src
, stdenv
}:
stdenv.mkDerivation {
  pname = "quetta";
  inherit version src;

  buildPhase = ''
    runHook preBuild

    BIN=libquetta.so bash build.sh -O3

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp init.lua $out/init.lua
    mv libquetta.so $out/libquetta.so

    runHook postInstall
  '';
}

