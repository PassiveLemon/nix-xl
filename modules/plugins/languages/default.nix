{ config, lib, ... }:
let
  inherit (lib) subImport genNamedFiles mkLuaScript mkIf mkOption types attrNames getAttrs mergeAttrsList optionalAttrs length;
  cfg = config.programs.lite-xl;

  supportedLanguages = subImport ./pack.nix;
  languageStrings = attrNames supportedLanguages;

  customEnableList = cfg.plugins.languages.customEnableList;

  # Filter enabled languages
  enableList = cfg.plugins.languages.enableList;
  userLanguages = getAttrs enableList supportedLanguages;
  finalLanguages = mergeAttrsList [ userLanguages customEnableList ];

  namedLanguagePaths = genNamedFiles "lite-xl/plugins/languages/language_" finalLanguages;

  finalLanguageStrings = attrNames finalLanguages;
  concatLanguages = mkLuaScript finalLanguageStrings;
in
{
  options = {
    programs.lite-xl.plugins.languages = {
      enableList = mkOption {
        type = types.listOf (types.enum languageStrings);
        description = "The list of languages to enable.";
        default = [ ];
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
        description = "Enable custom languages. A custom language will overwrite the same name language in enableList.";
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mergeAttrsList [
      namedLanguagePaths
      (optionalAttrs (length finalLanguageStrings > 0) {
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

