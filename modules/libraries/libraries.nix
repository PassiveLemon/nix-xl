{ lib, pkgs, ... }:
let
  inherit (lib) getPackage mergeAttrsList;

  lsp = (getPackage "lib-lsp-servers" pkgs).src;

  libraryPackages = import ./pkgs { inherit lib pkgs; };
in
# Libraries that are a single file should have the source set to the exact init.lua file
# Libraries that are multiple files should have the source set to the root where init.lua is

# Library structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  libraryPackages
  {
    "widget" = (getPackage "lib-widgets" pkgs).src;
    "json" = "${(getPackage "lib-json" pkgs).src}/json.lua";
    "golang" = "${lsp}/libraries/golang.lua";
    "haxe" = "${lsp}/libraries/haxe.lua";
    "jdk" = "${lsp}/libraries/jdk.lua";
    "nodejs" = "${lsp}/libraries/nodejs.lua";
  }
]

