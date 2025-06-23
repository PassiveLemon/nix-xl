{ lib, pkgs, ... }:
let
  inherit (lib) packager packagerGit getPackage;
in
{
  devicons =  packagerGit (getPackage "plg-devicons" pkgs) ./devicons.nix;
  discord-presence = packager (getPackage "plg-discord-presence" pkgs) ./discord-presence.nix;
  fallbackfonts = packagerGit (getPackage "plg-fallbackfonts" pkgs) ./fallbackfonts.nix;
  litepresence = packager (getPackage "plg-litepresence" pkgs) ./litepresence.nix;
  # plugin_manager # Kind of defeats the purpose of this repository but maybe it can be added?
  quetta = packagerGit (getPackage "plg-quetta" pkgs) ./quetta.nix;
  terminal = packagerGit (getPackage "plg-terminal" pkgs) ./terminal.nix;
}

