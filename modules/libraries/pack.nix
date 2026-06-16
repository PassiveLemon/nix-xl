{ config, lib, ... }:
let
  inherit (lib) unique getAttrs mergeAttrsList;
  inherit (lib) subImport; # Custom
  cfg = config.programs.lite-xl;

  customEnableList = cfg.libraries.customEnableList;

  supportedLibraries = subImport ./libraries.nix;
  resolvedDeps = unique (subImport ../resolve.nix).libraries;

  finalLibraries = getAttrs resolvedDeps supportedLibraries;
in
mergeAttrsList [
  finalLibraries
  customEnableList
]

