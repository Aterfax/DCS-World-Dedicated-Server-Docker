#!/bin/bash
# shellcheck shell=bash

create_desktop_shortcut() {
    target_executable="$1"
    icon_path="$2"
    name="$3"
    terminalbool="$4"
    workdir="$5"
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
    echo "Path=$workdir" >> "$desktop_file"

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

create_desktop_shortcut "xdg-open '/config/.wine/drive_c/users/abc/Saved Games/DCS.release_server/'"\
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
else
    echo "Manual installation, please select modules to install/"
    /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh
fi

SAVED_GAMES_DIR="/config/.wine/drive_c/users/abc/Saved Games"
SERVER_DIR="$SAVED_GAMES_DIR/DCS.release_server"
DCS_BIN_DIR="/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server"

[ -d "$SERVER_DIR/Missions" ] || mkdir -p "$SERVER_DIR/Missions"
[ -d "$SERVER_DIR/MissionEditor/UnitPayloads" ] || mkdir -p "$SERVER_DIR/MissionEditor/UnitPayloads"

echo
echo "Install complete."

if [[ -z "${ENABLE_RETRIBUTION}" ]]; then
    echo "No ENABLE_RETRIBUTION set, skipping DCS Retribution installation."
    exit 0
fi

echo
echo "Installing DCS Retribution"

RETRIBUTION_LATEST=$(curl -s https://api.github.com/repos/dcs-retribution/dcs-retribution/releases/latest)
RETRIBUTION_DL_URL=$(echo $RETRIBUTION_LATEST | jq -r .assets[0].browser_download_url)
RETRIBUTION_TAG=$(echo $RETRIBUTION_LATEST | jq -r .name)

RETRIBUTION_ZIP="$SAVED_GAMES_DIR/dcs-retribution-$RETRIBUTION_TAG.zip"
RETRIBUTION_INSTALL_DIR="$SAVED_GAMES_DIR/dcs-retribution"

RETRIBUTION_VERSION_FILE="$SAVED_GAMES_DIR/dcs-retribution.version.txt"
RETRIBUTION_LOCALAPPDATA="/config/.wine/drive_c/users/abc/AppData/Local/DCSRetribution"
RETRIBUTION_CFG="$RETRIBUTION_LOCALAPPDATA/retribution_preferences.json"

echo "Checking if DCS Retribution latest ${RETRIBUTION_TAG} needs to be downloaded..."
if [ ! -f "$RETRIBUTION_VERSION_FILE" ] || grep -v "$RETRIBUTION_TAG" "$RETRIBUTION_VERSION_FILE"; then
    echo "Downloading $RETRIBUTION_DL_URL"
    wget "$RETRIBUTION_DL_URL" -O "$RETRIBUTION_ZIP" && \
    unzip -o "$RETRIBUTION_ZIP" -d "$SAVED_GAMES_DIR" && \
    rm "$RETRIBUTION_ZIP" && \
    echo "$RETRIBUTION_TAG" > "$RETRIBUTION_VERSION_FILE"
fi

if [ ! -f "$RETRIBUTION_CFG" ]; then
    [ -d "$RETRIBUTION_LOCALAPPDATA" ] || mkdir "$RETRIBUTION_LOCALAPPDATA"
    cp /app/retribution_preferences.json "$RETRIBUTION_CFG"
    echo "Copied retribution config to $RETRIBUTION_CFG"
fi

DCS_MISSION_SCRIPTING_LUA="$DCS_BIN_DIR/Scripts/MissionScripting.lua"
echo "Deactivating sanitizeModule"
sed -i "s/sanitizeModule('os')/--sanitizeModule('os')/g" "$DCS_MISSION_SCRIPTING_LUA"
sed -i "s/sanitizeModule('io')/--sanitizeModule('io')/g" "$DCS_MISSION_SCRIPTING_LUA"
sed -i "s/sanitizeModule('lfs')/--sanitizeModule('lfs')/g" "$DCS_MISSION_SCRIPTING_LUA"

create_desktop_shortcut "wine \"$RETRIBUTION_INSTALL_DIR/retribution_main.exe\"" \
                        "$RETRIBUTION_INSTALL_DIR/resources/icon.ico" \
                        "DCS Retribution" \
                        "false" \
                        "$RETRIBUTION_INSTALL_DIR"

if [ ! -f "/config/.wine/drive_c/windows/Fonts" ]; then
    wine regedit /app/fontsmoothing.reg
    cp /app/courbd.ttf "/config/.wine/drive_c/windows/Fonts"
fi

exit 0