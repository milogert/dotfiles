theseus:
	nix build ".#nixosConfigurations.theseus.config.system.build.toplevel"
	sudo nixos-rebuild switch --flake ".#theseus"

worktop:
	./installers/homebrew
	./installers/nix
	nix build ".#darwinConfiguration.worktop.system"
	./result/sw/bin/darwin-rebuild switch --flake ".#worktop"
