{ config, lib, ... }:
let
  inherit (lib) subImport mapGetDeps getAttrs attrNames flatten mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLibraries = subImport ./libraries.nix;
  depsList = subImport ../deps.nix;

  customEnableList = cfg.libraries.customEnableList;

  libraryEnableList = cfg.libraries.enableList;
  librariesWithDeps = getAttrs libraryEnableList depsList.libraries;
  librariesWithDepsStrings = attrNames librariesWithDeps;

  # Get library deps
  libraryDeps = mapGetDeps librariesWithDepsStrings (dep: depsList.libraries.${dep}.libraries);

  # Plugins can depend on libraries so we need to check those too
  pluginEnableList = cfg.plugins.enableList;
  pluginsWithDepsStrings = attrNames (getAttrs pluginEnableList depsList.plugins);

  # Get plugin library deps
  pluginLibraryDepsStrings = flatten (map (plugin: depsList.plugins.${plugin}.libraries) pluginsWithDepsStrings);
  pluginLibraryDeps = mapGetDeps pluginLibraryDepsStrings (dep: depsList.libraries.${dep}.libraries);

  finalLibraries = getAttrs (flatten [ libraryDeps pluginLibraryDeps ]) supportedLibraries;
in
mergeAttrsList [
  finalLibraries
  customEnableList
]

