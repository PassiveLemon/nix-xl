{ config, lib, ... }:
let
  inherit (lib) unique getAttrs mergeAttrsList;
  inherit (lib) subImport; # Custom
  cfg = config.programs.lite-xl;

  customEnableList = cfg.plugins.customEnableList;

  supportedPlugins = subImport ./plugins.nix;
  resolvedDeps = unique (subImport ../resolve.nix).plugins;

  finalPlugins = getAttrs resolvedDeps supportedPlugins;
in
mergeAttrsList [
  finalPlugins
  customEnableList
]

