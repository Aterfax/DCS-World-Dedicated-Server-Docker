#!/bin/bash
# shellcheck shell=bash

get_dcs_installer_window_id() {
    echo $(xdotool search --name "DCS Updater")
}

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

# Start the installer
wine DCS_World_OpenBeta_Server_modular.exe &

# Wait for it to fully open
sleep 5

# Now start the automated input process to install
xdotool windowactivate 48234502 key KP_Tab key KP_Enter
sleep 1
xdotool windowactivate --sync 48234507 keydown Tab keyup Tab keydown A keyup A key space key enter
sleep 1
xdotool windowactivate --sync 48234507 key enter
sleep 1
xdotool windowactivate --sync 48234507 key Down key enter
sleep 1
xdotool windowactivate --sync 48234507 key enter
sleep 1
xdotool windowactivate --sync 48234507 key enter
sleep 5
xdotool windowactivate --sync 48234507 key enter
sleep 10
xdotool windowactivate --sync 48234507 key Tab
sleep 1
xdotool windowactivate --sync 48234507 key enter

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

# Sleep for a bit to ensure the installer window is open.
sleep 5

dcs_installer_window_id=$(get_dcs_installer_window_id)

while true; do
    if [[ -z $dcs_installer_window_id ]]; then
        echo
        echo
        break
    fi
    sleep 5
    echo -e "Waiting for the installer to finish before starting module installer."    
    dcs_installer_window_id=$(get_dcs_installer_window_id)
done

# Run the module installer
/app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh