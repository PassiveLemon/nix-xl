{ config, lib, pkgs, ... }:
let
  inherit (lib) extend removePrefix genAttrs mergeAttrsList mapAttrs' nameValuePair hasSuffix concatMapStrings elem foldl' flatten;
  cfg = config.programs.lite-xl;
in
extend (final: _: {
  # Shortcut to import modules with the custom lib
  subImport = path: import path {
    inherit config pkgs;
    lib = final;
  };

  # Add our custom packages to the lib for easy access
  NXLPkgs = final.subImport ../pkgs;

  # Get packages from nvfetcher
  getPackage = pname: pkgs: (pkgs.callPackage ../_sources/generated.nix { }).${pname};
  getPackageSrc = pname: pkgs: (final.getPackage pname pkgs).src;

  # Version formatting
  versionRemovePrefix = version: removePrefix "v" version;
  versionGitDateToUnstable = date: "0-unstable-${date}";

  # Get the appropriately formatted version from an nvfetcher source
  versionFromPackage = pkg:
    if pkg ? "date"
    then final.versionGitDateToUnstable pkg.date
    else final.versionRemovePrefix pkg.version;

  # Call a package with a source from nvfetcher
  packager = pname: path: pkgs:
    let
      pkg = final.getPackage pname pkgs;
      src = pkg.src;
      version = final.versionFromPackage pkg;
    in
    pkgs.callPackage path { inherit version src; };

  # Override a package with a source from nvfetcher
  overlayPackager = pname: overridePkg: pkgs:
    let
      pkg = final.getPackage pname pkgs;
      src = pkg.src;
      version = final.versionFromPackage pkg;
    in
    pkgs.${overridePkg}.overrideAttrs { inherit version src; };

  # Generate attrset of names to a source
  # -> {
  #   name1 = "<source1>.lua";
  #   name2 = "<source2>/";
  # }
  genPaths = source: names: genAttrs names (plugin: "${source}${plugin}.lua");

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
    if cfg.depRes
    then
      if elem item acc
      then acc
      else let
        next = cb item acc;
        nextVisited = acc ++ [ item ];
      in
      foldl' (acc: dep: final.getDeps dep acc cb) nextVisited next
    else [ item ];

  # Maps each item in a list to getDeps with a callback function predicate
  mapGetDeps = items: cb: flatten (map (item: (final.getDeps item [ ] cb)) items);
})

