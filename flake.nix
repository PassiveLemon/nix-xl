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

    # nixosConfigurations.test = inputs.nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     ./modules
    #     ({
    #       programs.lite-xl = {
    #         enable = true;
    #         languages = [ "containerfile" "nim" "nix" "zig" ];
    #         libraries = [ "encoding" "font_symbols_nerdfont_mono_regular" "tree_sitter" "widget" ];
    #         plugins = [ "snippets" "terminal" "autoinsert" "autowrap" "bracketmatch" "editorconfig" "gitdiff_highlight" "treeview_extender" ];
    #         formatters = [ "black" "ruff" ];
    #         lspServers = [ "lua" "yaml" ];
    #       };
    #     })
    #   ];
    # };
  };
}

