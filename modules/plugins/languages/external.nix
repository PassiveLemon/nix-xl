{ lib, pkgs, ... }:
let
  inherit (lib) getPackageSrc;
in
# Language structure
# "<lang>" = "<source>";
{
  "containerfile" = "${getPackageSrc "plg-containerfile" pkgs}/init.lua";
  "crystal" = "${getPackageSrc "plg-crystal" pkgs}/language_crystal.lua";
  "ksy" = "${getPackageSrc "plg-ksy" pkgs}/plugins/language_ksy.lua";
  "pony" = "${getPackageSrc "plg-pony" pkgs}/language_pony.lua";
  "vale" = "${getPackageSrc "plg-vale" pkgs}/language_vale.lua";
  "yuescript" = "${getPackageSrc "plg-yuescript" pkgs}/language_yuescript.lua";
}

