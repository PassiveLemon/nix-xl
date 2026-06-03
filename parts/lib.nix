{ config, lib, pkgs, ... }:
let
  inherit (lib) extend removePrefix genAttrs mergeAttrsList;
in
extend (final: _: {
  subImport = path: import path {
    inherit config pkgs;
    lib = final;
  };

  NXLPkgs = final.subImport ../pkgs;

  getPackage = pname: pkgs: (pkgs.callPackage ../_sources/generated.nix { }).${pname};
  getPackageSrc = pname: pkgs: (final.getPackage pname pkgs).src;

  versionRemovePrefix = version:
    removePrefix "v" version;

  versionGitDateToUnstable = date:
    "0-unstable-${date}";

  versionFromPackage = pkg: (
    if pkg ? "date"
    then final.versionGitDateToUnstable pkg.date
    else final.versionRemovePrefix pkg.version
  );

  packager = pname: path: pkgs: let
    pkg = final.getPackage pname pkgs;
    src = pkg.src;
    version = final.versionFromPackage pkg;
  in pkgs.callPackage path { inherit version src; };

  overlayPackager = pname: overridePkg: pkgs: let
    pkg = final.getPackage pname pkgs;
    src = pkg.src;
    version = final.versionFromPackage pkg;
  in pkgs.${overridePkg}.overrideAttrs { inherit version src; };

  genPluginPaths = source: files: dirs: external: let
    pluginFiles = genAttrs files (plugin: "${source}${plugin}.lua");
    pluginDirs = genAttrs dirs (plugin: "${source}${plugin}");
  in mergeAttrsList [
    pluginFiles
    pluginDirs
    external
  ];
})

