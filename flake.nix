{
  description = "resume";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        texlive = pkgs.texlive.combined.scheme-full;
      in
      rec {
        packages.resume = pkgs.stdenvNoCC.mkDerivation {
          pname = "resume";
          version = "2022-01-22";
          src = builtins.path { path = ./.; };
          buildPhase = ''
            ${texlive}/bin/latexmk -pdf resume.tex
          '';
          installPhase = ''
            cp resume.pdf $out
          '';
        };
        defaultPackage = packages.resume;
        devShell = pkgs.mkShell {
          buildInputs = [
            texlive
            (pkgs.writeShellScriptBin "run" ''
              ${pkgs.fd}/bin/fd -e tex | ${pkgs.entr}/bin/entr -c \
                ${texlive}/bin/latexmk -pdf resume.tex
            '')
          ];
        };
      });
}
