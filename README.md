# nix-xl

Declaratively configure Lite-XL plugins and libraries.

This project is a HUGE WIP. Do not expect much for a while.

# Usage
Nix-XL is currently only supported as a home-manager module. It will not work in a NixOS configuration.

Add the flake to your inputs:
```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-xl.url = "github:passivelemon/nix-xl";
  };

  outputs = { ... } @ inputs: {
    # ...
  };
}
```

Import the module and enable it:
```nix
# home.nix
{
  imports = [
    inputs.nix-xl.homeManagerModules.nix-xl
  ];
  
  programs.lite-xl = {
    enable = true;
  };
}
```

Todo:
- [ ] Implement languages
  - [ ] Some languages are not in the plugins repo so we need to either manually reference them or allow the user to define new plugins
  - [x] Put them into their own `/plugins/languages` directory and create a lua file to require them
- [ ] Implement plugins
  - [ ] Some plugins are not in the plugins repo so we need to either manually reference them or allow the user to define new plugins
- [ ] Implement libraries
  - [ ] Some plugins are not in the plugins repo so we need to either manually reference them or allow the user to define new plugins

- [ ] Evergreen
  - [ ]? Build the SO's ourself
  - [ ] Put Evergreen highlights into their own `/plugins/evergreen_languages` directory and create a lua file to require them

- [ ] When finished, fix up "lite-xl-test" to "lite-xl"
  - Present in languages.nix

