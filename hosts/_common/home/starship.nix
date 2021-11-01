{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [starship];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$kubernetes"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$golang"
        "$java"
        "$julia"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$php"
        "$purescript"
        "$python"
        "$ruby"
        "$rust"
        "$terraform"
        "$zig"
        "$nix_shell"
        "$conda"
        "$memory_usage"
        "$aws"
        "$env_var"
        "$crystal"
        "$cmd_duration"
        "$custom"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$character"
      ];
      aws = {
        disabled = true;
      };
      character = {
        error_symbol = "[✖](bold red)";
      };
      time = {
        disabled = false;
      };
      command_timeout = 1000;
    };
  };
}
