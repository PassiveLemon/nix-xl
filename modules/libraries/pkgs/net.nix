{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, SDL2_net
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "net";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jgmdev";
    repo = "lite-xl-net";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hWdYSmDAS8R3/pOziTryYna6RWGS53vN5rOcYvjleAI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    SDL2_net
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
    mv build/net.so $out/init.so

    runHook postInstall
  '';
})

