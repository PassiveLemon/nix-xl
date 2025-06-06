{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption mkOption types maintainers;
  cfg = config.programs.lite-xl;
in
{
  options = {
    programs.lite-xl = {
      enable = mkEnableOption "lite-xl";
      package = mkPackageOption pkgs "lite-xl" { };
    };

    # Don't use this, this is for dev purposes
    # programs.lite-xl._debug = mkOption {
    #   type = types.anything;
    #   default = "";
    # };
  };

  imports = [
    ./colors
    ./fonts
    ./libraries
    ./plugins
  ];

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}

