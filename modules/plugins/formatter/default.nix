{ config, lib, pkgs, ... }:
let
  inherit (lib) genNamedFiles mkLuaScript mkIf mkOption types attrNames getAttrs mergeAttrsList optionalAttrs length;
  cfg = config.programs.lite-xl;

  supportedFormatters = import ./formatters.nix { inherit lib pkgs; };
  formatterStrings = attrNames supportedFormatters;

  customEnableList = cfg.plugins.formatter.customEnableList;

  enableList = cfg.plugins.formatter.enableList;
  userFormatters = getAttrs enableList supportedFormatters;
  finalFormatters = mergeAttrsList [ userFormatters customEnableList ];

  namedFormatterPaths = genNamedFiles "lite-xl/plugins/formatters/formatter_" finalFormatters;

  finalFormatterStrings = attrNames finalFormatters;
  concatFormatters = mkLuaScript finalFormatterStrings;
in
{
  options = {
    programs.lite-xl.plugins.formatter = {
      enableList = mkOption {
        type = types.listOf (types.enum formatterStrings);
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
      namedFormatterPaths
      (optionalAttrs (length finalFormatterStrings > 0) {
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
    ];
  };
}

