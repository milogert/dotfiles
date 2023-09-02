# Modules

This directory contains modules of my system that can be broken out and run
elsewhere. The goal of each module is to have two commands for accessing it:

- `run-[module]`
  - Builds and runs the module from it's respective directory.
  - This allows for fast iteration when I'm making changes.
- `github-[module]`
  - Ultimately this is an alias for `nix run --no-write-lock-file "github:milogert/dotfiles#[module]"`.
  - Does similar thing as above but runs the latest from GitHub.
  - Lets other people test out the module locally without installing anything.

Finally once you have run the module from _somewhere_ it should start with the
proper configuration.

# Requirements

To run each module individually you just need `nix` installed.

# Module List

| Module   | README                       | What is it? |
| ---      | ---                          | ---         |
| `neovim` | [(link)](./neovim/README.md) | Neovim configuration. |
