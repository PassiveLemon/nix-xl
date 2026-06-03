{ config, lib, ... }:
let
  inherit (lib) subImport getAttrs attrNames elem foldl' flatten mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedPlugins = subImport ./plugins.nix;
  depsList = subImport ../deps.nix;

  customEnableList = cfg.plugins.customEnableList;

  enableList = cfg.plugins.enableList;
  pluginsWithDeps = getAttrs enableList depsList.plugins;
  pluginsWithDepsStrings = attrNames pluginsWithDeps;

  getDeps = (plugin: visited:
    # If plugin is in visited then return the list to avoid infinite recursion.
    # This indicates that the deps for said plugin were already resolved
    if elem plugin visited then visited else
      let
        # Pass the next plugin and visited list to gitDeps recursively
        direct = depsList.plugins.${plugin}.plugins;
        nextVisited = visited ++ [ plugin ];
      in
        foldl' (acc: dep: getDeps dep acc) nextVisited direct);

  # Check plugins
  pluginDeps = map (plugin: getDeps plugin [ ]) pluginsWithDepsStrings;

  finalPlugins = getAttrs (flatten pluginDeps) supportedPlugins;
in
mergeAttrsList [
  finalPlugins
  customEnableList
]

