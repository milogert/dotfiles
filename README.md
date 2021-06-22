# Milo Gertjejansen's dotfiles

Now with Nix Flake hotness.

## Usage

This probably isn't useful to anybody but me, but here you go:

### First run

```bash
HOSTNAME=your_host make config
```

### Subsequent runs

After the first run `HOSTNAME` will be set on the system, so you can just run

```bash
make config
```

### Updating the flake.lock for new versions

```bash
make update
```

### Just install the requirements (mostly for `nix-darwin`)

```bash
make install_requirements
```

## Why Nix?

@rpearce turned me onto this. I used to be an Arch Linux guy, but configuring it got tiresome since I'd change things and I forgot what I changed but magically things started working.

Nix solves that for me so if I mess something up I can just roll back to a previous generation.

## Your computer names?

- `theseus` - this computer was `apollo`, but I replaced all the guts while the case remained the same.
- `rig` - formerly `pig` but now it's remote, so **R**emote P**ig**.
- `worktop` - my work laptop. It's a Mac, so it uses `nix-darwin`.

## ⚠️ Troubleshooting

### Error when building relating to `~/.config/coc` not being present

I don't know how to solve this one yet. So far my solution is to just manually create the directory and copy `Coc.nvim` stuff over.
