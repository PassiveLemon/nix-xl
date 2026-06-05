{ config, lib, ... }:
let
  inherit (lib) getAttrs attrNames flatten mergeAttrsList;
  inherit (lib) subImport mapGetDeps; # Custom
  cfg = config.programs.lite-xl;

  supportedLanguages = subImport ./languages.nix;
  depsList = subImport ./deps.nix;

  customEnableList = cfg.plugins.evergreen.customEnableList;

  # Filter enabled languages
  enableList = cfg.plugins.evergreen.enableList;
  languagesWithDepsStrings = attrNames (getAttrs enableList depsList.plugins);

  # Get language deps
  languageDeps = mapGetDeps languagesWithDepsStrings (dep: _: depsList.${dep});

  finalLanguages = getAttrs (flatten languageDeps) supportedLanguages;
in
mergeAttrsList [
  finalLanguages
  customEnableList
]

