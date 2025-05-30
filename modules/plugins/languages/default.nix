{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs concatMapStrings mapAttrs' nameValuePair mergeAttrsList optionalAttrs length;
  cfg = config.programs.lite-xl;

  supportedLanguages = import ./languages.nix { inherit lib pkgs; };
  languageStrings = attrNames supportedLanguages;

  customEnableList = cfg.plugins.languages.customEnableList;

  # Filter loaded languages
  enableList = cfg.plugins.languages.enableList;
  userLanguages = getAttrs enableList supportedLanguages;
  finalLanguages = mergeAttrsList [ userLanguages customEnableList ];

  # Map supportedLanguages attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/languages/language_lang1.lua" = { source = "<source1>"; }
  #   "lite-xl/plugins/languages/language_lang2.lua" = { source = "<source2>"; }
  #   "lite-xl/plugins/languages/language_lang3.lua" = { source = "<source3>"; }
  # }
  namedLanguagePaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/languages/language_${name}.lua" { source = source; })
    finalLanguages;

  # Concat userLanguage list for lua script
  # -> ",lang1,,lang2,,lang3,"
  finalLanguageStrings = attrNames finalLanguages;
  concatLanguages = concatMapStrings (lang: ",${lang},") finalLanguageStrings;
in
{
  options = {
    programs.lite-xl.plugins.languages = {
      enableList = mkOption {
        type = types.listOf (types.enum languageStrings);
        default = [ ];
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mergeAttrsList [
      namedLanguagePaths
      (optionalAttrs (length finalLanguageStrings > 0) {
        # Script to load languages since they are not placed top-level
        "lite-xl/plugins/languages/init.lua" = {
          text = ''
            -- mod-version: 3

            local languages = '${concatLanguages}'

            -- Match language strings in ",lang1,,lang2,,lang3,"
            for lang in languages:gmatch(",([%w_]+),") do
              require("plugins.languages.language_" .. lang)
            end
          '';
        };
      })
    ];
  };
}

