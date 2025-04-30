{
  description = "jmbaur-resume";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      forEachSystem =
        f:
        inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
          system:
          f (
            import inputs.nixpkgs {
              inherit system;
              overlays = [
                (final: prev: {
                  tex = final.texlive.combine {
                    inherit (final.texlive)
                      scheme-basic
                      latexmk
                      preprint
                      marvosym
                      titlesec # verbatim
                      enumitem
                      fancyhdr
                      ;
                  };
                })
              ];
            }
          )
        );
    in
    {
      packages = forEachSystem (pkgs: {
        default = pkgs.callPackage (
          { runCommand, tex }:
          runCommand "jmbaur-resume" { nativeBuildInputs = [ tex ]; } ''
            latexmk -pdf ${./resume.tex}
            install -Dm0644 *.pdf $out/resume.pdf
          ''
        ) { };
      });
      apps = forEachSystem (pkgs: {
        default = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "run" ''
              ${pkgs.fd}/bin/fd -e tex | ${pkgs.entr}/bin/entr -c \
                ${pkgs.tex}/bin/latexmk -pdf resume.tex
            ''
          );
        };
      });
    };
}
