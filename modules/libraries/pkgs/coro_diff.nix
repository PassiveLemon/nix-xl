{ stdenv
, fetchFromGitHub
, meson
, ninja
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "coro_diff";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Guldoman";
    repo = "lite-xl-coro_diff";
    rev = finalAttrs.version;
    hash = "sha256-uNFpboTkvXC5BePFuVgFEzcR1+6rihWaIj0FAm+FWAE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildPhase = ''
    runHook preBuild

    cd /build/source

    meson setup --buildtype=release build
    meson compile -C build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv build/myers_midpoint.so $out/init.so

    runHook postInstall
  '';
})

