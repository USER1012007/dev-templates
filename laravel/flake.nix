{
  description = "Laravel backend with PHP 8.4";
  
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  
  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system:
        f {
          pkgs = import nixpkgs { inherit system; };
        }
      );
    in
    {
      devShells = forEachSystem ({ pkgs }:
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              php84
              php84Packages.composer
              
              php84Extensions.mbstring
              php84Extensions.xml
              php84Extensions.curl
              php84Extensions.zip
              php84Extensions.intl
              php84Extensions.bcmath
              php84Extensions.pdo
              php84Extensions.pdo_sqlite
              php84Extensions.sqlite3
              php84Extensions.tokenizer
              php84Extensions.fileinfo
              php84Extensions.dom
              
              sqlite
              nodejs
            ];
            
            shellHook = ''
              echo "Laravel development environment"
              echo "PHP version: $(php --version | head -n 1)"
              echo "Composer version: $(composer --version)"
              echo ""
              echo "Comandos útiles:"
              echo "  php artisan serve    - Iniciar servidor Laravel"
              echo "  php artisan migrate  - Ejecutar migraciones"
              echo "  composer install     - Instalar dependencias"
            '';
          };
        }
      );
      
      packages = forEachSystem ({ pkgs }:
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "laravel-backend";
            version = "1.0";
            src = ./.;
            
            buildInputs = with pkgs; [
              php84
              php84Packages.composer
            ];
            
            buildPhase = ''
              export HOME=$TMPDIR
              composer install --no-dev --optimize-autoloader
            '';
            
            installPhase = ''
              mkdir -p $out
              cp -r . $out/
              
              mkdir -p $out/bin
              cat > $out/bin/start-server << 'EOF'
              #!/bin/sh
              cd $out
              ${pkgs.php84}/bin/php artisan serve --host=0.0.0.0 --port=8000
              EOF
              chmod +x $out/bin/start-server
            '';
          };
        }
      );
      
      apps = forEachSystem ({ pkgs }:
        {
          default = {
            type = "app";
            program = "${self.packages.${pkgs.system}.default}/bin/start-server";
          };
        }
      );
    };
}
