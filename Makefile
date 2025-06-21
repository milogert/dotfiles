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
	@echo -e "\033[0;33m-- Building ----------------------------\033[0m"
	nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" --impure

_nixos-switch:
	@echo -e "\033[0;33m-- Switching ---------------------------\033[0m"
	# Old command: sudo nixos-rebuild switch --flake ".#${HOST}"
	# See https://github.com/NixOS/nixpkgs/issues/169193
	nixos-rebuild --use-remote-sudo switch --flake ".#${HOST}" --impure

# nix-darwin commands.
_nix-darwin-build:
	@echo -e "\033[0;33m-- Building ----------------------------\033[0m"
	nix build ".#darwinConfigurations.${HOST}.system" --extra-experimental-features 'nix-command flakes'

_nix-darwin-switch:
	@echo -e "\033[0;33m-- Switching ---------------------------\033[0m"
	sudo ./result/sw/bin/darwin-rebuild switch --flake ".#${HOST}"

_install_requirements:
	@echo -e "\033[0;33m-- Installing required programs --------\033[0m"
	./installers/homebrew
	./installers/nix

update: update-neovim
	@echo -e "\033[0;33m-- Updating ----------------------------\033[0m"
	nix flake update --extra-experimental-features 'nix-command flakes'

update-neovim:
	@echo -e "\033[0;33m-- Updating (neovim) -------------------\033[0m"
	nix flake update --flake ./modules/neovim --extra-experimental-features 'nix-command flakes'

add-user:
	./scripts/add_user.sh

# Machines
hog: _nixos-build _nixos-switch
remote-hog: _nixos-build _nixos-switch
theseus: _nixos-build _nixos-switch
nutop: _install_requirements _nix-darwin-build _nix-darwin-switch
minotaur: _install_requirements _nix-darwin-build _nix-darwin-switch
