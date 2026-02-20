#!/bin/bash

set -e

# ==================================================
#  AESTHETIC DOTFILES UNINSTALLER
# ==================================================

# ---------- Colors ----------
RESET="\e[0m"
BOLD="\e[1m"

PURPLE="\e[38;5;141m"
PINK="\e[38;5;213m"
CYAN="\e[38;5;87m"
GREEN="\e[38;5;84m"
YELLOW="\e[38;5;228m"
RED="\e[38;5;196m"
GRAY="\e[38;5;245m"

print_header() {
    echo -e "\n${PURPLE}${BOLD}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}${BOLD}  $1${RESET}"
    echo -e "${PURPLE}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n"
}

print_step() {
    echo -e "${CYAN}${BOLD}➜ $1${RESET}"
}

print_success() {
    echo -e "${GREEN}${BOLD}✔ $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}${BOLD}⚠ $1${RESET}"
}

print_error() {
    echo -e "${RED}${BOLD}✖ $1${RESET}"
}

ask_confirm() {
    echo -e "\n${PINK}${BOLD}$1 (y/n)${RESET}"
    read -r answer
    [[ "$answer" =~ ^[Yy]$ ]]
}

# ---------- Safety ----------
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root."
    exit 1
fi

print_header "DOTFILES UNINSTALLATION"

if ! ask_confirm "Proceed with uninstall?"; then
    print_warning "Uninstall cancelled."
    exit 0
fi

# ==================================================
# Remove Themes
# ==================================================

if [ -d "$HOME/.config/themes" ]; then
    print_step "Removing installed themes..."
    rm -rf "$HOME/.config/themes"
    print_success "Themes removed."
else
    print_warning "No themes found to remove."
fi

# ==================================================
# Restore Latest Backup
# ==================================================

LATEST_BACKUP=$(ls -dt "$HOME"/.config-backup-* 2>/dev/null | head -n 1)

if [ -n "$LATEST_BACKUP" ]; then
    if ask_confirm "Restore latest backup?"; then
        print_step "Restoring backup..."
        mv "$LATEST_BACKUP/themes" "$HOME/.config/" 2>/dev/null || true
        print_success "Backup restored (if available)."
    fi
else
    print_warning "No backup directory found."
fi

# ==================================================
# Optional Package Removal
# ==================================================

if ask_confirm "Remove installed Hyprland packages?"; then
    if command -v yay &>/dev/null; then
        print_step "Removing packages..."

        yay -Rns \
            hyprland \
            waybar \
            kitty \
            rofi \
            wf-recorder \
            grim \
            slurp \
            brightnessctl \
            nwg-look \
            network-manager-applet \
            bluez \
            blueman \
            alsa-utils

        print_success "Packages removed."
    else
        print_warning "yay not found. Skipping package removal."
    fi
fi

print_header "UNINSTALL COMPLETE"

echo -e "${PINK}${BOLD}System restored. You may log out if needed.${RESET}"