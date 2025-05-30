{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types maintainers;
  cfg = config.programs.lite-xl;
in
{
  options = {
    programs.lite-xl = {
      enable = mkEnableOption "lite-xl";
    };

    # Don't use this, this is for dev purposes
    programs.lite-xl._debug = mkOption {
      type = types.anything;
      default = "";
    };
  };

  imports = [
    ./libraries
    ./plugins
  ];

  config = mkIf cfg.enable {
    home.packages = mkIf cfg.enable [
      pkgs.lite-xl
    ];
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}

