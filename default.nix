let
  pkgs = import <nixpkgs> {};

  texlive = pkgs.texlive.combine {
    inherit (pkgs.texlive)
    scheme-basic xcolor float;
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
