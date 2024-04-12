let
  pkgs = import <nixpkgs> {};

  texlive = pkgs.texlive.combine {
    inherit (pkgs.texlive)
    scheme-medium
    xcolor
    float
    etoolbox
    extsizes
    titlesec
    enumitem
    parskip

    # Font XCharter
    # https://tug.org/FontCatalogue/xcharter/
    xcharter
    # Manually derived dependencies
    fontspec
    euenc
    xstring
    fontaxes
    ;
  };
in {
  inherit pkgs;
  inherit texlive;

  pages = pkgs.stdenv.mkDerivation {
    name = "cv.maxdaten.io";
    src = ./.;
    phases = [];

    buildInputs = [
      texlive
      pkgs.pandoc
      pkgs.watchexec
    ];
  };
}
