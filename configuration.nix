{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Networking & Hostname
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone & Locale
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  # Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User Account
  users.users.adrian = {
    isNormalUser = true;
    description = "Adrian";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable Flakes & Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portals (Required for screensharing/file pickers)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Display Manager (SDDM in Wayland mode)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Audio Setup (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Allow Unfree Software
  nixpkgs.config.allowUnfree = true;

  # Installed Packages
  environment.systemPackages = with pkgs; [
    kitty          # Terminal emulator
    rofi           # App menu launcher
    waybar         # Top bar
    dunst          # Notifications
    swww           # Wallpaper manager
    wl-clipboard   # Copy/paste tool
    grim           # Screenshots
    slurp          # Region selector for screenshots
    wget
    git
  ];

  # Environment variables for Hyprland inside VMs
  environment.sessionVariables = {
    # Fixes cursor disappearing or black screens under Wayland compositors in VMs
    WLR_NO_HARDWARE_CURSORS = "1";
    # Fallback renderer option for WLROOTS
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  # SSH
  services.openssh.enable = true;

  # System Release Version
  system.stateVersion = "26.05";
}
