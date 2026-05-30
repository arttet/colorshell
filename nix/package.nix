{
  lib,
  pkgs,
  ags,
  system,
}:
let
  agsBin = ags.packages.${system}.ags;
in
pkgs.stdenv.mkDerivation {
  pname = "colorshell";
  version = "0.1.0";
  src = ../.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/colorshell
    cp -r src $out/share/colorshell/

    makeWrapper ${agsBin}/bin/ags $out/bin/colorshell \
      --add-flags "run $out/share/colorshell/src/app/main.ts"

    runHook postInstall
  '';

  meta = {
    description = "AGS desktop shell built with GTK4 and Astal";
    license = lib.licenses.mit;
    mainProgram = "colorshell";
    platforms = [ "x86_64-linux" ];
  };
}
