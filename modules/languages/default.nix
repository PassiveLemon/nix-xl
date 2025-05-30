{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs concatMapStrings mapAttrs' nameValuePair mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLanguages = import ./languages.nix { inherit lib pkgs; };
  supportedFormatters = import ./formatters.nix { inherit lib pkgs; };
  supportedLsps = import ./lsps.nix { inherit lib pkgs; };
  supportedEvergreens = import ./evergreen.nix { inherit config lib pkgs; };

  languageStrings = attrNames supportedLanguages;
  formatterStrings = attrNames supportedFormatters;
  lspStrings = attrNames supportedLsps;
  evergreenStrings = attrNames supportedEvergreens;

  customLanguages = cfg.customLanguages;
  customFormatters = cfg.customFormatters;
  customLspServers = cfg.customLspServers;
  customEvergreenLanguages = cfg.customEvergreenLanguages;

  # Filter loaded languages
  configLanguages = cfg.languages;
  userLanguages = getAttrs configLanguages supportedLanguages;
  finalLanguages = mergeAttrsList [ userLanguages customLanguages ];

  configFormatters = cfg.formatters;
  userFormatters = getAttrs configFormatters supportedFormatters;
  finalFormatters = mergeAttrsList [ userFormatters customFormatters ];

  configLsps = cfg.lspServers;
  userLsps = getAttrs configLsps supportedLsps;
  finalLsps = mergeAttrsList [ userLsps customLspServers ];

  configEvergreens = cfg.evergreenLanguages;
  userEvergreens = getAttrs configEvergreens supportedEvergreens;
  finalEvergreens = mergeAttrsList [ userEvergreens customEvergreenLanguages ];

  # Map supportedLanguages attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/languages/language_lang1.lua" = { source = "<source1>"; }
  #   "lite-xl/plugins/languages/language_lang2.lua" = { source = "<source2>"; }
  #   "lite-xl/plugins/languages/language_lang3.lua" = { source = "<source3>"; }
  # }
  namedLanguagePaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/languages/language_${name}.lua" { source = source; })
    finalLanguages;

  namedFormatterPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/formatters/formatter_${name}.lua" { source = source; })
    finalFormatters;

  namedLspPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/lsp_servers/lsp_${name}.lua" { source = source; })
    finalLsps;

  namedEvergreenPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/evergreen_languages/evergreen_${name}" { source = source; })
    finalEvergreens;

  # Concat userLanguage list for lua script
  # -> ",lang1,,lang2,,lang3,"
  finalLanguageStrings = attrNames finalLanguages;
  concatLanguages = concatMapStrings (lang: ",${lang},") finalLanguageStrings;

  finalFormatterStrings = attrNames finalFormatters;
  concatFormatters = concatMapStrings (form: ",${form},") finalFormatterStrings;

  finalLspStrings = attrNames finalLsps;
  concatLsps = concatMapStrings (serv: ",${serv},") finalLspStrings;

  finalEvergreenStrings = attrNames finalEvergreens;
  concatEvergreens = concatMapStrings (lang: ",${lang},") finalEvergreenStrings;
in
{
  options = {
    programs.lite-xl = {
      languages = mkOption {
        type = types.listOf (types.enum languageStrings);
        default = [ ];
      };
      customLanguages = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
      formatters = mkOption {
        type = types.listOf (types.enum formatterStrings);
        default = [ ];
      };
      customFormatters = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
      lspServers = mkOption {
        type = types.listOf (types.enum lspStrings);
        default = [ ];
      };
      customLspServers = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
      evergreenLanguages = mkOption {
        type = types.listOf (types.enum evergreenStrings);
        default = [ ];
      };
      customEvergreenLanguages = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mergeAttrsList [
      namedLanguagePaths
      namedFormatterPaths
      namedLspPaths
      namedEvergreenPaths
      ({
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
      ({
        "lite-xl/plugins/formatters/init.lua" = {
          text = ''
            -- mod-version: 3

            local formatters = '${concatFormatters}'

            -- Match formatter strings in ",form1,,form2,,form3,"
            for form in formatters:gmatch(",([%w_]+),") do
              require("plugins.formatters.formatter_" .. form)
            end
          '';
        };
      })
      ({
        "lite-xl/plugins/lsp_servers/init.lua" = {
          text = ''
            -- mod-version: 3

            local servers = '${concatLsps}'

            -- Match server strings in ",serv1,,serv2,,serv3,"
            for serv in servers:gmatch(",([%w_]+),") do
              require("plugins.lsp_servers.lsp_" .. serv)
            end
          '';
        };
      })
      ({
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

