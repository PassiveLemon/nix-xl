{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption literalExpression types maintainers;
  cfg = config.programs.lite-xl;
in
{
  options = {
    _debug = mkOption {
      type = types.anything;
      default = "";
    };
    programs.lite-xl = {
      enable = mkEnableOption "lite-xl";
    };
  };

  imports = [
    ./languages.nix
  ];

  config = mkIf cfg.enable {
    # xdg.configFile = {
    #   "openvr/openvrpaths.vrpath" = mkIf cfg.openvrRuntimeOverride.enable {
    #     text = "";
    #   };
    # };

    # home.packages = mkIf cfg.enable [
    #   pkgs.lite-xl
    # ];
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}

