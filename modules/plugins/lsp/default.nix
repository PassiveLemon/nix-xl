{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types attrNames getAttrs concatMapStrings mapAttrs' nameValuePair mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedServers = import ./servers.nix { inherit lib pkgs; };
  serverStrings = attrNames supportedServers;

  customEnableList = cfg.plugins.lsp.customEnableList;

  # Filter loaded servers
  enableList = cfg.plugins.lsp.enableList;
  userServers = getAttrs enableList supportedServers;
  finalServers = mergeAttrsList [ userServers customEnableList ];

  # Map finalServers attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/lsp_servers/lsp_lang1.lua" = { source = "<source1>"; }
  #   "lite-xl/plugins/lsp_servers/lsp_lang2.lua" = { source = "<source2>"; }
  #   "lite-xl/plugins/lsp_servers/lsp_lang3.lua" = { source = "<source3>"; }
  # }
  namedLspPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/lsp_servers/lsp_${name}.lua" { source = source; })
    finalServers;

  # Concat userLsps list for lua script
  # -> ",serv1,,serv2,,serv3,"
  finalServerStrings = attrNames finalServers;
  concatServers = concatMapStrings (serv: ",${serv},") finalServerStrings;
in
{
  options = {
    programs.lite-xl.plugins.lsp = {
      enableList = mkOption {
        type = types.listOf (types.enum serverStrings);
        default = [ ];
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
      inheritLanguages = mkEnableOption "inheriting languages for LSP";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mergeAttrsList [
      namedLspPaths
      ({
        # Script to load servers since they are not placed top-level
        "lite-xl/plugins/lsp_servers/init.lua" = {
          text = ''
            -- mod-version: 3

            local servers = '${concatServers}'

            -- Match server strings in ",serv1,,serv2,,serv3,"
            for serv in servers:gmatch(",([%w_]+),") do
              require("plugins.lsp_servers.lsp_" .. serv)
            end
          '';
        };
      })
    ];
  };
}

