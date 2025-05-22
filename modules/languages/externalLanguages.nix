{ pkgs, ... }:
let
  inherit (pkgs) fetchgit;
in
{
  # Source should be fetched
  # "<name>" = "<source>";
  "containerfile" = (fetchgit {
    url = "https://github.com/FilBot3/lite-xl-language-containerfile";
    rev = "ae4eddc3f3fa1a0db56344b3b6db0ec0f2283880";
    hash = "sha256-YbwF5O2QrSrBeYzrkMCgIVIY83ULpKM8CygoiigUJj8=";
  }) + "/init.lua";
}

