#!/bin/bash

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
echo -e "wine '/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/bin/DCS_updater.exe' ${action} ${selected_ids[*]}"
read -rp "Press Enter to continue if this looks correct or Ctrl-C to abort."
wine '/config/.wine/drive_c/Program Files/Eagle Dynamics/DCS World OpenBeta Server/bin/DCS_updater.exe' ${action} ${selected_ids[*]}