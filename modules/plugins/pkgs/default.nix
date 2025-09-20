{ lib, pkgs, ... }:
let
  inherit (lib) packager;
in
{
  devicons =  packager "plg-devicons" ./devicons.nix pkgs { }; # Deprecated https://github.com/lite-xl/lite-xl-plugins/commit/499961ac9d08c803c814244e36b2174e9494b532. May remove eventually
  discord-presence = packager "plg-discord-presence" ./discord-presence.nix pkgs { };
  fallbackfonts = packager "plg-fallbackfonts" ./fallbackfonts.nix pkgs { };
  litepresence = packager "plg-litepresence" ./litepresence.nix pkgs { };
  # plugin_manager # Kind of defeats the purpose of this repository but maybe it can be added?
  quetta = packager "plg-quetta" ./quetta.nix pkgs { };
  terminal = packager "plg-terminal" ./terminal.nix pkgs { };
}

