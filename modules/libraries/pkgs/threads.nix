{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, SDL2
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "threads";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "jgmdev";
    repo = "lite-xl-threads";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iAIJhNe/oli+DBZSGJLOCcRpOtmuWeV+unq4U2PK8a4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    SDL2
  ];

  buildPhase = ''
    runHook preBuild

    cd /build/source

    meson setup build
    meson compile -C build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv build/thread.so $out/init.so

    runHook postInstall
  '';
})

