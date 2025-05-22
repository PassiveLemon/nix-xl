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
    ./languages
  ];

  config = mkIf cfg.enable {
    # home.packages = mkIf cfg.enable [
    #   pkgs.lite-xl
    # ];
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}

