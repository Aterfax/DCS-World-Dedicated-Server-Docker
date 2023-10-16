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

wait_for_dcs_updater_windows() {
    local limit="$1"
    
    while true; do
        # Run the command and store the output in the variable 'count'
        count=$(xdotool search --name "DCS Updater" | wc -l)
        
        # Check if the value of 'count' is equal to the specified limit
        if [ "$count" -eq "$limit" ]; then
            break  # Exit the loop if the condition is met
        fi
        
        # Wait for a few seconds before running the command again
        sleep 5
    done
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
cd /config && innoextract -e -m DCS_World_OpenBeta_Server_modular.exe
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
if [ "$DCSAUTOINSTALL" -eq 1 ]; then
    /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh install "$DCSMODULES"
else
    /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh
fi

echo
echo "Install complete."