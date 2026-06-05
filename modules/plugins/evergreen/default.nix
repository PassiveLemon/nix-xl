{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types attrNames intersectLists subtractLists optionals mergeAttrsList optionalAttrs length;
  inherit (lib) subImport genNamedPaths mkLuaScript; # Custom
  cfg = config.programs.lite-xl;
  cl = cfg.plugins.evergreen.copyLanguages;

  enableLanguages = subImport ./pack.nix;
  supportedLanguages = subImport ./languages.nix;
  languageStrings = attrNames supportedLanguages;

  namedEvergreenPaths = genNamedPaths "lite-xl/plugins/evergreen_languages/evergreen_" enableLanguages;

  languageCopy = intersectLists cfg.plugins.languages.enableList (attrNames supportedLanguages);
  filterCopy = subtractLists cl.filter languageCopy;
  copyLanguages = optionals cl.enable filterCopy;

  finalEvergreenStrings = attrNames enableLanguages;
  concatEvergreens = mkLuaScript finalEvergreenStrings;
in
{
  options = {
    programs.lite-xl.plugins.evergreen = {
      enableList = mkOption {
        type = types.listOf (types.enum languageStrings);
        description = "The list of languages to enable.";
        default = [ ];
        apply = value: value ++ copyLanguages;
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
        description = "Enable custom languages. A custom language will overwrite the same name language in enableList.";
        default = { };
      };
      copyLanguages = {
        enable = mkEnableOption "copying Lite-XL languages for Evergreen";
        filter = mkOption {
          type = types.listOf types.str;
          description = "The list of languages to not copy.";
          default = [ ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mergeAttrsList [
      namedEvergreenPaths
      (optionalAttrs (length finalEvergreenStrings > 0) {
        "lite-xl/plugins/evergreen_languages/init.lua" = {
          text = ''
            -- mod-version: 3

            local languages = '${concatEvergreens}'

            -- Match language strings in ",lang1,,lang2,,lang3,"
            for lang in languages:gmatch(",([%w_]+),") do
              require("plugins.evergreen_languages.evergreen_" .. lang)
            end
          '';
        };
      })
    ];
  };
}

