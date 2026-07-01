{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types intersectLists subtractLists optionals mapAttrsToList optionalAttrs length flatten optional elem;
  inherit (lib) mkLuaScript; # Custom
  cfg = config.programs.lite-xl;
  cl = cfg.plugins.lintplus.copyLanguages;

  # https://github.com/liquidev/lintplus/tree/master/linters
  linterStrings = [
    "cppcheck" "luacheck" "moonscript" "nelua" "nim" "php" "python"
    "python" "rust" "shellcheck" "teal" "typescript" "v" "zig"
  ];

  enableList = cfg.plugins.lintplus.enableList;

  languageCopy = intersectLists cfg.plugins.languages.enableList linterStrings;
  filterCopy = subtractLists cl.filter languageCopy;
  copyLanguages = optionals cl.enable filterCopy;

  concatLinters = mkLuaScript enableList;

  # Generate a list (nested: [["1"] ["2"] ["3"]]) of packages
  genPackages = linters: (mapAttrsToList (name: value: optional (elem name enableList) value) linters);
in
{
  options = {
    programs.lite-xl.plugins.lintplus = {
      enableList = mkOption {
        type = types.listOf (types.enum linterStrings);
        description = "The list of linters to enable.";
        default = [ ];
        apply = value: value ++ copyLanguages;
      };
      addPackages = mkEnableOption "adding linter packages";
      copyLanguages = {
        enable = mkEnableOption "copying Lite-XL languages for Lintplus";
        filter = mkOption {
          type = types.listOf types.str;
          description = "The list of languages to not copy.";
          default = [ ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = optionalAttrs (length enableList > 0) {
      "lite-xl/plugins/lintplus_linters/init.lua" = {
        text = ''
          -- mod-version: 3
          local lintplus = require("plugins.lintplus")
          local linter_strings = '${concatLinters}'
          local linters = { }

          -- Match linter strings in ",lint1,,lint2,,lint3,"
          for lint in linter_strings:gmatch(",([%w_]+),") do
            table.insert(linters, lint)
          end

          lintplus.load(linters)
        '';
      };
    };
    # Add linters dynamically
    home.packages = flatten (optional cfg.plugins.lintplus.addPackages [
      (genPackages (with pkgs; {
        "luacheck" = luajitPackages.luacheck;
        "nim" = nim;
        "python" = python312Packages.flake8;
        "shellcheck" = shellcheck;
      }))
    ]);
  };
}

