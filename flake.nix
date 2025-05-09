{
  description = "jmbaur-resume";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = inputs: {
    packages = inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: {
      default = (import inputs.nixpkgs { inherit system; }).callPackage (
        {
          stdenvNoCC,
          texlive,
          lib,
        }:
        stdenvNoCC.mkDerivation {
          pname = "jmbaur-resume";
          version = "2025-05-08";

          src = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./Makefile
              ./resume.tex
            ];
          };

          nativeBuildInputs = [
            (texlive.combine {
              inherit (texlive)
                scheme-basic
                preprint
                marvosym
                titlesec # verbatim
                enumitem
                fancyhdr
                ;
            })
          ];

          postConfigure = ''
            export TEXMFVAR=$TEMPDIR
          '';

          installPhase = ''
            runHook preInstall
            install -Dm0644 resume.pdf $out/resume.pdf
            runHook postInstall
          '';
        }
      ) { };
    });
  };
}
