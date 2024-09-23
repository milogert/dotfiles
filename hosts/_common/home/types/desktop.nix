{ pkgs, ... }:

{
  imports = [
    ../browserpass.nix
    ../ranger.nix
  ];

  home.packages = with pkgs; [
    /* notion-app-enhanced */
    /* beekeeper-studio */
  ];
}
