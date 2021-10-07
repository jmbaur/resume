{ pkgs ? import <nixpkgs> { } }:
let
  run = pkgs.writeShellScriptBin "run" ''
    ${pkgs.fd}/bin/fd -e tex | ${pkgs.entr}/bin/entr -c \
      ${pkgs.texlive.combined.scheme-medium}/bin/latexmk -pdf resume.tex
  '';
in
pkgs.mkShell
{
  nativeBuildInputs = with pkgs; [
    entr
    fd
    texlive.combined.scheme-medium
  ] ++ [ run ];
}
