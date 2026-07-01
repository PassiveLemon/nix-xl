{ config, lib,  ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types attrNames mapAttrsToList optionalAttrs length flatten optional elem;
  inherit (lib) subImport mkLuaScript; # Custom
  cfg = config.programs.lite-xl;

  serverAttrs = subImport ./pack.nix;
  serverStrings = attrNames serverAttrs;

  enableList = cfg.plugins.lsp.enableList;

  concatServers = mkLuaScript enableList;

  # Generate a list (nested: [["1"] ["2"] ["3"]]) of packages
  genPackages = servers: (mapAttrsToList (name: value: optional (elem name enableList) value) servers);
in
{
  options = {
    programs.lite-xl.plugins.lsp = {
      enableList = mkOption {
        type = types.listOf (types.enum serverStrings);
        description = "The list of LSPs to enable.";
        default = [ ];
      };
      addPackages = mkEnableOption "adding language server packages";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = optionalAttrs (length enableList > 0) {
      "lite-xl/plugins/lsp_servers/init.lua" = {
        text = ''
          -- mod-version: 3
          local lspconfig = require("plugins.lsp.config")
          local servers = '${concatServers}'

          -- Match server strings in ",serv1,,serv2,,serv3,"
          for serv in servers:gmatch(",([%w_]+),") do
            lspconfig[serv].setup()
          end
        '';
      };
    };
    # Add language servers dynamically
    home.packages = flatten (optional cfg.plugins.lsp.addPackages [
      (genPackages serverAttrs)
    ]);
  };
}

