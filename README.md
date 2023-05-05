<h1 align="center">Milo Gertjejansen's dotfiles</h1>

<p align="center">❄️✨🐧🔥 Now with Nix Flake hotness. 🔥🐧✨❄️</p>

---

# Usage

This probably isn't useful to anybody but me, but here you go:

## First run

```bash
HOSTNAME=your_host_name make config
```

## Subsequent runs

After the first run `HOSTNAME` will be set on the system, so you can just run

```bash
make config
```

Make sure to restart your shell or tmux session if you haven't after the first
run. Otherwise the `HOSTNAME` environtment variable will still not be set

## Updating the flake.lock for new versions

```bash
make update
```

# Why Nix?

@rpearce turned me onto this. I used to be an Arch Linux guy, but configuring
it got tiresome since I'd change things and I forgot what I changed but
magically things started working.

Nix solves that for me so if I mess something up I can just roll back to a
previous generation.

Also, all the configuration is stored in a git repo, so if I undo something but
find I actually did want it everything is searchable.

# Features

- Nix - obviously. I can add a program by running `make`.
- [Modules](./modules/README.md) - Modules exist for parts of my system that
  can be broken off and run elsewhere.
  - At the moment I have a single module, Neovim.
- Different machine configurations - I can keep each machine configured
  separately as well as different users.

# Your machines?

| Hostname        | Platform         | Name history |
| ---             | ---              | ---          |
| `theseus`       | NixOS (desktop)  | Formerly `apollo` but I replaced all the guts while the case remained the same. |
| `hog`           | NixOS (headless) | I used to have `pig`, now I have `hog`. |
| `mgert-worktop` | MacOS (M1)       | My work laptop. |
| `coucher`       | MacOS (Intel)    | Formerly `worktop`. I use it on the couch. |


## 🪦 Retired machines

| Hostname  | Platform         | Name history |
| ---       | ---              | ---          |
| `rig`     | NixOS (headless) | Formerly `pig` but now it's remote, so **R**emote P**ig**. |
