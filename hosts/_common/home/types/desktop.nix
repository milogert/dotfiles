{ pkgs, ... }:

{
  imports = [
    ../browserpass.nix
    ../kitty.nix
    ../ranger.nix
  ];

  home.packages = with pkgs; [
    /* notion-app-enhanced */
    /* beekeeper-studio */
  ];
}
