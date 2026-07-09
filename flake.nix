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
    # it's just cleaner to put all list up here
    # at least to me it is...
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    pkgList = [
      "mo2-lint"
      "momw-tools-pack"
      "openmw"
      "osu"
    ];
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      inherit systems;
      imports = [flake-parts.flakeModules.easyOverlay];

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
