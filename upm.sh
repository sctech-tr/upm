#!/bin/sh

# Universal Package Manager (upm)
# Usage: upm <action> <package(s)>
# Actions: install, remove, update, upgrade, search

# Function to display help message
show_help() {
    echo "Universal Package Manager (upm)"
    echo "Usage: upm <action> [package(s)]"
    echo "Actions:"
    echo "  install <package(s)>  - Install one or more packages"
    echo "  remove <package(s)>   - Remove one or more packages"
    echo "  update <package(s)>   - Update specific package(s)"
    echo "  upgrade               - Upgrade all packages"
    echo "  search <package>      - Search for a package"
    echo "Options:"
    echo "  -h,                   - Show this help message"
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
        echo "upm $REMOTE_VERSION is available! You are currently on version $CURRENT_VERSION."
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
    shift 2
    local packages="$@"

    case "$pm" in
        apt)
            case "$action" in
                install) sudo apt install $packages ;;
                remove) sudo apt remove $packages ;;
                update) sudo apt update && sudo apt upgrade $packages ;;
                upgrade) sudo apt update && sudo apt upgrade ;;
                search) apt search $packages ;;
                *) echo "Error: Invalid action for apt."; exit 1 ;;
            esac
            ;;
        dnf|yum)
            case "$action" in
                install) sudo $pm install $packages ;;
                remove) sudo $pm remove $packages ;;
                update) sudo $pm update $packages ;;
                upgrade) sudo $pm upgrade ;;
                search) $pm search $packages ;;
                *) echo "Error: Invalid action for $pm."; exit 1 ;;
            esac
            ;;
        pacman)
            case "$action" in
                install) sudo pacman -S $packages ;;
                remove) sudo pacman -R $packages ;;
                update) sudo pacman -Syu $packages ;;
                upgrade) sudo pacman -Syu ;;
                search) pacman -Ss $packages ;;
                *) echo "Error: Invalid action for pacman."; exit 1 ;;
            esac
            ;;
        zypper)
            case "$action" in
                install) sudo zypper install $packages ;;
                remove) sudo zypper remove $packages ;;
                update) sudo zypper update $packages ;;
                upgrade) sudo zypper upgrade ;;
                search) zypper search $packages ;;
                *) echo "Error: Invalid action for zypper."; exit 1 ;;
            esac
            ;;
        # Add similar cases for other package managers like apk, brew, etc.
        *)
            echo "Error: Unable to detect a supported package manager."
            exit 1
            ;;
    esac
}

# Main script
check_version

# Parse command line options
while getopts ":h" opt; do
    case ${opt} in
        h )
            show_help
            ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

if [ $# -eq 0 ]; then
    show_help
fi

action="$1"
shift

# Multi-package support
packages="$@"

if [[ "$action" != "upgrade" && -z "$packages" && "$action" != "search" ]]; then
    echo "Error: Package name is required for $action action."
    exit 1
fi

pm=$(detect_package_manager)
run_command "$pm" "$action" "$packages"
