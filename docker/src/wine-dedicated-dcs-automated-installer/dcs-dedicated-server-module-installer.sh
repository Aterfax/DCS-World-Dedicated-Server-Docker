#!/bin/bash

# Source DCS Dirs finder helper
# This sets the following variables:
# DCS_saved_games_dir_open_beta
# DCS_saved_games_dir_release
# DCS_install_dir_openbeta
# DCS_install_dir_release
source /app/dcs_server/find_dcs_dirs_function

# If we're conducting an automatic module install just do that. First check if it was called with args.
if [ $# -gt 0 ]; then

    # Parse the first argument (the action)
    action="$1"

    # Check if the action is either "install" or "uninstall"
    if [ "$action" != "install" ] && [ "$action" != "uninstall" ]; then
        echo "Invalid action. Use either 'install' or 'uninstall'."
        exit 1
    fi

    # Shift the argument list to remove the first argument (action)
    shift

    # The remaining arguments are DCSMODULES
    DCSMODULES="$@"

    # Validate DCSMODULES using regex (alphanumeric, underscores, or spaces)
    if ! [[ "$DCSMODULES" =~ ^[A-Za-z0-9_[:space:]]*$ ]]; then
        echo "Invalid value for DCSMODULES. The list should be supplied as a whitespace separated list of modules as per https://forum.dcs.world/topic/324040-eagle-dynamics-modular-dedicated-server-installer/"
        exit 1
    fi

    # Start automated install
    wine "${DCS_install_dir_release}"/bin/DCS_updater.exe ${action} ${DCSMODULES}

    exit 0
fi

# Define the table of modules
csv_data="
Module name,ID
Supercarrier,SUPERCARRIER
WWII Units pack,WWII-ARMOUR
Caucasus,CAUCASUS_terrain
Nevada Test and Training Range,NEVADA_terrain
Normandy 1944,NORMANDY_terrain
Persian Gulf,PERSIANGULF_terrain
The Channel,THECHANNEL_terrain
Syria,SYRIA_terrain
Mariana Islands,MARIANAISLANDS_terrain
South Atlantic,FALKLANDS_terrain
Sinai,SINAIMAP_terrain
"

# Convert the CSV data into an array
IFS=$'\n' read -r -d '' -a csv_lines <<< "$csv_data"

# Create an associative array to store the mapping of names to IDs
declare -A module_map

# Populate the associative array
for line in "${csv_lines[@]:1}"; do
    name=$(echo "$line" | cut -d',' -f1)
    id=$(echo "$line" | cut -d',' -f2)
    module_map["$name"]=$id
done

# Initialize an empty associative array to store selected IDs
declare -A selected_ids_map

# Prompt the user to select an action (install or uninstall)
echo "Select an action (1: Install, 2: Uninstall): "
select action_option in "Install" "Uninstall"; do
    case $action_option in
        "Install")
            action="install"
            break
            ;;
        "Uninstall")
            action="uninstall"
            break
            ;;
        *)
            echo "Invalid option. Please select 1 for Install or 2 for Uninstall."
            ;;
    esac
done

# Interactive selection loop
while true; do
    echo "Select a module by name (type 'done' to finish selection):"
    select name in "${!module_map[@]}" "all"; do
        if [[ -n "$name" ]]; then
            if [[ "$name" == "all" ]]; then
                for id in "${module_map[@]}"; do
                    selected_ids_map["$id"]=1
                done
                break 2
            else
                selected_ids_map["${module_map[$name]}"]=1
            fi
        elif [[ "$REPLY" == "done" ]]; then
            break 2
        fi
    done
done

# Extract unique IDs and sort them
selected_ids=($(printf "%s\n" "${!selected_ids_map[@]}" | sort))

# Output the selected IDs as a space-separated list
echo -e "\nAbout to run the following command: \n"
echo -e "wine ${DCS_install_dir_release}/bin/DCS_updater.exe ${action} ${selected_ids[*]}"
read -rp "Press Enter to continue if this looks correct or Ctrl-C to abort."
wine "${DCS_install_dir_release}"/bin/DCS_updater.exe ${action} ${selected_ids[*]}