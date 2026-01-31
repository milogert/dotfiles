{ lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$kubernetes"
        "$directory"
        "$vcsh"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$buf"
        "$c"
        "$cmake"
        "$cobol"
        "$container"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$golang"
        "$haskell"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$nix_shell"
        "$conda"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
        "$sudo"
        "$cmd_duration"
        "$custom"
        "$line_break"

        # New line here
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$shell"
        "$character"
      ];

      aws = {
        disabled = true;
      };

      cmd_duration = {
        min_time = 500;
        format = "[$duration]($style) ";
      };

      character = {
        error_symbol = "[✖](bold red)";
        success_symbol = "[❯](bold green)";
      };

      git_commit = {
        only_detached = false;
        commit_hash_length = 7;
      };

      # This is default disabled.
      git_metrics = {
        disabled = true;
      };

      git_status = {
        disabled = false;
        # format = "([\[$all_status$ahead_behind\]]($style) )";
        conflicted = "";
        ahead = "";
        behind = "";
        diverged = "";
        untracked = "";
        stashed = "";
        modified = "[*](yellow)";
        staged = "";
        renamed = "";
        deleted = "";
        ignore_submodules = true;
      };

      nix_shell = {
        format = "via [$symbol$state( \($name\))]($style) ";
        impure_msg = "impure";
        pure_msg = "PURE";
      };

      time = {
        disabled = true;
      };

      command_timeout = 1000;
    };
  };
}
