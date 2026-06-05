{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption maintainers;
  cfg = config.programs.lite-xl;

  NXL = import ../parts/lib.nix { inherit config lib pkgs; };
  inherit (NXL) subImport;
in
{
  options = {
    programs.lite-xl = {
      enable = mkEnableOption "lite-xl";
      package = mkPackageOption pkgs "lite-xl" { };
      depRes = mkEnableOption "automatic dependecy resolution" // { default = true; };
    };
  };

  imports = [
    (subImport ./fonts)
    (subImport ./libraries)
    (subImport ./plugins)
  ];

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}

