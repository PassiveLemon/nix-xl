{ config, lib, pkgs, ... }:
let
  inherit (lib) any mergeAttrsList;
  inherit (pkgs) fetchFromGitHub;
  cfg = config.programs.lite-xl;

  json = (
    # Or user manually specifies json?
    if (any (str: str == "snippets") cfg.plugins)
    then {
      "json" = (fetchFromGitHub {
        owner = "rxi";
        repo = "json.lua";
        rev = "dbf4b2dd2eb7c23be2773c89eb059dadd6436f94";
        hash = "sha256-BrM+r0VVdaeFgLfzmt1wkj0sC3dj9nNojkuZJK5f35s=";
      }) + "/json.lua";
    }
    else { }
  );
in
{
  libraries = mergeAttrsList [
    json
  ];
  plugins = mergeAttrsList [ ];
}

