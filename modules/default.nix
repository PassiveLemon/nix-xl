{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption mkOption types maintainers;
  cfg = config.programs.lite-xl;

  libNXL = import ./lib.nix { inherit config lib pkgs; };
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
    (libNXL.subImport ./colors)
    (libNXL.subImport ./fonts)
    (libNXL.subImport ./libraries)
    (libNXL.subImport ./plugins)
  ];

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}

