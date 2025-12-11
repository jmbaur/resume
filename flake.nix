{
  description = "jmbaur-resume";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = inputs: {
    packages = inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: {
      default = (import inputs.nixpkgs { inherit system; }).callPackage (
        {
          buildPackages,
          lib,
          stdenvNoCC,
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
            (buildPackages.texlive.withPackages (
              ps: with ps; [
                scheme-basic
                preprint
                marvosym
                titlesec # verbatim
                enumitem
                fancyhdr
              ]
            ))
          ];

          postConfigure = ''
            export TEXMFVAR=$TEMPDIR
          '';
        }
      ) { };
    });
  };
}
