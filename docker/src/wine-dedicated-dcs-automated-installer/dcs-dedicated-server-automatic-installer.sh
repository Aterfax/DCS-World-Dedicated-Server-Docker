#!/bin/bash
# shellcheck shell=bash

wine DCS_World_OpenBeta_Server_modular.exe &
sleep 10
/app/dcs_server/xdotool-sequences/install-dcs-server.xdotool.seq_download.sh