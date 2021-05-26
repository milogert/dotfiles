{ pkgs, ... }:

{
  programs.zsh = {
    autocd = true;
    localVariables = {
      PASSWORD_STORE_GENERATED_LENGTH = 32;
      PASSWORD_STORE_ENABLE_EXTENSIONS = true;
    };
    prezto = {
      enable = true;
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "wakeonlan"
        "utility"
        "completion"
        "prompt"
        "pacman"
        "tmux"
        "docker"
        "git"
      ];
      #prompt = {
      #  showReturnVal = true;
      #};
      color = true;
    };
  };
}
