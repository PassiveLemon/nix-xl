{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types attrNames getAttrs concatMapStrings mapAttrs' nameValuePair mergeAttrsList length;
  cfg = config.programs.lite-xl;

  supportedEvergreens = import ./languages.nix { inherit config lib pkgs; };
  evergreenStrings = attrNames supportedEvergreens;

  customEnableList = cfg.plugins.evergreen.customEnableList;

  # Filter loaded languages
  enableList = cfg.plugins.evergreen.enableList;
  userEvergreens = getAttrs enableList supportedEvergreens;
  finalEvergreens = mergeAttrsList [ userEvergreens customEnableList ];

  # Map finalEvergreens attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/evergreen_languages/evergreen_lang1.lua" = { source = "<source1>"; }
  #   "lite-xl/plugins/evergreen_languages/evergreen_lang2.lua" = { source = "<source2>"; }
  #   "lite-xl/plugins/evergreen_languages/evergreen_lang3.lua" = { source = "<source3>"; }
  # }
  namedEvergreenPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/evergreen_languages/evergreen_${name}" { source = source; })
    finalEvergreens;

  # Concat userLanguage list for lua script
  # -> ",lang1,,lang2,,lang3,"
  finalEvergreenStrings = attrNames finalEvergreens;
  concatEvergreens = concatMapStrings (lang: ",${lang},") finalEvergreenStrings;
in
{
  options = {
    programs.lite-xl.plugins.evergreen = {
      enableList = mkOption {
        type = types.listOf (types.enum evergreenStrings);
        default = [ ];
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
      inheritLanguages = mkEnableOption "inheriting languages for Evergreen";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mergeAttrsList [
      namedEvergreenPaths
      (mkIf (length finalEvergreenStrings > 0) {
        # Script to load languages since they are not placed top-level
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

