{ stdenv
, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "www";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "adamharrison";
    repo = "lite-xl-www";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/TQj0EFWyDsfMMB4mD4t6hdjdYbwMRj/wnpiaGFqlcg=";
    fetchSubmodules = true;
  };

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

