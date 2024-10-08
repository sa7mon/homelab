# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "printpi";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    listenAddresses = [
      "0.0.0.0:631"
    ];
    logLevel = "debug";
    browsing = true;
    allowFrom = [
      "10.10.1.0/24"
    ];
    drivers = [
      (pkgs.callPackage ./rollo-driver.nix {})
    ];
    defaultShared = true;
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish.enable = true;
    publish.userServices = true;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_Laserjet_4200";
        location = "Basement";
        deviceUri = "socket://10.10.1.130";
        model = "drv:///sample.drv/laserjet.ppd";
        ppdOptions = {
          PageSize = "Letter";
          Resolution = "600dpi";
          InputSlot = "Default";
          Duplex = "DuplexNoTumble";
          Duplexer = "True";
        };
      }
      {
        name = "Rollo_LabelPrinter";
        location = "Office";
        deviceUri = "usb://Printer/ThermalPrinter?serial=588U2824739";
        model = "rollo/rollo-thermal.ppd";
        ppdOptions = {
          printer-is-shared = "true";
          PageSize = "w288h432";
        };
      }
    ];
    ensureDefaultPrinter = "HP_Laserjet_4200";
  };

  users.defaultUserShell = pkgs.zsh;

  users.users.dan = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tmux
      htop
    ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXDB8uAU+GsbJu2ym8syi0MBsvIf53B4jJHWmU7pynu dan@salmon.cat" ];
  };

  environment.systemPackages = with pkgs; [
    tmux
    htop
    binutils
    zsh
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.zsh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 631 ];
  networking.firewall.allowedUDPPorts = [ 631 5353 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
