#!/bin/bash

# Universal Package Manager (upm)
# Usage: upm <action> <package>
# Actions: install, remove, update, upgrade

# Function to display help message
show_help() {
    echo "Universal Package Manager (upm)"
    echo "Usage: upm <action> [package]"
    echo "Actions:"
    echo "  install <package>  - Install a package"
    echo "  remove <package>   - Remove a package"
    echo "  update <package>   - Update a specific package"
    echo "  upgrade            - Upgrade all packages"
    echo "Options:"
    echo "  -h, --help         - Show this help message"
    exit 0
}
check_version() {
    CURRENT_VERSION_FILE="/etc/upm-version"
    REMOTE_VERSION_URL="https://raw.githubusercontent.com/sctech-tr/upm/main/upm-version"

    # Fetch the remote version from the URL
    if ! REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL"); then
        echo "Error: Failed to fetch remote version." >&2
        exit 1
    fi

    # Read the current version from the version file
    if [ -f "$CURRENT_VERSION_FILE" ]; then
        CURRENT_VERSION=$(cat "$CURRENT_VERSION_FILE")
    else
        echo "Error: Current version file not found." >&2
        exit 1
    fi

    # Compare the remote version with the current version
    if [ "$REMOTE_VERSION" != "$CURRENT_VERSION" ]; then
        echo "betterfetch $REMOTE_VERSION is available! You are currently on version $CURRENT_VERSION."
        exit 0
    fi
}


# Function to detect the primary package manager
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    elif command -v apk &> /dev/null; then
        echo "apk"
    elif command -v brew &> /dev/null; then
        echo "brew"
    elif command -v port &> /dev/null; then
        echo "port"
    elif command -v pkg &> /dev/null; then
        echo "pkg"
    elif command -v emerge &> /dev/null; then
        echo "emerge"
    elif command -v xbps-install &> /dev/null; then
        echo "xbps"
    elif command -v nix-env &> /dev/null; then
        echo "nix"
    elif command -v snap &> /dev/null; then
        echo "snap"
    elif command -v flatpak &> /dev/null; then
        echo "flatpak"
    else
        echo "unknown"
    fi
}

# Function to run the appropriate command based on the package manager and action
run_command() {
    local pm="$1"
    local action="$2"
    local package="$3"

    case "$pm" in
        apt)
            case "$action" in
                install) sudo apt install "$package" ;;
                remove) sudo apt remove "$package" ;;
                update) sudo apt update && sudo apt upgrade "$package" ;;
                upgrade) sudo apt update && sudo apt upgrade ;;
                *) echo "Error: Invalid action for apt."; exit 1 ;;
            esac
            ;;
        dnf|yum)
            case "$action" in
                install) sudo $pm install "$package" ;;
                remove) sudo $pm remove "$package" ;;
                update) sudo $pm update "$package" ;;
                upgrade) sudo $pm upgrade ;;
                *) echo "Error: Invalid action for $pm."; exit 1 ;;
            esac
            ;;
        pacman)
            case "$action" in
                install) sudo pacman -S "$package" ;;
                remove) sudo pacman -R "$package" ;;
                update) sudo pacman -Syu "$package" ;;
                upgrade) sudo pacman -Syu ;;
                *) echo "Error: Invalid action for pacman."; exit 1 ;;
            esac
            ;;
        zypper)
            case "$action" in
                install) sudo zypper install "$package" ;;
                remove) sudo zypper remove "$package" ;;
                update) sudo zypper update "$package" ;;
                upgrade) sudo zypper upgrade ;;
                *) echo "Error: Invalid action for zypper."; exit 1 ;;
            esac
            ;;
        apk)
            case "$action" in
                install) sudo apk add "$package" ;;
                remove) sudo apk del "$package" ;;
                update) sudo apk update && sudo apk upgrade "$package" ;;
                upgrade) sudo apk update && sudo apk upgrade ;;
                *) echo "Error: Invalid action for apk."; exit 1 ;;
            esac
            ;;
        brew)
            case "$action" in
                install) brew install "$package" ;;
                remove) brew uninstall "$package" ;;
                update) brew upgrade "$package" ;;
                upgrade) brew upgrade ;;
                *) echo "Error: Invalid action for brew."; exit 1 ;;
            esac
            ;;
        port)
            case "$action" in
                install) sudo port install "$package" ;;
                remove) sudo port uninstall "$package" ;;
                update) sudo port selfupdate && sudo port upgrade "$package" ;;
                upgrade) sudo port selfupdate && sudo port upgrade outdated ;;
                *) echo "Error: Invalid action for port."; exit 1 ;;
            esac
            ;;
        pkg)
            case "$action" in
                install) sudo pkg install "$package" ;;
                remove) sudo pkg delete "$package" ;;
                update) sudo pkg update && sudo pkg upgrade "$package" ;;
                upgrade) sudo pkg update && sudo pkg upgrade ;;
                *) echo "Error: Invalid action for pkg."; exit 1 ;;
            esac
            ;;
        emerge)
            case "$action" in
                install) sudo emerge "$package" ;;
                remove) sudo emerge --unmerge "$package" ;;
                update) sudo emerge --update "$package" ;;
                upgrade) sudo emerge --update --deep --with-bdeps=y @world ;;
                *) echo "Error: Invalid action for emerge."; exit 1 ;;
            esac
            ;;
        xbps)
            case "$action" in
                install) sudo xbps-install "$package" ;;
                remove) sudo xbps-remove "$package" ;;
                update) sudo xbps-install -u "$package" ;;
                upgrade) sudo xbps-install -Su ;;
                *) echo "Error: Invalid action for xbps."; exit 1 ;;
            esac
            ;;
        nix)
            case "$action" in
                install) nix-env -i "$package" ;;
                remove) nix-env -e "$package" ;;
                update) nix-env -u "$package" ;;
                upgrade) nix-env -u ;;
                *) echo "Error: Invalid action for nix."; exit 1 ;;
            esac
            ;;
        snap)
            case "$action" in
                install) sudo snap install "$package" ;;
                remove) sudo snap remove "$package" ;;
                update) sudo snap refresh "$package" ;;
                upgrade) sudo snap refresh ;;
                *) echo "Error: Invalid action for snap."; exit 1 ;;
            esac
            ;;
        flatpak)
            case "$action" in
                install) flatpak install "$package" ;;
                remove) flatpak uninstall "$package" ;;
                update) flatpak update "$package" ;;
                upgrade) flatpak update ;;
                *) echo "Error: Invalid action for flatpak."; exit 1 ;;
            esac
            ;;
        *)
            echo "Error: Unable to detect a supported package manager."
            exit 1
            ;;
    esac
}

# Main script
check_version

if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
fi

action="$1"
package="$2"

if [[ "$action" != "install" && "$action" != "remove" && "$action" != "update" && "$action" != "upgrade" ]]; then
    echo "Error: Invalid action. Use -h or --help for usage information."
    exit 1
fi

if [[ "$action" != "upgrade" && -z "$package" ]]; then
    echo "Error: Package name is required for $action action."
    exit 1
fi

pm=$(detect_package_manager)
run_command "$pm" "$action" "$package"