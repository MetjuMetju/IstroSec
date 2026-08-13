{
  description = "Development environment for Docker CI assignment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python312
          uv
          docker
          docker-compose
          git
          openssl
          direnv
        ];
        shellHook = ''
          echo "Docker CI development environment"
          echo "Python: $(python --version)"
          echo "Docker: $(docker --version)"
        '';
      };
    };
}
