{ config, lib, pkgs, ... }:
let
  inherit (lib) extend removePrefix genAttrs mergeAttrsList mapAttrs' nameValuePair hasSuffix concatMapStrings elem foldl' flatten map;
in
extend (final: _: {
  subImport = path: import path {
    inherit config pkgs;
    lib = final;
  };

  NXLPkgs = final.subImport ../pkgs;

  getPackage = pname: pkgs: (pkgs.callPackage ../_sources/generated.nix { }).${pname};
  getPackageSrc = pname: pkgs: (final.getPackage pname pkgs).src;

  versionRemovePrefix = version: removePrefix "v" version;

  versionGitDateToUnstable = date: "0-unstable-${date}";

  versionFromPackage = pkg:
    if pkg ? "date"
    then final.versionGitDateToUnstable pkg.date
    else final.versionRemovePrefix pkg.version;

  packager = pname: path: pkgs:
  let
    pkg = final.getPackage pname pkgs;
    src = pkg.src;
    version = final.versionFromPackage pkg;
  in
  pkgs.callPackage path { inherit version src; };

  overlayPackager = pname: overridePkg: pkgs:
  let
    pkg = final.getPackage pname pkgs;
    src = pkg.src;
    version = final.versionFromPackage pkg;
  in
  pkgs.${overridePkg}.overrideAttrs { inherit version src; };

  # Generate attrset of paths to a source
  # -> {
  #   /path/to/path1.lua = "<source1>.lua";
  #   /path/to/path2 = "<source2>/";
  # }
  genPluginPaths = source: files: dirs: external:
  let
    pluginFiles = genAttrs files (plugin: "${source}${plugin}.lua");
    pluginDirs = genAttrs dirs (plugin: "${source}${plugin}");
  in 
  mergeAttrsList [
    pluginFiles
    pluginDirs
    external
  ];

  # Map files attrset to a source
  # -> {
  #   "/path/to/file1.lua" = { source = "<source1>"; }
  #   "/path/to/file2.lua" = { source = "<source2>"; }
  # }
  genNamedFiles = source: files:
    mapAttrs' (name: source':
      nameValuePair "${source}${name}.lua" { source = source'; }
    ) files;

  # Map a paths attrset to a source. Works with files and directories
  # -> {
  #   "/path/to/path1/" = { source = "<source1>/"; recursive = true; }
  #   "/path/to/path2.lua" = { source = "<source2>"; }
  # }
  genNamedPaths = source: paths:
    mapAttrs' (name: source': 
      if hasSuffix ".lua" source'
      then nameValuePair "${source}${name}.lua" { source = source'; }
      else nameValuePair "${source}${name}" { source = source'; recursive = true; }
    ) paths;

  # Concat item list for lua script
  # -> ",item1,,item2,,item3,"
  mkLuaScript = items: concatMapStrings (item: ",${item},") items;

  # Recursively add each dependency to the accumulator list if it's not already. Cb is a callback function predicate that should return the next dependency list
  getDeps = item: acc: cb:
    if elem item acc
    then acc
    else let
      next = cb item;
      nextVisited = acc ++ [ item ];
    in
    foldl' (acc: dep: final.getDeps dep acc cb) nextVisited next;

  # Maps each item in a list to getDeps with a callback function predicate
  mapGetDeps = items: cb: flatten (map (item: (final.getDeps item [ ] cb)) items);
})

