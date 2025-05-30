{ config, lib, pkgs, ... }:
let
  inherit (lib) getAttrs attrNames elem foldl' flatten mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLibraries = import ./libraries.nix { inherit lib pkgs; };
  depsList = import ../deps.nix { inherit lib pkgs; };

  customEnableList = cfg.libraries.customEnableList;

  # Filter libraries
  libraryEnableList = cfg.libraries.enableList;
  librariesWithDeps = getAttrs libraryEnableList depsList.libraries;
  librariesWithDepsStrings = attrNames librariesWithDeps;

  # Plugins can depend on libraries so we need to check those too
  pluginEnableList = cfg.plugins.enableList;
  pluginsWithDeps = getAttrs pluginEnableList depsList.plugins;
  pluginsWithDepsStrings = attrNames pluginsWithDeps;

  getDeps = (library: visited:
    # If library is in visited then return the list to avoid infinite recursion.
    # This indicates that the deps for said plugin were already resolved
    if elem library visited then visited else
      let
        # Pass the next plugin and visited list to gitDeps recursively
        direct = depsList.libraries.${library}.libraries;
        nextVisited = visited ++ [ library ];
      in
        foldl' (acc: dep: getDeps dep acc) nextVisited direct);

  # Check library deps
  libraryDeps = map (library: getDeps library [ ]) librariesWithDepsStrings;

  # Check plugin library deps
  pluginLibraryDepsList = flatten (map (plugin: depsList.plugins.${plugin}.libraries) pluginsWithDepsStrings);
  pluginLibraryDeps = map (library: getDeps library [ ]) pluginLibraryDepsList;

  finalLibraries = getAttrs (flatten [ libraryDeps pluginLibraryDeps ]) supportedLibraries;
in
mergeAttrsList [
  finalLibraries
  customEnableList
]

