{ version
, src
, stdenv
}:
stdenv.mkDerivation {
  pname = "discord-presence";
  inherit version src;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp $src/init.lua $out/init.lua
    mv build/discord_socket.so $out/discord_socket.so

    runHook postInstall
  '';
}

