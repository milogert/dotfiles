.PHONY: check help usage all update update-neovim
.DEFAULT: all

HOST=${HOSTNAME}

define usage
@echo "Usage:"
@echo "  <default>"
@echo "  config"
@echo "    Requires that HOSTNAME be set. Configures that machine."
@echo "  update"
@echo "    Updates the flake.lock file so new versions can be installed. This includes modules."
@echo "  update-neovim"
@echo "    Updates the neovim module."
@echo
@echo "Anything prefixed with '_' is internal, but can be run separately if you need granular output."
endef

all: config

usage: help
help:
	$(usage)

check:
ifeq (${HOST},)
	@echo -e "\033[0;31mCall make with \033[1;34mHOSTNAME=your_host make config\033[0;31m instead.\033[0m"
	exit 1
else
	@echo -e "\033[0;32mChecks passed for ${HOST}, proceeding with build and switch\033[0m"
endif

config: check ${HOST}
	@echo -e "\033[0;32mDone configuring ${HOST}\033[0m"
	@echo -e "\033[0;32m  Run \033[1;34mmake update && make\033[0;32m if your programs are out of date\033[0m"

# NixOS commands.
_nixos-build:
	nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" --experimental-features "nix-command flakes"

_nixos-switch:
	# Old command: sudo nixos-rebuild switch --flake ".#${HOST}"
	# See https://github.com/NixOS/nixpkgs/issues/169193
	nixos-rebuild --use-remote-sudo switch --flake ".#${HOST}"

# nix-darwin commands.
_nix-darwin-build:
	# Remove the flags here eventually. This is to bootstrap flakes on your
	# system. After these same flags should be inside the configuration files.
	nix build ".#darwinConfigurations.${HOST}.system" --experimental-features "nix-command flakes"

_nix-darwin-switch:
	./result/sw/bin/darwin-rebuild switch --flake ".#${HOST}"

_install_requirements:
	@echo -e "\033[0;32mInstalling required programs\033[0m"
	./installers/homebrew
	./installers/nix

update: update-neovim
	nix flake update

update-neovim:
	nix flake update ./modules/neovim

add-user:
	./scripts/add_user.sh

# Machines
coucher: _install_requirements _nix-darwin-build _nix-darwin-switch
hog: _nixos-build _nixos-switch
theseus: _nixos-build _nixos-switch
mgert-worktop: _install_requirements _nix-darwin-build _nix-darwin-switch
