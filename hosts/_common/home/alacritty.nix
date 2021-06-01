{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      # Any items in the `env` entry below will be added as
      # environment variables. Some entries may override variables
      # set by alacritty itself.
      env = {
        # TERM variable
        #
        # This value is used to set the `$TERM` environment variable for
        # each instance of Alacritty. If it is not present, alacritty will
        # check the local terminfo database and use `alacritty` if it is
        # available, otherwise `xterm-256color` is used.
        #env.TERM = "xterm-256color";
      };

      font = {
        normal = {
          family = "MesloLGS Nerd Font";
          style = "Regular";
        };
        bold = {
          style = "Bold";
        };
        italic = {
          style = "Italic";
        };
        bold_italic = {
          style = "Bold Italic";
        };
        size = 12.0;
      };

      colors = {
        primary = {
          background = "#1C1B19";
          foreground = "#D0BFA1";

          # Bright and dim foreground colors
          #
          # The dimmed foreground color is calculated automatically if it is not present.
          # If the bright foreground color is not set, or `draw_bold_text_with_bright_colors`
          # is `false`, the normal foreground color will be used.
          #dim_foreground: '#9a9a9a'
          bright_foreground = "#FCE8C3";
        };
        normal = {
          black = "#1C1B19";
          red = "#EF2F27";
          green = "#519F50";
          yellow = "#FBB829";
          blue = "#2C78BF";
          magenta = "#E02C6D";
          cyan = "#0AAEB3";
          white = "#D0BFA1";
          orange = "#D75F00";

        };
        bright = {
          black = "#918175";
          red = "#F75341";
          green = "#98BC37";
          yellow = "#FED06E";
          blue = "#68A8E4";
          magenta = "#FF5C8F";
          cyan = "#53FDE9";
          white = "#FCE8C3";
          orange = "#FF8700";
        };
      };

      shell.program = "/bin/zsh";
      shell.args = [ "--login" ];
    };
  };
}
