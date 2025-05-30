{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs concatMapStrings mapAttrs' nameValuePair mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLsps = import ./servers.nix { inherit lib pkgs; };

  lspStrings = attrNames supportedLsps;

  customLspServers = cfg.plugins.lsp.customEnableList;

  # Filter loaded servers
  configLsps = cfg.plugins.lsp.enableList;
  userLsps = getAttrs configLsps supportedLsps;
  finalLsps = mergeAttrsList [ userLsps customLspServers ];

  # Map supportedLsps attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/lsp_servers/lsp_lang1.lua" = { source = "<source1>"; }
  #   "lite-xl/plugins/lsp_servers/lsp_lang2.lua" = { source = "<source2>"; }
  #   "lite-xl/plugins/lsp_servers/lsp_lang3.lua" = { source = "<source3>"; }
  # }
  namedLspPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/lsp_servers/lsp_${name}.lua" { source = source; })
    finalLsps;

  # Concat userLsps list for lua script
  # -> ",serv1,,serv2,,serv3,"
  finalLspStrings = attrNames finalLsps;
  concatLsps = concatMapStrings (serv: ",${serv},") finalLspStrings;
in
{
  options = {
    programs.lite-xl.plugins.lsp = {
      enableList = mkOption {
        type = types.listOf (types.enum lspStrings);
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
      namedLspPaths
      ({
        # Script to load servers since they are not placed top-level
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
    ];
  };
}

