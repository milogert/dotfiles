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

## TypeScript and JavaScript development

```bash
nix develop
npm run test:pr-watch
npm run typecheck
npm run check
```

The shell provides Node 24, TypeScript, and Biome from the existing flake lock.
It does not install or link npm dependencies. `package.json`, `tsconfig.json`, and
`biome.json` provide project roots and editor configuration. Launch Neovim from
the shell, or run `direnv allow` once to use the included `.envrc`.

Typechecking needs project dependencies such as the Pi SDK and Node types, and
can report existing/in-progress issues including `gate-check.ts`. JavaScript is
included for editor support but is not typechecked. The current Neovim Biome
command uses `node_modules/.bin/biome`; use `biome lsp-proxy` instead to run the
shell's binary. Use `biome check <paths>` for focused checks; it only writes files
with `--write`. Packaged-extension tests requiring built sources still use their
documented commands.

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
| `minotaur` | MacOS (M1)       | Formerly `mgert-worktop`. This is the moving laptop. |


## 🪦 Retired machines

| Hostname  | Platform         | Name history |
| ---       | ---              | ---          |
| `rig`     | NixOS (headless) | Formerly `pig` but now it's remote, so **R**emote P**ig**. |
