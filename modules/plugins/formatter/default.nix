{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs concatMapStrings mapAttrs' nameValuePair mergeAttrsList optionalAttrs length;
  cfg = config.programs.lite-xl;

  supportedFormatters = import ./formatters.nix { inherit lib pkgs; };
  formatterStrings = attrNames supportedFormatters;

  customEnableList = cfg.plugins.formatter.customEnableList;

  # Filter loaded formatters
  enableList = cfg.plugins.formatter.enableList;
  userFormatters = getAttrs enableList supportedFormatters;
  finalFormatters = mergeAttrsList [ userFormatters customEnableList ];

  # Map finalFormatters attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/formatters/formatter_1.lua" = { source = "<source1>"; }
  #   "lite-xl/plugins/formatters/formatter_2.lua" = { source = "<source2>"; }
  #   "lite-xl/plugins/formatters/formatter_3.lua" = { source = "<source3>"; }
  # }
  namedFormatterPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/formatters/formatter_${name}.lua" { source = source; })
    finalFormatters;

  # Concat userFormatters list for lua script
  # -> ",form1,,form2,,form3,"
  finalFormatterStrings = attrNames finalFormatters;
  concatFormatters = concatMapStrings (form: ",${form},") finalFormatterStrings;
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
        # Script to load formatters since they are not placed top-level
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

