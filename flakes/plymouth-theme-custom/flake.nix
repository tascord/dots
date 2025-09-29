{
  description = "Custom Plymouth boot theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "plymouth-theme-custom";
            version = "1.0.0";

            src = ./.;

            dontBuild = true;

            installPhase = ''
              runHook preInstall

              # Create theme directory
              mkdir -p $out/share/plymouth/themes/custom

              # Copy all frame images from frames subdirectory
              cp -r frames/frame*.png $out/share/plymouth/themes/custom/

              # Create the plymouth theme configuration
              cat > $out/share/plymouth/themes/custom/custom.plymouth << EOF
              [Plymouth Theme]
              Name=Custom
              Description=Custom animated boot theme
              ModuleName=script

              [script]
              ImageDir=/share/plymouth/themes/custom
              ScriptFile=/share/plymouth/themes/custom/custom.script
              EOF

              # Create the animation script
              cat > $out/share/plymouth/themes/custom/custom.script << 'EOF'
              # Screen and window setup
              screen_width = Window.GetWidth();
              screen_height = Window.GetHeight();

              # Load all frames
              for (i = 1; i <= 266; i++) {
                frame_name = "frame" + String(i).PadWith("0", 4) + ".png";
                frames[i-1] = Image(frame_name);
              }

              # Calculate position to center the animation
              frame_width = frames[0].GetWidth();
              frame_height = frames[0].GetHeight();
              x = (screen_width - frame_width) / 2;
              y = (screen_height - frame_height) / 2;

              # Create sprite
              sprite = Sprite();
              sprite.SetPosition(x, y, 0);

              # Animation variables
              current_frame = 0;
              frame_count = 266;
              fps = 30;
              frame_delay = 1.0 / fps;
              time_since_last_frame = 0;

              # Update function
              fun refresh_callback() {
                time_since_last_frame += 1.0 / 50.0;  # Plymouth calls at ~50Hz
                
                if (time_since_last_frame >= frame_delay) {
                  time_since_last_frame = 0;
                  sprite.SetImage(frames[current_frame]);
                  current_frame = (current_frame + 1) % frame_count;
                }
              }

              Plymouth.SetRefreshFunction(refresh_callback);

              # Message display (optional)
              message_sprite = Sprite();
              message_sprite.SetPosition(screen_width / 2 - 100, screen_height - 50, 1);

              fun message_callback(text) {
                if (text != "") {
                  image = Image.Text(text, 1, 1, 1);
                  message_sprite.SetImage(image);
                }
              }

              Plymouth.SetMessageFunction(message_callback);
              EOF

              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Custom animated Plymouth theme";
              license = licenses.mit;
              platforms = platforms.linux;
            };
          };
        });

      # NixOS module for easy configuration
      nixosModules.default = { config, lib, pkgs, ... }: {
        config = lib.mkIf (config.boot.plymouth.enable && config.boot.plymouth.theme == "custom") {
          boot.plymouth.themePackages = [ self.packages.${pkgs.system}.default ];
        };
      };
    };
}