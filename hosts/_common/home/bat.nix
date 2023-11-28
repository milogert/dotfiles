{ config, pkgs, ... }: 

{
  programs.bat = {
    enable = true;
    config = {
      theme = "srcery";
      style = "full,changes";
    };
    themes = {
      srcery = {
        src = pkgs.fetchFromGitHub {
          owner = "srcery-colors";
          repo = "srcery-textmate"; # Bat uses sublime syntax for its themes
          rev = "fd1992b0ac576ffee0ba9ddbc0b02b92c69ce8b2";
          sha256 = "0pjkmsg953f5dhp2xcyqxflpn2c85dipn9qrb2iqkgnzjgj8djyr";
        };
        file = "srcery.tmTheme";
      };
    };
  };

  home.activation.rebuildBatCache =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD bat cache --build
  '';

}
