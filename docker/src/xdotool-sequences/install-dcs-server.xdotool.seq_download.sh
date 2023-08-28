#!/bin/bash
# shellcheck shell=bash
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

# Wait for the user to confirm that the download has finished to create shortcuts.
read -rp "Press Enter to continue when the download and installation has finished to create desktop shortcuts."
# Remove broken shortcuts.
rm /config/Desktop/Local\ Web\ GUI.desktop
rm /config/Desktop/DCS\ World\ OpenBeta\ Server.desktop
# Create shortcuts.
"/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/bin/"