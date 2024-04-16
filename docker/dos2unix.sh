#!/bin/bash
# shellcheck shell=bash
find . -type f \( -name "*.sh" -o -name "up" -o -name "run" \) -exec dos2unix {} \;
find ./src/helper_functions -type f -exec dos2unix {} \;
find ./src/desktop-setup -type f -exec dos2unix {} \;
find . -type f  | xargs git update-index --chmod=+x
