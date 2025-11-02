{
  description = "Minimal flake to build and run a C# (.NET) program";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      packages = forEachSystem (
        { pkgs }:
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "dotnet-app";
            version = "1.0";

            src = ./.;

            buildInputs = [ pkgs.dotnet-sdk ];

            buildPhase = ''
              dotnet publish -c Release -o publish
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp -r publish/* $out/bin/
            '';
          };
        }
      );

      apps = forEachSystem (
        { pkgs }:
        {
          default = {
            type = "app";
            program = "${pkgs.writeShellScriptBin "run-dotnet-app" ''
              set -e
              appDir="${self.packages.${pkgs.system}.default}/bin"
              dllFile=$(find "$appDir" -maxdepth 1 -name '*.dll' | head -n 1)
              exec ${pkgs.dotnet-sdk}/bin/dotnet "$dllFile" "$@"
            ''}/bin/run-dotnet-app";
          };
        }
      );

      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.dotnet-sdk
              pkgs.omnisharp-roslyn
            ];
          };
        }
      );
    };
}
