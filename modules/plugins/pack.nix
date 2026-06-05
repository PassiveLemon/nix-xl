{ config, lib, ... }:
let
  inherit (lib) subImport mapGetDeps getAttrs attrNames flatten mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedPlugins = subImport ./plugins.nix;
  depsList = subImport ../deps.nix;

  customEnableList = cfg.plugins.customEnableList;

  # Filter enabled languages
  enableList = cfg.plugins.enableList;
  pluginsWithDepsStrings = attrNames (getAttrs enableList depsList.plugins);

  # Get plugins deps
  pluginDeps = mapGetDeps pluginsWithDepsStrings (dep: _: depsList.plugins.${dep}.plugins);

  # Ignore checking if any supported library depends on a plugin because currently none do and will likely never

  finalPlugins = getAttrs (flatten pluginDeps) supportedPlugins;
in
mergeAttrsList [
  finalPlugins
  customEnableList
]

