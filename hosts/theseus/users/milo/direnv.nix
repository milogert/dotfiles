{ config, ... }:

let
  home_dir = "${config.home.homeDirectory}";
in rec {
  enable = true;

  enableZshIntegration = true;

  nix-direnv.enable = true;
  nix-direnv.enableFlakes = true;

  config = {
    whitelist = {
      prefix = [ "${home_dir}/git" ];
    };
  };
}
