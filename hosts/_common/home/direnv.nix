{ config, ... }:

let
  home_dir = "${config.home.homeDirectory}";
in {
  programs.direnv = {
    enable = true;

    enableZshIntegration = true;

    nix-direnv.enable = true;

    config = {
      whitelist = {
        prefix = [
          "${home_dir}/git"
          "${home_dir}/projects"
        ];
      };
    };
  };
}
