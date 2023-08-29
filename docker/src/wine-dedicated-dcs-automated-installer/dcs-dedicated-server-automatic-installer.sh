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

# Start the installer
wine /config/DCS_World_OpenBeta_Server_modular.exe &

# Wait for it to fully open
sleep 5

# Now start the automated input process to install
WID=$(xdotool search --name "Select Setup Language")
xdotool windowactivate $WID key KP_Tab key KP_Enter
sleep 1
WID=$(xdotool search --name "Setup - DCS World OpenBeta Server" | tail -n 1)
xdotool windowactivate --sync $WID keydown Tab keyup Tab keydown A keyup A key space key enter
sleep 1
xdotool windowactivate --sync $WID key enter
sleep 1
xdotool windowactivate --sync $WID key Down key enter
sleep 1
xdotool windowactivate --sync $WID key enter
sleep 1
xdotool windowactivate --sync $WID key enter
sleep 5
xdotool windowactivate --sync $WID key enter
sleep 10
xdotool windowactivate --sync $WID key Tab
sleep 1
xdotool windowactivate --sync $WID key enter

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

while true; do
    # Run the command and store the output in the variable 'count'
    count=$(xdotool search --name "DCS Updater" | wc -l)
    
    # Check if the value of 'count' is equal to 3
    # 3 windows = installion is finished "Ok" prompt.
    if [ "$count" -eq 3 ]; then
        break  # Exit the loop if the condition is met
    fi
    
    # Wait for a few seconds before running the command again
    sleep 5
done

# Get the window IDs and iterate through each
window_ids=$(xdotool search --name "DCS Updater")
for wid in $window_ids; do
    xdotool windowactivate --sync $wid key Return &
done

sleep 5
echo

# Run the module installer
/app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh

echo
echo "Install complete."