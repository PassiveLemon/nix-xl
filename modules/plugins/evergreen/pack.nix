{ config, lib, ... }:
let
  inherit (lib) intersectLists subtractLists optional getAttrs attrNames flatten mergeAttrsList;
  inherit (lib) subImport mapGetDeps; # Custom
  cfg = config.programs.lite-xl;
  cl = cfg.plugins.evergreen.copyLanguages;

  supportedLanguages = subImport ./languages.nix;
  depsList = subImport ./deps.nix;

  customEnableList = cfg.plugins.evergreen.customEnableList;

  # Filter and add supported languages if evergreen.copyLanguages is enabled
  languageCopy = intersectLists cfg.plugins.languages.enableList (attrNames supportedLanguages);
  filterCopy = subtractLists cl.filter languageCopy;
  copyLanguages = optional cl.enable filterCopy;

  enableList = flatten (cfg.plugins.evergreen.enableList ++ copyLanguages);
  languagesWithDepsStrings = attrNames (getAttrs enableList depsList.plugins);

  # Get language deps
  languageDeps = mapGetDeps languagesWithDepsStrings (dep: _: depsList.${dep});

  finalLanguages = getAttrs (flatten languageDeps) supportedLanguages;
in
mergeAttrsList [
  finalLanguages
  customEnableList
]

