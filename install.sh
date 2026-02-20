#!/bin/bash

set -e

# ==================================================
#  AESTHETIC DOTFILES INSTALLER
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

print_header "DOTFILES INSTALLATION"

if ! ask_confirm "Proceed with installation?"; then
    print_warning "Installation cancelled."
    exit 0
fi

DOTS_DIR="$(pwd)"
THEMES_DIR="$DOTS_DIR/themes"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d%H%M%S)"

# ==================================================
# Essential Packages
# ==================================================

if ask_confirm "Install essential Hyprland packages?"; then
    print_step "Installing essential packages..."

    if ! command -v yay &>/dev/null; then
        print_error "yay not found. Please install yay first."
        exit 1
    fi

    yay -S --needed \
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

    print_success "Essential packages installed."
fi

# ==================================================
# Directories
# ==================================================

print_step "Creating required directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
print_success "Directories ready."

# ==================================================
# Backup
# ==================================================

print_step "Backing up existing themes..."
mkdir -p "$BACKUP_DIR"

if [ -d "$HOME/.config/themes" ]; then
    mv "$HOME/.config/themes" "$BACKUP_DIR/"
    print_success "Old themes backed up."
else
    print_warning "No existing themes found."
fi

# ==================================================
# Install Themes
# ==================================================

print_step "Installing themes..."
cp -r "$THEMES_DIR" "$HOME/.config/"
print_success "Themes installed."

# ==================================================
# Make Scripts Executable
# ==================================================

print_step "Making theme scripts executable..."
find "$HOME/.config/themes" -type f -name "*.sh" -exec chmod +x {} \;
print_success "Scripts are now executable."

# ==================================================
# .zshrc
# ==================================================

print_step "Installing .zshrc..."
if [ -f "$DOTS_DIR/home/.zshrc" ]; then
    cp "$DOTS_DIR/home/.zshrc" "$HOME/"
    print_success ".zshrc installed."
else
    print_warning ".zshrc not found in repo."
fi

if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    print_success "~/.local/bin added to PATH."
fi

# ==================================================
# Done
# ==================================================

print_header "INSTALLATION COMPLETE"

echo -e "${GRAY}Backup stored at:${RESET}"
echo -e "${CYAN}$BACKUP_DIR${RESET}"
echo ""
echo -e "${PINK}${BOLD}Log out and log back in to apply changes.${RESET}"