{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types mapAttrsToList optionalAttrs length flatten optional elem;
  inherit (lib) mkLuaScript; # Custom
  cfg = config.programs.lite-xl;

  # https://github.com/lite-xl/lite-xl-lsp/blob/master/config.lua
  serverStrings = [
    "bashls" "dockerls" "nillsp" "nimlsp" "pyright" "sumneko_lua" "yamlls"
  ];

  enableList = cfg.plugins.lsp.enableList;

  concatServers = mkLuaScript enableList;

  # Generate a list (nested: [["1"] ["2"] ["3"]]) of packages (language-servers and linters) based on what lsp languages the user specified
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
      addPackages = mkEnableOption "adding language servers and linters";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = optionalAttrs (length enableList > 0) {
      "lite-xl/plugins/lsp_servers/init.lua" = {
        text = ''
          -- mod-version: 3
          local lspconfig = require "plugins.lsp.config"
          local servers = '${concatServers}'

          -- Match server strings in ",serv1,,serv2,,serv3,"
          for serv in servers:gmatch(",([%w_]+),") do
            lspconfig[serv].setup()
          end
        '';
      };
    };
    # Add language servers and linters dynamically
    home.packages = flatten (optional cfg.plugins.lsp.addPackages [
      (genPackages (with pkgs; {
        # Language servers
        "dockerls" = dockerfile-language-server;
        "sumneko_lua" = lua-language-server;
        "nimlsp" = nimlsp;
        "nillsp" = nil;
        "pyright" = pyright;
        "bashls" = bash-language-server;
        "yamlls" = yaml-language-server;
      }))
      (genPackages (with pkgs; {
        # Linters
        "sumneko_lua" = luajitPackages.luacheck;
        "pyright" = python312Packages.flake8;
        "bashls" = shellcheck;
      }))
    ]);
  };
}

