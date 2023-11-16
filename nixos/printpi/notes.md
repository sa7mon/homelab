# NixOS RasPi CUPS Server

- Downloaded from https://hydra.nixos.org/build/224303559

- unzstd'd file
- flashed .img with Etcher

- connected peripherals and booted up
- `/etc/nixos` is empty
- `sudo generate-nixos-config`
- configured configuration.nix
	user
	allow port 22
	set hostname
- `sudo nixos-rebuild switch`
	- did it's thing for a while, then at the end I realized I couldn't run `passwd dan` because the `nixos` user no longer exists 
even though my session is still running. Can't do sudo because the system can't determine what user I am
	- can't change user to my newly created one and can't `sudo su -`
	- wasn't sure if there was an easy way out of this, so I just reimaged the SD card
- back in now
- re-generated a config
- curl'd my laptop's public key and only configured openssh and a new user with the `initialPassword` option set 
- after a `nixos-rebuild switch`, `passwd` and set a real password


https://rollo-main.b-cdn.net/driver-dl/beta/rollo-driver-raspberrypi-beta.zip
