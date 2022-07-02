{ config, ... }:

let
  home_dir = "${config.home.homeDirectory}";
in {
  enable = true;

  enableZshIntegration = true;

  nix-direnv.enable = true;

  config = {
    whitelist = {
      prefix = [ "${home_dir}/git" ];
    };
  };
}
