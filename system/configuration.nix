# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.fprintd.enable = true;
  networking.hostName = "floramobile";
  networking.networkmanager.enable = true;
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.inputMethod.ibus = { engines = with pkgs.ibus-engines; [ mozc ]; };
  fonts.packages = with pkgs; [ noto-fonts-cjk-sans ];
  environment.variables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };

  console = {
    font = "Maple Mono";
    useXkbConfig = true;
  };

  programs.hyprland.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "eurosign:e,caps:escape";
    desktopManager = { xterm.enable = false; };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
    };
  };

  services.displayManager.gdm.wayland = true;
  services.displayManager.gdm.enable = true;

  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  users.users.flora = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [ tree ];
  };
  programs.fish.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    google-chrome
    vim
    wget
    git
    devenv
    stdenv
    maple-mono.NF
    ibus-engines.mozc
  ];

  services.openssh.enable = true;
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #   system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
