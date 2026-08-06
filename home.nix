{ pkgs, ... }:

{
  home.username = "nixbtw";
  home.homeDirectory = "/home/nixbtw";
  home.stateVersion = "24.05";

  # Home Manager manages programs directly when possible
  programs.home-manager.enable = true;

  # Web Browsing
  programs.firefox.enable = true;

  # Shell & Terminal
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
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
     
font_family = "DejaVuSansMono Nerd Font";
background_opacity = "0.6";

foreground = "#eadcf5";
background = "#131218";

# ─────────────────────────────────────────────
# Accents
# ─────────────────────────────────────────────
color0  = "#000000";   # Borders, Filelists

color1  = "#df4661";   # Errors (CRT Glitch Red)

color2  = "#54d67f";   # Success

color3  = "#eea243";   # Warnings (Server Status Amber)

color4  = "#3b68e5";   # Directories, symlinks (BSOD Blue)

color5  = "#af70e8";   # Git UI, accent text (Lain Screen Purple)

color6  = "#5ccfe6";   # Prompts, info banners (Glitch Cyan)

color7  = "#edeaff";   # Headings / Light text

# ─────────────────────────────────────────────
# Bright Variants
# ─────────────────────────────────────────────
color8  = "#3f3a47";

color9  = "#f76881";

color10 = "#7fff9f";

color11 = "#ffc475";

color12 = "#6085f2";

color13 = "#c694f5";

color14 = "#8ae4f2";

color15 = "#ffffff";
    };

  };
  programs.waybar = {
    enable = true;
    
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
  ];
}
