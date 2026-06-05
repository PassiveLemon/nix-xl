{ lib, pkgs, ... }:
let
  inherit (lib) genPaths getPackageSrc mergeAttrsList;

  builtinLangs = genPaths "${lib.NXLPkgs.lxl}/data/plugins/language_" [
    "c" "cpp" "css" "html" "js" "lua" "md" "python" "xml"
  ];
in
mergeAttrsList [
  builtinLangs
  {
    containerfile = "${getPackageSrc "plg-containerfile" pkgs}/init.lua";
    crystal = "${getPackageSrc "plg-crystal" pkgs}/language_crystal.lua";
    ksy = "${getPackageSrc "plg-ksy" pkgs}/plugins/language_ksy.lua";
    pony = "${getPackageSrc "plg-pony" pkgs}/language_pony.lua";
    vale = "${getPackageSrc "plg-vale" pkgs}/language_vale.lua";
    yuescript = "${getPackageSrc "plg-yuescript" pkgs}/language_yuescript.lua";
  }
]

