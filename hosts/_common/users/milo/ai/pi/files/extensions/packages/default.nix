{ pkgs, ... }:

[
  (import ./pi-ask-user.nix { inherit pkgs; })
  # Automode is way too restrictive.
  # (import ./pi-automode.nix { inherit pkgs; })
  (import ./pi-hooks.nix { inherit pkgs; })
  (import ./pi-peon-ping.nix { inherit pkgs; })
  (import ./pi-ponytail.nix { inherit pkgs; })
  (import ./pi-powerline-footer.nix { inherit pkgs; })
]
