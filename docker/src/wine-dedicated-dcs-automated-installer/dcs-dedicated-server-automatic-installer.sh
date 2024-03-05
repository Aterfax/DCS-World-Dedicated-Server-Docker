#!/bin/bash
# shellcheck shell=bash

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
    if ! [[ "$DCSMODULES" =~ ^[A-Za-z0-9_[:space:]]*$ ]]; then
        echo "Invalid value for DCSMODULES. The list should be supplied as a whitespace separated list of modules as per https://forum.dcs.world/topic/324040-eagle-dynamics-modular-dedicated-server-installer/"
        exit 1
    fi
fi

# Start the installer
cd /config && innoextract -e -m DCS_World_Server_modular.exe
mkdir -p "/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server"
mv app/* "/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/" && rmdir app
cd "/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/bin"
wine DCS_updater.exe --quiet install WORLD

# Remove broken shortcuts.
rm /config/Desktop/Local\ Web\ GUI.desktop
rm /config/Desktop/DCS\ World\ OpenBeta\ Server.desktop

# Create working shortcuts.
create_desktop_shortcut "wine '/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/bin/DCS_updater.exe'" \
                        "/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/FUI/DCS-1.ico" \
                        "Run DCS Updater" \
                        "false"

create_desktop_shortcut "wine '/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/bin/DCS_server.exe'" \
                        "/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/FUI/DCS-1.ico" \
                        "Run DCS Server" \
                        "false"

create_desktop_shortcut "xdg-open '/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/WebGUI/index.html'"\
                        "/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/FUI/DCS-1.ico" \
                        "Open DCS Server WebGUI" \
                        "false"

create_desktop_shortcut "/app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh"\
                        "/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/FUI/DCS-1.ico" \
                        "Run DCS Module Installer" \
                        "true"

create_desktop_shortcut "xdg-open '/config/.wine/drive_c/users/abc/Saved Games/DCS.openbeta_server/'"\
                        "folder-wine" \
                        "DCS Saved Games Dir" \
                        "false"

create_desktop_shortcut "xdg-open '/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/'"\
                        "folder-wine" \
                        "DCS Install Dir" \
                        "false"

# Run the module installer

# Validate DCSMODULES using regex (alphanumeric, underscores, or spaces).
# Works for installations or updates.
if [[ "$DCSMODULES" =~ ^[A-Za-z0-9_[:space:]]*$ ]]; then
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