#!/bin/bash
# shellcheck shell=bash

# Source DCS Dirs finder helper
# This sets the following variables:
# DCS_saved_games_dir_open_beta
# DCS_saved_games_dir_release
# DCS_saved_games_dir_current
# DCS_saved_games_dir_previous_1
# DCS_install_dir_openbeta
# DCS_install_dir_release
source /app/dcs_server/find_dcs_dirs_function

create_desktop_shortcut() {
    target_executable="$1"
    icon_path="$2"
    name="$3"
    terminalbool="$4"
    desktop_file="$HOME/Desktop/${name// /_}.desktop"  # Replace spaces with underscores

    # Create the desktop shortcut file
    echo "[Desktop Entry]" > "$desktop_file"
    echo "Version=1.0" >> "$desktop_file"
    echo "Name=$name" >> "$desktop_file"
    echo "Comment=$name" >> "$desktop_file"
    echo "Exec=$target_executable" >> "$desktop_file"
    echo "Icon=$icon_path" >> "$desktop_file"
    echo "Terminal=$terminalbool" >> "$desktop_file"
    echo "Type=Application" >> "$desktop_file"
    echo "Categories=Game;" >> "$desktop_file"

    # Make the desktop shortcut executable
    chmod +x "$desktop_file"
}

# Read the autoinstaller environment variables
DCSAUTOINSTALL="${DCSAUTOINSTALL:-0}"
DCSMODULES="${DCSMODULES:-}"

# Validate DCSAUTOINSTALL as boolean (1 or 0)
if [[ "$DCSAUTOINSTALL" != "0" && "$DCSAUTOINSTALL" != "1" ]]; then
    echo "Invalid value for DCSAUTOINSTALL. Should be 0 or 1."
    exit 1
fi

if [ "$DCSAUTOINSTALL" -eq 1 ]; then
    # Validate DCSMODULES using regex (alphanumeric, underscores, or spaces)
    if ! [[ "$DCSMODULES" =~ ^[A-Za-z0-9_[:space:]-]*$ ]]; then
        echo "Invalid value for DCSMODULES. The list should be supplied as a whitespace separated list of modules as per https://forum.dcs.world/topic/324040-eagle-dynamics-modular-dedicated-server-installer/"
        exit 1
    fi
fi

# Start the installer
cd /config && innoextract -e -m DCS_World_Server_modular.exe
mkdir -p "${DCS_install_dir_release}"
mv app/* "${DCS_install_dir_release}/" && rmdir app
cd "${DCS_install_dir_release}/bin"
# Break the updater race condition where it tries to update over itself while running
mv DCS_updater.exe DCS_updater_initial.exe
wine DCS_updater_initial.exe --quiet update
sleep 1
rm DCS_updater_initial.exe
wine DCS_updater.exe --quiet install WORLD

# Remove broken shortcuts.
rm /config/Desktop/Local\ Web\ GUI.desktop
rm /config/Desktop/DCS\ World\ OpenBeta\ Server.desktop

# Create working shortcuts.
create_desktop_shortcut "wine \"${DCS_install_dir_release}/bin/DCS_updater.exe\"" \
                        "${DCS_install_dir_release}/FUI/DCS-1.ico" \
                        "Run DCS Updater" \
                        "false"

create_desktop_shortcut "wine \"${DCS_install_dir_release}/bin/DCS_server.exe\"" \
                        "${DCS_install_dir_release}/FUI/DCS-1.ico" \
                        "Run DCS Server" \
                        "false"

create_desktop_shortcut "xdg-open \"${DCS_install_dir_release}/WebGUI/index.html\""\
                        "${DCS_install_dir_release}/FUI/DCS-1.ico" \
                        "Open DCS Server WebGUI" \
                        "false"

create_desktop_shortcut "/app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh"\
                        "${DCS_install_dir_release}/FUI/DCS-1.ico" \
                        "Run DCS Module Installer" \
                        "true"

create_desktop_shortcut "xdg-open \"${DCS_saved_games_dir_current}/\""\
                        "folder-wine" \
                        "DCS Saved Games Dir" \
                        "false"

create_desktop_shortcut "xdg-open \"${DCS_install_dir_release}/\""\
                        "folder-wine" \
                        "DCS Install Dir" \
                        "false"

# Run the module installer

# Validate DCSMODULES using regex (alphanumeric, underscores, or spaces).
# Works for installations or updates.
if [[ "$DCSMODULES" =~ ^[A-Za-z0-9_[:space:]-]*$ ]]; then
    echo "Modules installation starting."
    /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh install "$DCSMODULES"
    echo
    echo "Install complete."
    exit 0
fi

echo "Manual installation, please select modules to install/"
/app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh
echo
echo "Install complete."
exit 0
