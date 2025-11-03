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
    eww
    modrinth-app
    kdePackages.ghostwriter
    sptlrx
    hyprlock
    cava
    matugen
    swww
    waybar
    waybar-mpris
    waybar-lyric
    wl-clip-persist
    whitesur-cursors
    nixfmt
    wired
    # new
  ];

  programs.direnv.enable = true;
  services.picom.enable = true;
  programs.nh.enable = true;

  programs.fish.interactiveShellInit = "set QT_IM_MODULE fcitx; set XMODIFIERS @im=fcitx; eval (ssh-agent -c) > /dev/null; ssh-add ~/.ssh/* &> /dev/null";
  home.stateVersion = "25.05";

  programs.fish.shellAliases = {
    ls = "eza --icons=always --git-ignore --hyperlink --git --git-repos-no-status --time-style relative --no-permissions";
  };
  
  programs.fish = {
    enable = true;
    functions = {
      fish_prompt = {
        body = ''
          # Get current working directory
          set -l pwd (string replace $HOME '~' (pwd))
          
          # Get git status if in a git repository
          set -l git_branch ""
          set -l git_status ""
          if git rev-parse --git-dir >/dev/null 2>&1
            set git_branch (git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
            if test -n "$git_branch"
              set git_status (git status --porcelain 2>/dev/null)
              if test -n "$git_status"
                set git_branch "$git_branch !"
              end
            end
          end
          
          # Build prompt
          set_color cyan
          echo -n (whoami)
          set_color normal
          echo -n "@"
          set_color green
          echo -n (hostname)
          set_color normal
          echo -n " in "
          set_color yellow
          echo -n $pwd
          
          # Add git branch if available
          if test -n "$git_branch"
            set_color normal
            echo -n " on "
            set_color purple
            echo -n " $git_branch"
          end
          
          # Add nix shell indicator if in nix shell
          if test -n "$IN_NIX_SHELL"
            set_color normal
            echo -n "via "
            set_color blue
            echo -n " λ"
          end
          
          set_color normal
          echo ""
          echo -n "╰› "
        '';
      };

      fish_right_prompt = {
        body = ''
          set_color brblack
          echo -n (date '+%I:%M:%S %p')
          set_color normal
        '';
      };
    };
  };


  services.udiskie.enable = true;
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
}

