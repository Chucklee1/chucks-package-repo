{
  description = "A collection of a few nix packages I maintain myself";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs: let
    pkgList = [
      "momw-tools-pack"
      "openmw"
      "osu"
    ];
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [flake-parts.flakeModules.easyOverlay];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        lib,
        config,
        pkgs,
        system,
        ...
      }: {
        # import all pkgs as easy, overlays...
        # woohoo for flake parts!
        overlayAttrs = config.packages;
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        packages = lib.genAttrs pkgList (
          pname: pkgs.callPackage ./${pname} {}
        );
      };
    };
}
