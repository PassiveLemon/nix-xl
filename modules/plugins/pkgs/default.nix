{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
{
  devicons = callPackage ./devicons.nix { };
  discord_presence = callPackage ./discord_presence.nix { };
  fallbackfonts = callPackage ./fallbackfonts.nix { };
  litepresence = callPackage ./litepresence.nix { };
  # plugin_manager # Shouldn't need it but why not
  quetta = callPackage ./quetta.nix { };
  snippets = callPackage ./snippets.nix { };
  terminal = callPackage ./terminal.nix { };
}

