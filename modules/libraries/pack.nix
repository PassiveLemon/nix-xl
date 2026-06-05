{ config, lib, ... }:
let
  inherit (lib) subImport mapGetDeps getAttrs attrNames subtractLists flatten elem mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLibraries = subImport ./libraries.nix;
  depsList = subImport ../deps.nix;

  customEnableList = cfg.libraries.customEnableList;

  # Filter enabled libraries
  libraryEnableList = cfg.libraries.enableList;
  librariesWithDepsStrings = attrNames (getAttrs libraryEnableList depsList.libraries);

  # Get library deps
  libraryDeps = mapGetDeps librariesWithDepsStrings (dep: _: depsList.libraries.${dep}.libraries);

  # Filter plugins languages
  # Plugins can depend on libraries so we need to check those too
  pluginEnableList = cfg.plugins.enableList;
  pluginsWithDepsStrings = attrNames (getAttrs pluginEnableList depsList.plugins);

  # Get plugin library deps
  pluginLibraryDeps = subtractLists pluginsWithDepsStrings (mapGetDeps pluginsWithDepsStrings (dep: acc:
    if elem dep pluginsWithDepsStrings
    then depsList.plugins.${dep}.libraries
    else depsList.libraries.${dep}.libraries
  ));

  finalLibraries = getAttrs (flatten [ libraryDeps pluginLibraryDeps ]) supportedLibraries;
in
mergeAttrsList [
  finalLibraries
  customEnableList
]

