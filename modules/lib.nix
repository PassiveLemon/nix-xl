{ config, lib, pkgs, ... }:
let
  inherit (lib) extend removePrefix;
  inherit (pkgs) callPackage;
in
extend (final: _: {
  subImport = path: import path {
    inherit config pkgs;
    lib = final;
  };

  getPackage = pname: pkgs: (pkgs.callPackage ../_sources/generated.nix { }).${pname};

  packager = package: path:
    callPackage path {
      inherit (package) src;
      version = removePrefix "v" package.version;
    };

  packagerGit = package: path:
    callPackage path { inherit (package) version src; };
})

