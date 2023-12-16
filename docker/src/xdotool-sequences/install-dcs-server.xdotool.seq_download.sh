#!/bin/bash
# shellcheck shell=bash
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