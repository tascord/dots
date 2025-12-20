# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnsupportedSystem = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "flora"
  ];
  nixpkgs.config.allowUnfree = true;
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;

    plymouth = {
      enable = true;
      themePackages = [ inputs.plymouth-theme.packages.${pkgs.system}.default ];
    };
  };

  programs.nix-ld.enable = true;
  services.fprintd.enable = true;
  networking.hostName = "floramobile";
  networking.networkmanager.enable = true;
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
      qt6Packages.fcitx5-with-addons
      fcitx5-mozc
    ];
  };

  fonts.packages = with pkgs; [ noto-fonts-cjk-sans ];
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  console = {
    font = "Maple Mono";
    useXkbConfig = true;
  };

  programs.hyprland.enable = true;
  programs.adb.enable = true;
  services.displayManager.gdm.wayland = true;
  services.displayManager.gdm.enable = true;
  services.udisks2.enable = true;

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
    extraGroups = [
      "wheel"
      "adbusers"
      "docker"
      "audio"
      "dialout"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [ tree ];
  };

  virtualisation.docker = {
    enable = true;
    # Optional: Enable experimental features if you need them
    # daemon.settings = {
    #   experimental = true;
    # };
  };

  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Critical for many Wine apps
  };

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.xwayland.enable = true;
  programs.steam.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxussers.members = [ "flora" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;
  security.rtkit.enable = true;
  services.pipewire.jack.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    google-chrome
    vim
    wget
    pkgs.stdenv
    maple-mono.NF
    rustup
    gcc
    plymouth
    dmenu
    devenv
    acpi
    fcitx5-mozc
    fcitx5-gtk
    grimblast
    feh
    light
    overskride
    imagemagick
    unzip
    lsof
    python3
    pavucontrol
    playerctl
    spotifyd
    ranger
    nautilus
    xwayland
    hyprlandPlugins.hyprexpo
    wine-staging
    winetricks
    bottles
  ];

  services.tailscale.enable = true;
  home-manager.backupFileExtension = "backup";
  services.openssh.enable = true;
  networking.firewall.enable = true;
  security.polkit.enable = true;

  security.sudo.extraRules = [
    {
      users = [ "ALL" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/ectool";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "65536";
    }
  ];

  programs.git.enable = true;
  programs.git.config = {
    init = {
      defaultBranch = "main";
    };
  };

  nix.gc.automatic = true;
  nix.gc.dates = "weekly"; # or "daily"
  nix.gc.options = "--delete-older-than 7d";

  system.stateVersion = "25.05"; # Did you read the comment?

}
