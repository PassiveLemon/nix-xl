{
  description = "Nix-xl";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @ inputs: {
    homeManagerModules = {
      default = self.homeManagerModules.lite-xl;
      lite-xl = import ./modules;
    };

    nixosConfigurations.test = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules
        ({
          programs.lite-xl = {
            enable = true;
            plugins = {
              enableList = [ "snippets" "terminal" "autoinsert" "autowrap" "bracketmatch" "editorconfig" "gitdiff_highlight" "treeview_extender" ];
              languages.enableList = [ "containerfile" "nim" "nix" "zig" ];
              formatter.enableList = [ "black" "ruff" ];
              lsp.enableList = [ "lua" "yaml" ];
              evergreen.enableList = [ "cpp" "javascript" "lua" ];
            };
            libraries.enableList = [ "encoding" "font_symbols_nerdfont_mono_regular" "tree_sitter" "widget" ];
          };
        })
      ];
    };
  };
}

