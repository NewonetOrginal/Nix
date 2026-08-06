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
    waybar
    rofi
    awww
    kitty

    # User Applications & Launchers
    filezilla
    prismlauncher
    beammp-launcher
    playerctl
  ];
}
