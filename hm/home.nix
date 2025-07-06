{
  config,
  pkgs,
  lib,
  rustPlatform,
  ...
}:
let
  config = builtins.fromJSON (builtins.readFile ../map.json);
in
{

  home.file = builtins.listToAttrs (
    lib.attrsets.mapAttrsToList (source: output: {
      name = "${lib.strings.removePrefix "~/" output}";
      value = {
        source = "${builtins.toString ../files}/${lib.strings.removePrefix "~" source}";
        recursive = true;
      };
    }) config.files
  );

  home.packages = with pkgs; [
    stdenv
    devenv
    acpi
    kitty
    dunst
    rofi
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
    spotify
    nodejs
    haskellPackages.misfortune
    playerctl
    spotifyd
    discord
    pkgs.nodePackages.typescript
    pkgs.nodePackages.nodemon
    grimblast
    ffmpeg
    python3Full
  ];

  programs.direnv.enable = true;
  programs.command-not-found.enable = true;
  programs.fish.enable = true;
  services.picom.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      palette = "doggo";

      palettes = {
        doggo = {
          foreground = "#ebdbb2";
          background = "#282828";
          black = "#282828";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          purple = "#b16286";
          aqua = "#689d6a";
          gray = "#a89984";
          orange = "#fe8019";
        };
      };

      format = ''
        $username$hostname$directory$git_branch$git_status$character
      '';

      # Doggo for the prompt character 🐕
      character = {
        success_symbol = "[🐾](bold green)";
        error_symbol = "[🦴](bold red)";
        vimcmd_symbol = "[🐶](bold green)";
      };

      # User and Host
      username = {
        style_user = "yellow bold";
        style_root = "red bold";
        show_always = true;
        format = "[$user]($style)@";
      };
      hostname = {
        style = "blue bold";
        ssh_only = false;
        format = "[$hostname]($style) in ";
        disabled = false;
      };

      # Directory with a home icon 🏠
      directory = {
        style = "bold aqua";
        read_only = " 🔒";
        home_symbol = " ~🏠";
        use_logical_path = true;
        truncation_length = 3;
        truncate_to_repo = true;
        fish_style_pwd_dir_length = 1;
        format = "[$path]($style)[$read_only]($style) ";
      };

      # Git information with a bone icon 🦴
      git_branch = {
        symbol = "🦴 ";
        style = "bold purple";
        format = "on [$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold red";
        stashed = "📦";
        ahead = "💨";
        behind = "⏳";
        diverged = "🔱";
        untracked = "🐾";
        staged = "✨";
        modified = "✏️";
        renamed = "🔄";
        deleted = "🗑️";
        format = "[$all_status$ahead_behind]($style)";
      };

      # A happy dog for when commands take a while 🐕‍🦺
      cmd_duration = {
        min_time = 500;
        style = "bold yellow";
        format = "took [$duration]($style) 🐕‍🦺";
      };

      # A friendly greeting 👋
      custom.hello = {
        command = "echo 'Woof! Welcome back!'";
        when = "true";
        style = "bold green";
        format = "[$output]($style)";
      };
    };
  };

  programs.fish.interactiveShellInit = "set QT_IM_MODULE fcitx; set XMODIFIERS @im=fcitx;";
  home.stateVersion = "25.05";

}
