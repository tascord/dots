{
  config,
  pkgs,
  lib,
  rustPlatform,
  ...
}:
let
  userConfig = builtins.fromJSON (builtins.readFile ../map.json);
  mappedFiles = lib.attrsets.mapAttrsToList (source: output: {
    name = "${lib.strings.removePrefix "~/" output}";
    value = {
      source = "${builtins.toString ../files}/${lib.strings.removePrefix "~" source}";
      recursive = true;
    };
  }) userConfig.files;

  looseFiles = map (file: {
    name = file;
    value = {
      source = "${builtins.toString ../files}/${file}";
      recursive = false;
    };
  }) userConfig.loose_files;
in
{
  home.file = builtins.listToAttrs (mappedFiles ++ looseFiles); 

  home.packages = with pkgs; [
    hyprpanel
    rofi
    pywal
    neovim
    vscode
    hyprpaper
    hyfetch
    spotify
    discord
    godot
    musescore
    terminaltexteffects
    asciinema
    cura-appimage
    darktable
    vscode-extensions.rust-lang.rust-analyzer
    ghostty
    gh
    eza
  ];

  programs.direnv.enable = true;
  programs.fish.enable = true;
  services.picom.enable = true;

  programs.nh.enable = true;

  programs.starship = {
    enable = true;
  };

  programs.fish.interactiveShellInit = "set QT_IM_MODULE fcitx; set XMODIFIERS @im=fcitx; eval (ssh-agent -c) > /dev/null; ssh-add ~/.ssh/* &> /dev/null";
  home.stateVersion = "25.05";

}
