# NixOS-config-test

A minimal NixOS system configuration for a virtual machine, running
[Hyprland](https://hyprland.org/) on Wayland with SDDM and PipeWire.

This is a testbed for trying out a NixOS setup before applying it to real
hardware.

## What's included

| Area | Choice |
| --- | --- |
| Bootloader | GRUB (BIOS, `/dev/vda`) with OS prober |
| Networking | NetworkManager, hostname `nixos` |
| Locale / keymap | `en_US.UTF-8`, `America/Mexico_City`, US keyboard |
| Compositor | Hyprland (+ XWayland) |
| Display manager | SDDM in Wayland mode |
| Audio | PipeWire (ALSA + 32-bit ALSA + PulseAudio compatibility) |
| Portals | `xdg-desktop-portal-hyprland` for screen sharing and file pickers |
| Remote access | OpenSSH |
| Nix features | `nix-command` and `flakes` enabled |
| User | `adrian` (`wheel`, `networkmanager`) |

Desktop utilities installed system-wide: `kitty` (terminal), `rofi` (launcher),
`waybar` (bar), `dunst` (notifications), `swww` (wallpaper), `wl-clipboard`,
`grim` + `slurp` (screenshots), plus `git` and `wget`.

## Layout

```
configuration.nix   # the whole system configuration
```

`hardware-configuration.nix` is intentionally **not** tracked: it is generated
per machine by `nixos-generate-config` and is imported by `configuration.nix`.

## Usage

Install the configuration on a NixOS machine or VM:

```bash
# generate the machine-specific hardware configuration (once)
sudo nixos-generate-config --root /mnt   # during installation
# or, on a running system:
sudo nixos-generate-config

# copy this configuration into place
sudo cp configuration.nix /etc/nixos/configuration.nix

# build and switch
sudo nixos-rebuild switch
```

To try a change without making it the default boot entry:

```bash
sudo nixos-rebuild test
```

## Notes for VMs

`environment.sessionVariables` sets `WLR_NO_HARDWARE_CURSORS=1` and
`WLR_RENDERER_ALLOW_SOFTWARE=1`, which work around a disappearing cursor and
black screens when running a wlroots compositor without GPU acceleration.
Both can be dropped on real hardware.

## Caveats

- `boot.loader.grub.device = "/dev/vda"` assumes a BIOS virtio disk. On a UEFI
  machine use `boot.loader.systemd-boot` instead.
- `system.stateVersion` is `"26.05"`. Keep it at the release you first
  installed; do not bump it on upgrade.
- `nixpkgs.config.allowUnfree = true` permits unfree packages.
