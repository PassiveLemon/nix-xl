{ config, lib, pkgs, ... }:
let
  inherit (lib) genNamedFiles mkLuaScript mkIf mkOption types attrNames getAttrs mergeAttrsList optionalAttrs length;
  cfg = config.programs.lite-xl;

  supportedEvergreens = import ./languages.nix { inherit config lib pkgs; };
  evergreenStrings = attrNames supportedEvergreens;

  customEnableList = cfg.plugins.evergreen.customEnableList;

  enableList = cfg.plugins.evergreen.enableList;
  userEvergreens = getAttrs enableList supportedEvergreens;
  finalEvergreens = mergeAttrsList [ userEvergreens customEnableList ];

  namedEvergreenPaths = genNamedFiles "lite-xl/plugins/evergreen_languages/evergreen_" finalEvergreens;

  finalEvergreenStrings = attrNames finalEvergreens;
  concatEvergreens = mkLuaScript finalEvergreenStrings;
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

