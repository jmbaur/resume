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
      in
      rec {
        packages.resume = pkgs.stdenvNoCC.mkDerivation {
          pname = "resume";
          version = "2022-01-22";
          src = builtins.path { path = ./.; };
          buildPhase = ''
            ${pkgs.texlive.combined.scheme-medium}/bin/latexmk -pdf resume.tex
          '';
          installPhase = ''
            cp resume.pdf $out
          '';
        };
        defaultPackage = packages.resume;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            entr
            fd
            texlive.combined.scheme-medium
            (pkgs.writeShellScriptBin "run" ''
              ${pkgs.fd}/bin/fd -e tex | ${pkgs.entr}/bin/entr -c \
                ${pkgs.texlive.combined.scheme-medium}/bin/latexmk -pdf resume.tex
            '')
          ];
        };
      });
}
