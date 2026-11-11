{ pkgs, ... }:

{
  programs.mcp = {
    enable = true;

    servers = {
      nixos = {
        enabled = true;
        command = "${pkgs.nix}/bin/nix";
        args = ["run" "github:utensils/mcp-nixos" "--"];
      };
    };
  };
}
