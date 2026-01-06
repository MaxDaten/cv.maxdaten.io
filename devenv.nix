{ pkgs, lib, config, inputs, ... }:

let
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
in
{
  name = "cv.maxdaten.io";

  # Enable devenv's built-in shell activation
  dotenv.disableHint = true;

  packages = [
    texlive
    pkgs.pandoc
    pkgs.watchexec
    pkgs.just
    # Image optimization (converts to WebP)
    pkgs.imagemagick
    # Design preview screenshots
    pkgs.shot-scraper
  ];

  enterShell = ''
    echo "cv.maxdaten.io development environment"
    echo "Run 'just build' to build or 'just watch' for development"
  '';

  # Pre-commit hooks (optional, uncomment if needed)
  # pre-commit.hooks = {
  #   markdownlint.enable = true;
  # };

  # Scripts to make common commands available
  scripts = {
    build.exec = "just build";
    watch.exec = "just watch";
    clean.exec = "just clean";
  };
}
