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
xdotool windowactivate --sync 48234507 key Tab space
sleep 1
xdotool windowactivate --sync 48234507 key enter