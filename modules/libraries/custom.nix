{ config, lib, pkgs, ... }:
let
  inherit (lib) mergeAttrsList;
  cfg = config.programs.lite-xl;

  customLibraries = cfg.customLibraries;

  # depLibraries is for plugins that require dependency libraries
  deps = import ../plugins/deps.nix { inherit config lib pkgs; };
  depLibraries = deps.libraries;
in
mergeAttrsList [
  customLibraries
  depLibraries
]

