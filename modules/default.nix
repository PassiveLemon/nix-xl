{ self, ... }: {
  flake = {
    homeModules = {
      default = self.homeModules.nix-xl;
      nix-xl = import ./module.nix;
    };
  };
}

