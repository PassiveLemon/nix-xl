{ config, lib, ... }:
let
  inherit (lib) foldl' isList foldAttrs head flatten;
  inherit (lib) subImport; # Custom
  cfg = config.programs.lite-xl;

  depsList = subImport ./deps.nix;

  pluginEnableList = cfg.plugins.enableList;
  libraryEnableList = cfg.libraries.enableList;

  collapseTree = tree:
    if isList tree.plugins
    then tree
    else let
      next = tree.plugins;
      newTree = {
        libraries = tree.libraries ++ next.libraries;
        plugins = next.plugins;
      };
    in collapseTree newTree;    

  getDeps = item: type: p-acc: l-acc:
    let
      nextPlugins = depsList.${type}.${item}.plugins;
      nextLibraries = depsList.${type}.${item}.libraries;
    in
      if type == "plugins"
      then let
        # Accumulate dependencies from each recursion iteration
        accPlugins = (
          if isList p-acc
          then p-acc ++ [ item ]
          else (collapseTree p-acc).plugins ++ [ item ]
        );
        accLibraries = l-acc;
      in {
        plugins = foldl' (acc: dep: getDeps dep "plugins" acc accLibraries) accPlugins nextPlugins;
        libraries = foldl' (acc: dep: getDeps dep "libraries" accPlugins acc) accLibraries nextLibraries;
      } else let
        # Libraries likely shouldn't depend on plugins so we skip checking for that
        # If this is implemented, then collapseTree would need to be refactored
        accLibraries = l-acc ++ [ item ];
      in
      foldl' (acc: dep: getDeps dep "libraries" p-acc accLibraries) accLibraries nextLibraries;

  resolveDeps = plugin: type:
    collapseTree (head (flatten (getDeps plugin type [ ] [ ])));

  mergeDeps = list:
    foldAttrs (item: acc: item ++ acc) [ ] list;

  mapResolveDeps = items: type:
    mergeDeps (map (item: (resolveDeps item type)) items);

  resolvedPlugins = mapResolveDeps pluginEnableList "plugins";
  resolvedLibraries = mapResolveDeps libraryEnableList "libraries";
in
mergeDeps [
  resolvedPlugins
  resolvedLibraries
]

