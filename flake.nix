{
  description = "resume";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  outputs = inputs:
    let
      forEachSystem = f: inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: f {
        inherit system;
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              tex = prev.texlive.combine {
                inherit (prev.texlive) scheme-basic latexmk
                  preprint marvosym titlesec/*verbatim*/ enumitem fancyhdr
                  ;
              };
            })
          ];
        };
      });
    in
    {
      packages = forEachSystem ({ pkgs, ... }: {
        default = pkgs.runCommand "resume-2022-01-22"
          { src = ./.; } ''
          mkdir -p $out
          ${pkgs.tex}/bin/latexmk -pdf $src/resume.tex
          cp resume.pdf $out
        '';
      });
      devShells = forEachSystem
        ({ pkgs, ... }: {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.tex
              (pkgs.writeShellScriptBin "run" ''
                ${pkgs.fd}/bin/fd -e tex | ${pkgs.entr}/bin/entr -c \
                  ${pkgs.tex}/bin/latexmk -pdf resume.tex
              '')
            ];
          };
        });
    };
}
