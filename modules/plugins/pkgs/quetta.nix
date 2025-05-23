{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quetta";
  version = "0.52";

  src = fetchFromGitHub {
    owner = "adamharrison";
    repo = "quetta";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2Z3Kl/bKcBaIpnrQpsmKZy3WOmXKEs9e0fRy48jji0c=";
    fetchSubmodules = true;
  };

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
})

