{
  description = "Nix tool ownership for viasnake dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fzf-fish = {
      url = "github:PatrickF1/fzf.fish";
      flake = false;
    };

    fish-ghq = {
      url = "github:decors/fish-ghq";
      flake = false;
    };

    pure = {
      url = "github:pure-fish/pure";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      fzf-fish,
      fish-ghq,
      pure,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: import nixpkgs { inherit system; };

      toolPackages =
        pkgs: with pkgs; [
          fish
          fzf
          ghq
          gmailctl
          jsonnet
          mise
        ];

      fishPlugins = [
        {
          name = "fzf.fish";
          src = fzf-fish;
        }
        {
          name = "fish-ghq";
          src = fish-ghq;
        }
        {
          name = "pure";
          src = pure;
        }
      ];

      dotfilesToolsModule =
        { pkgs, ... }:
        {
          home.packages = toolPackages pkgs;

          programs.fish = {
            enable = true;
            plugins = fishPlugins;
          };
        };

      validationHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          modules = [
            dotfilesToolsModule
            {
              home.username = "dotfiles";
              home.homeDirectory =
                if nixpkgs.lib.hasSuffix "darwin" system then
                  "/Users/dotfiles"
              else
                "/home/dotfiles";
              home.stateVersion = "25.05";
            }
          ];
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        rec {
          dotfiles-tools = pkgs.buildEnv {
            name = "dotfiles-tools";
            paths = toolPackages pkgs;
          };
          default = dotfiles-tools;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = toolPackages pkgs;
          };
        }
      );

      homeManagerModules.dotfilesTools = dotfilesToolsModule;

      homeConfigurations = builtins.listToAttrs (
        map (system: {
          name = "dotfiles-nix-validation-${system}";
          value = validationHome system;
        }) systems
      );

      checks = forAllSystems (
        system:
        let
          homeName = "dotfiles-nix-validation-${system}";
        in
        {
          dotfiles-tools = self.packages.${system}.dotfiles-tools;
          home-manager-validation = self.homeConfigurations.${homeName}.activationPackage;
        }
      );
    };
}
