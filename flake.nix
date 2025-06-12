{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @ inputs: {
    homeModules = {
      default = self.homeModules.lite-xl;
      lite-xl = import ./modules;
    };

    # Dummy system for testing the module system. Please do not use.
    # nixosConfigurations.test = inputs.nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     ./modules
    #     ({
    #       programs.lite-xl = {
    #         enable = true;
    #         plugins = {
    #           enableList = [ "lsp_snippets" "terminal" "autoinsert" "autowrap" "bracketmatch" "editorconfig" "gitdiff_highlight" "treeview-extender" ];
    #           languages.enableList = [ "containerfile" "nim" "nix" "zig" ];
    #           formatter.enableList = [ "black" "ruff" ];
    #           lsp.enableList = [ "lua" "yaml" ];
    #           evergreen.enableList = [ "cpp" "javascript" "lua" ];
    #         };
    #         libraries.enableList = [ "encoding" "font_symbols_nerdfont_mono_regular" "tree_sitter" "widget" ];
    #       };
    #     })
    #   ];
    # };
  };
}

