{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
{
  devicons = callPackage ./devicons.nix { };
  discord-presence = callPackage ./discord-presence.nix { };
  fallbackfonts = callPackage ./fallbackfonts.nix { };
  litepresence = callPackage ./litepresence.nix { };
  # plugin_manager # Kind of defeats the purpose of this repository but maybe it can be added?
  quetta = callPackage ./quetta.nix { };
  snippets = callPackage ./snippets.nix { };
  terminal = callPackage ./terminal.nix { };
}

