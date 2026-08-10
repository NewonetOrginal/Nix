{ config, pkgs, ... }:

let
  # Stylix color helpers
  c = config.lib.stylix.colors.withHashtag;
  raw = config.lib.stylix.colors;
  inherit (config.lib.formats.rasi) mkLiteral;
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
    enableCompletion = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      autoload -Uz compinit
      if [[ -n ~/.zcompdump(#qN.m+1)]]; then
        compinit
      else
        compinit -C
      fi
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
      selection_foreground = c.base05;
      selection_background = c.base0D;

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

  programs.helix = {
    enable = true;

    settings = {
      theme = "custom";
    };

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
        }
      ];
    };

    themes = {
      custom = {
        "ui.background" = {
          bg = c.base00;
        };
        "ui.text" = {
          fg = c.base05;
        };
        "ui.text.focus" = {
          fg = c.base06;
          modifiers = [ "bold" ];
        };
        "ui.cursor" = {
          fg = c.base00;
          bg = c.base05;
        };
        "ui.cursor.match" = {
          fg = c.base00;
          bg = c.base0D;
        };
        "ui.selection" = {
          bg = c.base0D;
        };
        "ui.selection.primary" = {
          bg = c.base0D;
        };
        "ui.linenr" = {
          fg = c.base03;
        };
        "ui.linenr.selected" = {
          fg = c.base05;
          modifiers = [ "bold" ];
        };
        "ui.statusline" = {
          fg = c.base04;
          bg = c.base01;
        };
        "ui.statusline.inactive" = {
          fg = c.base03;
          bg = c.base01;
        };
        "ui.popup" = {
          bg = c.base01;
          fg = c.base05;
        };
        "ui.window" = {
          fg = c.base02;
        };
        "ui.help" = {
          bg = c.base01;
          fg = c.base05;
        };

        "comment" = {
          fg = c.base03;
          modifiers = [ "italic" ];
        };
        "string" = {
          fg = c.base0B;
        }; # Success / Green
        "constant" = {
          fg = c.base09;
        }; # Orange / Warning
        "constant.numeric" = {
          fg = c.base09;
        };
        "constant.boolean" = {
          fg = c.base09;
        };
        "variable" = {
          fg = c.base05;
        };
        "variable.builtin" = {
          fg = c.base0E;
        }; # Purple
        "function" = {
          fg = c.base0D;
        }; # Cobalt Blue
        "function.macro" = {
          fg = c.base0C;
        }; # Cyan
        "keyword" = {
          fg = c.base0E;
        }; # Purple
        "operator" = {
          fg = c.base08;
        };
        "punctuation.bracket" = {
          fg = c.base08;
        };
        "punctuation.delimmiter" = {
          fg = c.base08;
        };
        "type" = {
          fg = c.base0A;
        }; # Yellow
        "constructor" = {
          fg = c.base0D;
        };

        "warning" = {
          fg = c.base09;
        };
        "error" = {
          fg = c.base08;
        };
        "info" = {
          fg = c.base0C;
        };
        "hint" = {
          fg = c.base03;
        };
        "diagnostic.error" = {
          underline = {
            color = c.base08;
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = c.base09;
            style = "curl";
          };
        };
      };
    };
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run,filebrowser,window";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-filebrowser = " ";
      display-window = " ";
      drun-display-format = "{name}";
      font = "DejaVuSansMono Nerd Font 10";
    };

    theme = {
      "*" = {
        bg = mkLiteral "${c.base00}bd";
        bg-alt = mkLiteral "${c.base01}80";
        fg = mkLiteral "${c.base05}";
        fg-alt = mkLiteral "${c.base04}";

        accent-blue = mkLiteral "${c.base0D}";
        accent-purple = mkLiteral "${c.base0E}";
        accent-cyan = mkLiteral "${c.base0C}";
        border-col = mkLiteral "${c.base0E}";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        margin = mkLiteral "0";
        padding = mkLiteral "0";
      };

      "window" = {
        transparency = mkLiteral "\"real\"";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        width = mkLiteral "600px";
        enabled = true;
        border = mkLiteral "2px solid";
        border-color = mkLiteral "@border-col";
        border-radius = mkLiteral "0px";
        background-color = mkLiteral "@bg";
        cursor = mkLiteral "default";
      };

      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "15px";
        padding = mkLiteral "20px";
        orientation = mkLiteral "vertical";
        children = map mkLiteral [
          "inputbar"
          "listview"
        ];
      };

      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10px";
        padding = mkLiteral "10px 15px";
        border = mkLiteral "1px solid";
        border-color = mkLiteral "${c.base02}";
        border-radius = mkLiteral "0px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@fg";
        children = map mkLiteral [
          "prompt"
          "entry"
        ];
      };

      "prompt" = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent-blue";
      };

      "entry" = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@fg-alt";
      };

      "listview" = {
        enabled = true;
        columns = 1;
        lines = 7;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        spacing = mkLiteral "4px";
      };

      "element" = {
        enabled = true;
        spacing = mkLiteral "10px";
        padding = mkLiteral "8px 12px";
        border-radius = mkLiteral "0px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal, element alternate.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
      };

      "element selected.normal, element selected.active" = {
        background-color = mkLiteral "@accent-blue";
        text-color = mkLiteral "@bg";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
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
    alacritty
    yazi
    cbonsai
    btop
    fastfetch
    nixfmt
    cava
    pastel
    rust-analyzer
    opencode

    # Desktop & Wayland Setup
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
    (writeShellScriptBin "check" ''
      sudo nixos-rebuild dry-build --flake /etc/nixos
    '')
  ];
}
