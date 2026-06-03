{ lib, pkgs }:
let
  inherit (lib) elem foldl';

  getDeps = item: acc: cb:
    if elem item acc
    then acc
    else let
      next = cb item;
      nextVisited = acc ++ [ item ];
    in foldl' (acc: dep: getDeps dep acc cb) nextVisited next;

  e = builtins.trace getDeps;
in e

