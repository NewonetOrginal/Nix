{ pkgs, ... }:
let
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
          exec = ''nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | awk -F', ' '{u=$1; t=$2; u_col=(u>85?"#ff334b":(u>60?"#ffb300":"#00ff99")); t_col=(t>80?"#ff334b":(t>65?"#ffb300":"#5ce6ff")); printf "<span foreground=\"#ff71db\">󰢮</span> <span foreground=\"%s\">%d%%</span> <span foreground=\"%s\">%d°C</span>\n", u_col, u, t_col, t}' '';
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
          background-color: rgba(15, 16, 21, 0.60);
          color: #e2e8f0;
          border-radius: 8px;
          border: 1px solid rgba(51, 119, 255, 0.4);
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
          color: #00f0ff;
          background-color: rgba(0, 240, 255, 0.1);
          border-radius: 4px;
      }

      #mpris,
      #cpu,
      #temperature {
          color: #ff71db;
      }

      #network,
      #memory {
          color: #ffd180;
      }

      #custom-nixicon,
      #tags button.focused,
      #pulseaudio {
          color: #66ffb2;
      }

      #tags button {
          color: #525a6c;
          padding: 0 4px;
      }

      #tags button.focused {
          background-color: rgba(102, 255, 178, 0.15);
          border-radius: 4px;
      }

      #tags button.urgent {
          color: #ff334b;
      }

      #tray {
          color: #525a6c;
      }

      #cpu.warning,
      #memory.warning {
          color: #ffd180;
      }

      #cpu.critical,
      #temperature.critical,
      #memory.critical {
          color: #ff334b;
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
      background_opacity = "0.6";

      foreground = c.base05;
      background = c.base00;

      color0 = c.base00;
      color1 = c.base08;
      color2 = c.base0B;
      color3 = c.base0A;
      color4 = c.base0D;
      color5 = c.base0E;
      color6 = c.base0C;
      color7 = c.base05;

      color8 = c.base03;
      color9 = c.base08;
      color10 = c.base0B;
      color11 = c.base0A;
      color12 = c.base0D;
      color13 = c.base0E;
      color14 = c.base0C;
      color15 = c.base07;
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
  ];
}
