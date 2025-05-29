{ config, lib, pkgs, ... }:
let
  inherit (lib) any elem mergeAttrsList;
  inherit (pkgs) fetchgit fetchFromGitHub;
  cfg = config.programs.lite-xl;

  lsp = fetchgit {
    url = "https://github.com/lite-xl/lite-xl-lsp-servers";
    rev = "6eea7cf124baad8e7abad6e388c7a16f6f6a98f2";
    hash = "sha256-rKhltQ9uGnT5PJPmotxMxQm6xNO9y14klCdae8aNXcU=";
  };

  # With the way this is currently designed, all packages with dependencies
  # have to be defined in here.

  # If json did not check for "lsp_snippets", it would not be loaded if the
  # "lsp_snippets" plugin was specified because the loading of "snippets"
  # does not propagate back to this check.

  # Custom plugins also won't be checked.

  # Plugins
  json = (
    # Or user manually specifies json?
    if (any (str: elem str [ "snippets" "lsp_snippets" ]) cfg.plugins)
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
  snippets = (
    if (any (str: elem str [ "snippets" "lsp_snippets" ]) cfg.plugins)
    then {
      "snippets" = (fetchgit {
        url = "https://github.com/vqns/lite-xl-snippets";
        rev = "87248a23c8ceb2507f46b3ca3689b32d35c9c709";
        hash = "sha256-FSZTm5bpQKUfPsjwmat9NVrQg9HWil9kFWiBFFnEWJA=";
      }) + "/snippets.lua";
    }
    else { }
  );

  # LSP Servers
  golang = (
    # Or user manually specifies json?
    if (any (str: elem str [ "go" ]) cfg.lspServers)
    then {
      "golang" = lsp + "/libraries/golang.lua";
    }
    else { }
  );
  haxe = (
    # Or user manually specifies json?
    if (any (str: elem str [ "haxe" ]) cfg.lspServers)
    then {
      "haxe" = lsp + "/libraries/haxe.lua";
    }
    else { }
  );
  jdk = (
    # Or user manually specifies json?
    if (any (str: elem str [ "java" ]) cfg.lspServers)
    then {
      "jdk" = lsp + "/libraries/jdk.lua";
    }
    else { }
  );
  nodejs = (
    # Or user manually specifies json?
    if (any (str: elem str [ "emmet" " haxe" "json" "python" "typescript" "yaml" ]) cfg.lspServers)
    then {
      "nodejs" = lsp + "/libraries/nodejs.lua";
    }
    else { }
  );
in
{
  libraries = mergeAttrsList [
    json
    golang
    haxe
    jdk
    nodejs
  ];
  plugins = mergeAttrsList [
    snippets
  ];
}

