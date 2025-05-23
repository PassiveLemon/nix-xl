{
  description = "Nix-xl";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    lite-xl-plugins = {
      url = "github:lite-xl/lite-xl-plugins";
      flake = false;
    };
    # lite-xl-lintplus = {
    #   url = "github:liquidev/lintplus";
    #   flake = false;
    # };
    # lite-xl-evergreen = {
    #   url = "github:evergreen-lxl/evergreen.lxl";
    #   flake = false;
    # };
    # lite-xl-treeview-extender = {
    #   url = "github:juliardi/lite-xl-treeview-extender";
    #   flake = false;
    # };
    # lite-xl-lsp = {
    #   url = "github:lite-xl/lite-xl-lsp";
    #   flake = false;
    # };
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
            languages = [ "containerfile" "nim" "nix" "zig" ];
            libraries = [ "encoding" "font_symbols_nerdfont_mono_regular" "tree_sitter" "widget" ];
            plugins = [ "snippets" "terminal" "autoinsert" "autowrap" "bracketmatch" "editorconfig" "gitdiff_highlight" "treeview_extender" ];
          };
        })
      ];
      specialArgs = { inherit inputs; };
    };
  };
}

