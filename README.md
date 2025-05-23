# nix-xl

Declaratively configure Lite-XL plugins and libraries from [lite-xl-plugins](https://github.com/lite-xl/lite-xl-plugins) and listed external repositories.

This project is a HUGE WIP.

> !NOTE
> I have not tested every single language, plugin, and library combination so there may be incompatibilities, missing features, or other issues.

The only architecture currently supported is `x86_64-linux`. Others may be supported in the future.

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

## Languages

## Plugins

## Libraries

# Todo
Core:
- [x] Implement languages
  - [x] Put them into their own `/plugins/languages` directory and create a lua file to require them
  - [x] External repo languages
  - [x] Custom languages

- [x] Implement libraries
  - [x] Most libraries require some package building so we need some derivations
  - [x] External repo libraries
  - [x] Custom libraries

- [x] Implement plugins
  - [x] External repo plugins
  - [x] Custom plugins
  - [ ] Automatic library dependencies

Plugins:
- [ ] Evergreen
  - [ ] Need to build the shared objects so we need some derivations
  - [ ] Put Evergreen highlights into their own `/plugins/evergreen_languages` directory and create a lua file to require them (Similar to languages)
  - [ ] Custom languages
  - [ ] Inherit syntax languages

- [ ] LSP
  - Libraries `golang haxe jdk nodejs`
  - [ ] Put lsp into their own `/plugins/lsp_languages` directory and create a lua file to require them (Similar to languages)
  - [ ] Custom formats
  - [ ] Inherit syntax languages

- [ ] Formatter
  - [ ] Put formats into their own `/plugins/formatter_languages` directory and create a lua file to require them (Similar to languages)
  - [ ] Custom formats
  - [ ] Inherit syntax languages

General:
- [ ] nvfetcher to update plugin versions. Check every couple days or so since plugins aren't updated too frequently
- [ ] Config/init declaration
- [ ] Fix up "lite-xl-test" path to "lite-xl". Currently present in languages/default.nix, libraries/default.nix, plugins/default.nix

Later:
- Package meta attrs
- Descriptions on module options
- [ ] Switch everything from fetchgit to fetchFromGitHub (if applicable)
- [ ] `nonicons` (TODO: Build nonicons because it is not in Nixpkgs)
- [ ] `www` (TODO: Finish the package. Currently can't be built)

