{
  description = "NixOS configuration with Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    llm-agents.url = "github:numtide/llm-agents.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      spicetify-nix,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      toktrack = pkgs.stdenv.mkDerivation rec {
        pname = "toktrack";
        version = "2.18.0";

        src = pkgs.fetchurl {
          url = "https://github.com/mag123c/toktrack/releases/download/v${version}/toktrack-linux-musl-x64";
          hash = "sha256-WM4t+E8HUtR51brHTTnYpIe+fMtWSfjaOCxTyCc8CP8=";
        };

        dontUnpack = true;

        installPhase = ''
          runHook preInstall
          install -Dm755 $src $out/bin/toktrack
          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "Ultra-fast token and cost tracker for LLM CLI usage";
          homepage = "https://github.com/mag123c/toktrack";
          license = licenses.mit;
          mainProgram = "toktrack";
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      packages.${system}.toktrack = toktrack;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          stylix.nixosModules.stylix
          spicetify-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./configuration.nix
        ];
      };
    };
}
