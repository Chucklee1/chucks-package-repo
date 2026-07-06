{
  description = "A collection of a few nix packages I maintain myself";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # osu lazer
      };
    in {
      packages = {
        momw-tools-pack = pkgs.callPackage ./momw-tools-pack {};
        openmw = pkgs.callPackage ./openmw {};
        osu = pkgs.callPackage ./osu {};
      };

      overlays = {
        momw-tools-pack = [(final: prev: {momw-tools-pack = self.packages.${system}.momw-tools-pack;})];
        openmw = [(final: prev: {openmw = self.packages.${system}.openmw;})];
        osu = [(final: prev: {osu = self.packages.${system}.osu;})];
      };
    });
}
