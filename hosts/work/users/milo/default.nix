{ pkgs
, config
, ...
}:

{
  imports = [
    ./hammerspoon
    ./plist-settings.nix
  ];

  home = {
    stateVersion = "21.05";

    packages = with pkgs; [
      docker
      git-lfs
      mas
      yarn
    ];

    file = {
      ".local/bin/restore-monitor" = {
        source = ./restore-monitor.swift;
        executable = true;
      };
      ".cargo/config.toml" = {
        recursive = true;
        text = ''
        [target.x86_64-apple-darwin]
        rustflags = [
            "-C", "link-arg=-undefined",
            "-C", "link-arg=dynamic_lookup",
        ]

        [target.aarch64-apple-darwin]
        rustflags = [
            "-C", "link-arg=-undefined",
            "-C", "link-arg=dynamic_lookup",
        ]
        '';
      };
    };
  };
}
