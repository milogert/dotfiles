{ pkgs, ... }:

rec {
  imports = [
    ../_common/default.nix
    ./darwin/homebrew.nix
    ./darwin/nix-apps.nix
    ./networking.nix
  ];

  environment.systemPackages = with pkgs; [
    #awscli
  ];
}
