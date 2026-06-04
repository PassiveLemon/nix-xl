{ src
, stdenv
, nerd-fonts
}:
stdenv.mkDerivation {
  name = "symbols_nerdfont_mono_regular";
  inherit src;
  
  buildPhase = "";
  
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ${nerd-fonts.symbols-only}/share/fonts/truetype/NerdFonts/Symbols/SymbolsNerdFontMono-Regular.ttf $out/
    cp $src/plugins/font_symbols_nerdfont_mono_regular.lua $out/init.lua

    runHook postInstall
  '';
}

