{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "discord-presence";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "vincens2005";
    repo = "lite-xl-discord2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZUu+8LVo+jtOrjuz1MUZ8kt3JpnWkz7fwX8dJLmHHVs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp $src/init.lua $out/init.lua
    mv build/discord_socket.so $out/discord_socket.so

    runHook postInstall
  '';
})

