{ lib, pkgs, ... }:
let
  inherit (lib) mergeAttrsList;
  inherit (lib) getPackageSrc; # Custom

  lsp = lib.NXLPkgs.lsp;
in
mergeAttrsList [
  lib.NXLPkgs.libraries
  {
    "widget" = getPackageSrc "lib-widgets" pkgs;
    "json" = "${getPackageSrc "lib-json" pkgs}/json.lua";
    "golang" = "${lsp}/libraries/golang.lua";
    "haxe" = "${lsp}/libraries/haxe.lua";
    "jdk" = "${lsp}/libraries/jdk.lua";
    "nodejs" = "${lsp}/libraries/nodejs.lua";
  }
]

