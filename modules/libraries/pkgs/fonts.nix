{ pkgs, ... }:
let
  inherit (pkgs) fetchgit stdenv;

  lxl = fetchgit {
    url = "https://github.com/lite-xl/lite-xl-plugins";
    rev = "499961ac9d08c803c814244e36b2174e9494b532";
    hash = "sha256-hhohhW2kC8oBTk3RYW/V9rFzgSJJqseUkDApHv+oBsY=";
  };

  # TODO: Build nonicons because it is not in Nixpkgs
  # https://github.com/ya2s/nonicons/
in
{
  "font_nonicons" = stdenv.mkDerivation {
    name = "nonicons";
    src = lxl;
    
    buildPhase = "";
    
    installPhase = ''
      runHook preInstall

      mkdir $out
      cp $src/plugins/font_nonicons.lua $out/init.lua

      runHook postInstall
    '';
  };
  "font_symbols_nerdfont_mono_regular" = stdenv.mkDerivation {
    name = "symbols_nerdfont_mono_regular";
    src = lxl;
    
    buildPhase = "";
    
    installPhase = ''
      runHook preInstall

      mkdir $out
      cp ${pkgs.nerd-fonts.symbols-only}/share/fonts/truetype/NerdFonts/Symbols/SymbolsNerdFontMono-Regular.ttf $out/
      cp $src/plugins/font_symbols_nerdfont_mono_regular.lua $out/init.lua

      runHook postInstall
    '';
  };
}

