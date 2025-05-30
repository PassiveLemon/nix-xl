{ pkgs, ... }:
let
  inherit (pkgs) fetchgit;
in
# Language structure
# "<lang>" = "<source>";
{
  "containerfile" = (fetchgit {
    url = "https://github.com/FilBot3/lite-xl-language-containerfile";
    rev = "ae4eddc3f3fa1a0db56344b3b6db0ec0f2283880";
    hash = "sha256-YbwF5O2QrSrBeYzrkMCgIVIY83ULpKM8CygoiigUJj8=";
  }) + "/init.lua";
  "crystal" = (fetchgit {
    url = "https://github.com/Tamnac/lite-plugin-crystal";
    rev = "9514ec08d0bd3aa5d3bcbf8307c4bf5a46ef1a94";
    hash = "sha256-JLkk4z2FaDDyZhiCz9AkQ0Ac7dltDgfB0yEqIu6/h5U=";
  }) + "/language_crystal.lua";
  "ksy" = (fetchgit {
    url = "https://github.com/whiteh0le/lite-plugins";
    rev = "8ad4bf27354ad02b9179b4a5f26f768e2208ace2";
    hash = "sha256-d2oLmniqMVjme77OSyXbbtywmo+bIyHFn4SK1252KeY=";
  }) + "/plugins/language_ksy.lua";
  "pony" = (fetchgit {
    url = "https://github.com/MrAnyx/lite-plugin-pony";
    rev = "34d9ec673eaa6c409bcef0febaa0a36cc3acdf4e";
    hash = "sha256-v33M1pYIh3VNzzcCYBpQ3BAu+pFJAytDd1VssEqOU1Q=";
  }) + "/language_pony.lua";
  "vale" = (fetchgit {
    url = "https://github.com/pgmtx/lite-plugin-vale";
    rev = "faa75f67b093978ceebc31bb7db8aa297f3c3e52";
    hash = "sha256-L3lyvBEHu5BsA+7cBeEjpXWhYhQ6xb+yVBMkoPd45IQ=";
  }) + "/language_vale.lua";
  "yuescript" = (fetchgit {
    url = "https://codeberg.org/pgmtx/lite-plugin-yuescript/";
    rev = "0b0a68c8a2066b8270b2e85d94711c2eb033410e";
    hash = "sha256-FvjIQD4a8rk8wt2R4CEXDjevrXV5SopoqVDp3tMSDw0=";
  }) + "/language_yuescript.lua";
}

