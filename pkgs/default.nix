{ pkgs, lib, ... }:
let
  inherit (lib) packager getPackageSrc;
in rec {
  lxl = getPackageSrc "lite-xl-plugins" pkgs;

  plugins = {
    discord-presence = packager "plg-discord-presence" ./discord-presence.nix pkgs;
    fallbackfonts = packager "plg-fallbackfonts" ./fallbackfonts.nix pkgs;
    litepresence = packager "plg-litepresence" ./litepresence.nix pkgs;
    quetta = packager "plg-quetta" ./quetta.nix pkgs;
    terminal = packager "plg-terminal" ./terminal.nix pkgs;
  };
  libraries = {
    coro_diff = packager "lib-coro_diff" ./coro_diff.nix pkgs;
    encoding = packager "lib-encoding" ./encoding.nix pkgs;
    net = packager "lib-net" ./net.nix pkgs;
    threads = packager "lib-threads" ./threads.nix pkgs;
    tree_sitter = packager "lib-tree_sitter" ./tree_sitter.nix pkgs;
    # www = packagerGit "lib-www" ./www.nix pkgs;
    # TODO: Build nonicons because it is not in Nixpkgs
    # https://github.com/ya2s/nonicons/
    font_nonicons = pkgs.callPackage ./font_nonicons.nix { src = lxl; };
    font_symbols_nerdfont_mono_regular = pkgs.callPackage ./font_symbols_nerdfont_mono_regular.nix { src = lxl; };
  };
}

