# nix-xl

Declaratively configure Lite-XL plugins and libraries from [lite-xl-plugins](https://github.com/lite-xl/lite-xl-plugins) and listed external repositories.

This project is a HUGE WIP.

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

# Todo
Core:
- [x] Implement languages
  - [x] Put them into their own `/plugins/languages` directory and create a lua file to require them
  - [x] External repo languages
  - [ ] Custom languages

- [ ] Implement libraries (WIP)
  - [ ] Most libraries require some package building so we need some derivations
  - [ ] External repo libraries
  - [ ] Custom libraries

- [ ] Implement plugins
  - [ ] External repo plugins
  - [ ] Custom plugins

General:
- [ ] nvfetcher to update plugin versions. Check every couple days or so since plugins aren't updated too frequently

- [ ] Config/init declaration

- When finished, fix up "lite-xl-test" path to "lite-xl". Currently present in languages.nix, libraries.nix

Other:
- [ ] Evergreen
  - [ ] Need to build the shared objects so we need some derivations
  - [ ] Put Evergreen highlights into their own `/plugins/evergreen_languages` directory and create a lua file to require them (Similar to languages)
  - [ ] Custom languages

