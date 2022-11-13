{ pkgs, ... }:

{
  programs.password-store = {
    enable = false;

    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
      PASSWORD_STORE_GENERATED_LENGTH = "32";
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
  };
}
