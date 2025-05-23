{ config, lib, pkgs, ... }:
let
  inherit (lib) mergeAttrsList;
  cfg = config.programs.lite-xl;

  customPlugins = cfg.customPlugins;

  # depPlugins is for plugins that require dependency plugins
  deps = import ./deps.nix { inherit config lib pkgs; };
  depPlugins = deps.plugins;
in
mergeAttrsList [
  customPlugins
  depPlugins
]

