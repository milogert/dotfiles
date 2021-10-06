{ pkgs, ... }:

{
  home.packages = with pkgs; [ browserpass ];

  programs.browserpass = {
    enable = true;
  };
}
