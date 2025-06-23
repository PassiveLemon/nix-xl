{ lib, pkgs, ... }:
let
  inherit (lib) getPackage;
in
# Language structure
# "<lang>" = "<source>";
{
  "containerfile" = "${(getPackage "plg-containerfile" pkgs).src}/init.lua";
  "crystal" = "${(getPackage "plg-crystal" pkgs).src}/language_crystal.lua";
  "ksy" = "${(getPackage "plg-ksy" pkgs).src}/plugins/language_ksy.lua";
  "pony" = "${(getPackage "plg-pony" pkgs).src}/language_pony.lua";
  "vale" = "${(getPackage "plg-vale" pkgs).src}/language_vale.lua";
  "yuescript" = "${(getPackage "plg-yuescript" pkgs).src}/language_yuescript.lua";
}

