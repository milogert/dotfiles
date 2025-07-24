{ pkgs, ... }:

{
  environment.shellAliases = {
    cat = "${pkgs.bat}/bin/bat";
    catt = "${pkgs.bat}/bin/bat --style=plain --pager=never";
    gpgkill = "${pkgs.gnupg}/bin/gpgconf --kill gpg-agent";
    ll = "${pkgs.eza}/bin/eza -l -g --git --color always --icons -a -s type";
    ls = "${pkgs.eza}/bin/eza --color auto --icons -a -s type";
    reset-yubikey = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";

    # Nix stuff.
    ns = "${pkgs.nix}/bin/nix-shell";
    nsp = "${pkgs.nix}/bin/nix-shell -p";

    nq = "${pkgs.nix}/bin/nix search";
    nqn = "${pkgs.nix}/bin/nix search nixpkgs";

    nm = "man 5 configuration.nix";
    nmh = "man 5 home-configuration.nix";

    ngit = "f() { nix-prefetch-git --quiet $1 | jq -r 'with_entries(select([.key] | inside([\"rev\", \"sha256\"])))'; }; f ";
  };
}
