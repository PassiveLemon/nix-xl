{ config, lib, ... }:
let
  inherit (lib) getAttrs attrNames subtractLists flatten mergeAttrsList;
  inherit (lib) subImport mapGetDeps; # Custom
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
    ### This actually does not catch libraries from exclusively resolved plugins (plugins not in enableList). This will be addressed in the future
    # Get the libraries from the plugin first, then from those libraries' libraries going forward
    if acc == [ ]
    then depsList.plugins.${dep}.libraries
    else depsList.libraries.${dep}.libraries
  ));

  finalLibraries = getAttrs (flatten [ libraryDeps pluginLibraryDeps ]) supportedLibraries;
in
mergeAttrsList [
  finalLibraries
  customEnableList
]

