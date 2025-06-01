{ config, pkgs, lib, ... }:
let config = builtins.fromJSON (builtins.readFile ../map.json);
in {
  home.file = builtins.listToAttrs (lib.attrsets.mapAttrsToList
    (source: output: {
      name = "${lib.strings.removePrefix "~/" output}";
      value = {
        source = "${builtins.toString ../files}/${
            lib.strings.removePrefix "~" source
          }";
        recursive = true;
      };
    }) config.files);

  home.packages = with pkgs; [
    stdenv
    devenv
    acpi
    kitty
    dunst
    rofi
    discord
    pywal
    neovim
    vscode
    hyprpaper
    fcitx5-mozc
    fcitx5-gtk
    hyfetch
    pavucontrol
    nixfmt-rfc-style
    pkgs.hyprpanel
  ];

  programs.command-not-found.enable = true;
  programs.fish.enable = true;
  services.picom.enable = true;

  programs.fish.interactiveShellInit =
    "set QT_IM_MODULE fcitx; set XMODIFIERS @im=fcitx";
  home.stateVersion = "25.05";

}
