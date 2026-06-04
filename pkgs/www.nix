{ version
, src
, stdenv
, cmake
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "www";
  inherit version src;

  nativeBuildInputs = [
    cmake
  ];

  # build.sh script fails
  buildPhase = ''
    runHook preBuild

    BIN="www.so" bash build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv www.so $out/init.so

    runHook postInstall
  '';
})

