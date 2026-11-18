{ pkgs, ... }:

{
  programs.mcp = {
    enable = true;

    servers = {
      nixos = {
        enabled = true;
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      };
    };
  };
}
