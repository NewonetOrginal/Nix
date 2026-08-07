{ config, pkgs, ... }:

let
  # Stylix color helpers
  c = config.lib.stylix.colors.withHashtag;
  raw = config.lib.stylix.colors;
in
{
  home.username = "nixbtw";
  home.homeDirectory = "/home/nixbtw";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "desktop";
        profile.outputs = [
          {
            criteria = "DP-1";
            mode = "2560x1440@200Hz";
            position = "0,0";
          }
          {
            criteria = "DP-2";
            mode = "2560x1440@200Hz";
            position = "2560,0";
          }
        ];
      }
    ];
  };

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;
        modules-left = [
          "custom/nixicon"
          "river/tags"
          "mpris"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "network"
          "pulseaudio"
          "cpu"
          "temperature"
          "custom/gpu"
          "memory"
          "tray"
        ];

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 Muted";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
        };
        "cpu" = {
          interval = "2";
          format = "{icon} {usage}% ";
          states = {
            warning = 70;
            critical = 90;
          };
        };
        "temperature" = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}C";
          format-icons = [
            ""
            ""
            ""
            ""
          ];
        };
        "memory" = {
          format = " {percentage}%";
          states = {
            warning = 70;
            critical = 90;
          };
        };
        "custom/gpu" = {
          # Dynamic status script using Stylix colors: base0E (purple), base0B (green), base0A (yellow), base08 (red)
          exec = ''nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | awk -F', ' '{u=$1; t=$2; u_col=(u>85?"${c.base08}":(u>60?"${c.base0A}":"${c.base0B}")); t_col=(t>80?"${c.base08}":(t>65?"${c.base0A}":"${c.base0C}")); printf "<span foreground=\"${c.base0E}\">󰢮</span> <span foreground=\"%s\">%d%%</span> <span foreground=\"%s\">%d°C</span>\n", u_col, u, t_col, t}' '';
          interval = 2;
          format = "{}";
        };
        "mpris" = {
          player = "playerctld";
          ignored-players = [
            "firefox"
            "discord"
            "chromium"
            "chrome"
          ];
          format = "{player_icon} <i>{artist} - {title}</i>";
          format-paused = "{status_icon} <i>{artist} - {title}</i>";
          player-icons = {
            default = "";
            spotify = " ";
          };
          status-icons = {
            paused = "";
          };
          max-length = 50;
        };
        "network" = {
          format-wifi = " {bandwidthDownBits}";
          format-ethernet = " {bandwidthDownBits}";
          format-disconnected = "";
          interval = 2;
        };
        "custom/nixicon" = {
          format = " btw";
        };
      };
    };
    style = ''
      * {
          border: none;
          font-family: "DejaVuSansMono Nerd Font", monospace;
          font-weight: bold;
          font-size: 14px;
      }

      window#waybar {
          background-color: rgba(${raw.base00-rgb-r}, ${raw.base00-rgb-g}, ${raw.base00-rgb-b}, 0.60);
          color: ${c.base05};
          border-radius: 8px;
          border: 1px solid rgba(${raw.base0D-rgb-r}, ${raw.base0D-rgb-g}, ${raw.base0D-rgb-b}, 0.4);
      }

      #cpu,
      #tray,
      #tags,
      #clock,
      #mpris,
      #custom-nixicon,
      #network,
      #temperature,
      #custom-gpu,
      #memory,
      #pulseaudio {
          padding: 0 8px;
          margin: 0 2px;
      }

      #clock {
          color: ${c.base0C};
          background-color: rgba(${raw.base0C-rgb-r}, ${raw.base0C-rgb-g}, ${raw.base0C-rgb-b}, 0.1);
          border-radius: 4px;
      }

      #mpris,
      #cpu,
      #temperature {
          color: ${c.base0E};
      }

      #network,
      #memory {
          color: ${c.base0A};
      }

      #custom-nixicon,
      #tags button.focused,
      #pulseaudio {
          color: ${c.base0B};
      }

      #tags button {
          color: ${c.base03};
          padding: 0 4px;
      }

      #tags button.focused {
          background-color: rgba(${raw.base0B-rgb-r}, ${raw.base0B-rgb-g}, ${raw.base0B-rgb-b}, 0.15);
          border-radius: 4px;
      }

      #tags button.urgent {
          color: ${c.base08};
      }

      #tray {
          color: ${c.base03};
      }

      #cpu.warning,
      #memory.warning {
          color: ${c.base0A};
      }

      #cpu.critical,
      #temperature.critical,
      #memory.critical {
          color: ${c.base08};
      }
    '';
  };

  # Shell & Terminal
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      fastfetch
    '';
  };

  programs.starship.enable = true;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "DejaVuSansM Nerd Font";
      background_opacity = "0.85";

      # Dynamic colors pulled directly from Stylix Base16 palette
      foreground = c.base05;
      background = c.base00;

      color0 = c.base00;
      color1 = c.base08; # Red
      color2 = c.base0B; # Green
      color3 = c.base0A; # Yellow
      color4 = c.base0D; # Blue
      color5 = c.base0E; # Magenta
      color6 = c.base0C; # Cyan
      color7 = c.base05; # Light Gray

      color8 = c.base03; # Dark Gray
      color9 = c.base08;
      color10 = c.base0B;
      color11 = c.base0A;
      color12 = c.base0D;
      color13 = c.base0E;
      color14 = c.base0C;
      color15 = c.base07; # White
    };
  };

  # --- USER PACKAGES ---
  home.packages = with pkgs; [
    # Modern CLI Replacements
    zoxide
    bat
    eza
    fd
    ripgrep
    dust

    # Terminal Applications
    yazi
    cbonsai
    btop
    fastfetch
    helix
    nixfmt
    cava
    pastel
    rust-analyzer
    opencode

    # Desktop & Wayland Setup
    rofi
    awww

    # User Applications & Launchers
    filezilla
    gimp
    prismlauncher
    beammp-launcher
    playerctl

    # Custom Commands
    (writeShellScriptBin "rebuild" ''
      set -e
      MSG="''${1:-update system}"
      cd /etc/nixos
      git add .
      git commit -m "$MSG"
      git push
      sudo nixos-rebuild switch --flake .
    '')
    (writeShellScriptBin "screenshot" ''
      export PATH="${
        pkgs.lib.makeBinPath [
          pkgs.wayfreeze
          pkgs.slurp
          pkgs.grim
          pkgs.wl-clipboard
          pkgs.procps
        ]
      }:$PATH"
      wayfreeze --after-freeze-cmd 'GEOM=$(slurp); [ -n "$GEOM" ] && FILE=~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png && grim -g "$GEOM" "$FILE" && wl-copy < "$FILE"; pkill wayfreeze'
    '')
  ];
}
