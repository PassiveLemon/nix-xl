{ config, lib, ... }:
let
  inherit (lib) subImport mapGetDeps getAttrs attrNames flatten mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLanguages = subImport ./languages.nix;
  depsList = subImport ./deps.nix;

  customEnableList = cfg.plugins.evergreen.customEnableList;

  enableList = cfg.plugins.evergreen.enableList;
  languagesWithDepsStrings = attrNames (getAttrs enableList depsList.plugins);

  # Get language deps
  languageDeps = mapGetDeps languagesWithDepsStrings (dep: depsList.${dep});

  finalLanguages = getAttrs (flatten languageDeps) supportedLanguages;
in
mergeAttrsList [
  finalLanguages
  customEnableList
]

