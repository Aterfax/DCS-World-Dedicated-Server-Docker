#!/bin/bash
# shellcheck shell=bash
find . -type f \( -name "*.sh" -o -name "up" -o -name "run" \) -exec dos2unix {} \;
