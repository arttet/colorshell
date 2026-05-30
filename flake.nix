{
  description = "colorshell — AGS desktop shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      astal,
      ags,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.callPackage ./nix/package.nix { inherit ags system; };

      homeManagerModules.default = import ./nix/hm-module.nix;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          bun
          dprint
          ags.packages.${system}.ags
        ];
      };
    };
}
