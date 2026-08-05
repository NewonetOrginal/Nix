# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

 services.xserver = {
 enable = true;
 videoDrivers = [ "nvidia" ];
 };

hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."nixbtw" = {
    isNormalUser = true;
    description = "nixbtw";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  programs.river-classic = {
  enable = true;
  extraPackages = with pkgs; [
    # Wayland helpers river usually needs:
    swaylock
    swayidle
  ];
};


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
  enable = false;
  extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
  };
  
  programs.firefox = {
    enable = true;
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

programs.atuin = {
  enable = true;
  enableZshIntegration = true;  
};
  
programs.git.enable = true;
programs.starship.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Modern Core CLI Replacements
    zoxide          # cd replacement
    bat             # cat replacement
    eza             # ls replacement
    fd              # find replacement
    ripgrep         # grep replacement
    dust            # du replacement
  #  thefuck         # auto-correct typos

    # Terminal TUI Apps
    yazi            # Terminal file manager
    btop            # Resource monitor
    fastfetch       # System info fetch
    helix           # Terminal editor
    wiremix         # Audio mixer TUI
    opencode        # AI coding assistant
    cava
    pastel

    # Desktop & Wayland Setup
    waybar          # Status bar
    rofi            # App launcher / menu
    awww            # Wallpaper daemon
    kitty           # Terminal emulator
    grim            # Wayland screenshot CLI
    slurp           # Wayland region selector

    # Apps
    filezilla
    prismlauncher

    # Core Utils & Archives
    zsh
    rustup
    gcc
    playerctl
    pkg-config
    openssl
    openssl.dev
    rust-analyzer
    wget            # Web downloader
    kanshi       # Display checking tool
    wl-clipboard    # Wayland copy/paste
    _7zz            # 7-zip archive utility
    unrar           # RAR extractor
  ];

  fonts.packages = with pkgs; [
  nerd-fonts.dejavu-sans-mono
  noto-fonts-cjk-sans  
  ];
  
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND="1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NVD_BACKEND = "direct";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    PATH = [ "$HOME/.cargo/bin"];
  };

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;
      theme = spicePkgs.themes.starryNight;

      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle
      ];

      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
    };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
