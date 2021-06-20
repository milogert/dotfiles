all:

install_requirements:
	./installers/homebrew
	./installers/nix

theseus-build:
	nix build ".#nixosConfigurations.theseus.config.system.build.toplevel"

theseus-switch:
	sudo nixos-rebuild switch --flake ".#theseus"

theseus: theseus-build theseus-switch

worktop-build:
	nix build ".#darwinConfigurations.worktop.system" --experimental-features "nix-command flakes"

worktop-switch:
	./result/sw/bin/darwin-rebuild switch --flake ".#worktop"

worktop: install_requirements worktop-build worktop-switch
