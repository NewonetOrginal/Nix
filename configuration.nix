{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Timezone and Locales
  time.timeZone = "Europe/Warsaw";
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

  # Graphics & Nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.lightdm.enable = false;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Wayland Portal integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [
      "wlr"
      "gtk"
    ];
  };

  # Users
  users.users."nixbtw" = {
    isNormalUser = true;
    description = "nixbtw";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # System-wide window manager configuration
  programs.river-classic = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.zsh.enable = true;

  stylix = {
    enable = true;
    image = ./WallpapersFused.png;
    polarity = "dark";
    autoEnable = false;
  };

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    # Core system tools & build essentials
    wget
    gcc
    rustup
    pkg-config
    openssl
    openssl.dev
    _7zz
    unrar

    # Wayland hardware/display helpers
    grim
    slurp
    wl-clipboard
    kanshi
    wiremix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.dejavu-sans-mono
    noto-fonts-cjk-sans
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NVD_BACKEND = "direct";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    PATH = [ "$HOME/.cargo/bin" ];
    NIXOS_OZONE_WL = "1";
  };

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
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

  # Import Home Manager configuration module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users."nixbtw" = ./home.nix;
  };

  system.stateVersion = "26.05";
}
