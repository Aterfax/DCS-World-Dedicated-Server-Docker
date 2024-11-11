#!/bin/bash

# Function to validate install/uninstall IDs
is_valid_id() {
    local id="$1"
    if [[ "$id" =~ ^[A-Za-z0-9_[:space:]-]*$ ]]; then
        return 0  # Valid ID
    else
        return 1  # Invalid ID
    fi
}

# Test function with correct expected results
# https://forum.dcs.world/topic/324040-eagle-dynamics-modular-dedicated-server-installer/
run_tests() {
    local tests=(
        "SUPERCARRIER"               # Should be valid
        "WWII-ARMOUR"                # Should be valid
        "CAUCASUS_terrain"           # Should be valid
        "NEVADA_terrain"             # Should be valid
        "NORMANDY_terrain"           # Should be valid
        "PERSIANGULF_terrain"        # Should be valid
        "THECHANNEL_terrain"         # Should be valid
        "SYRIA_terrain"              # Should be valid
        "MARIANAISLANDS_terrain"     # Should be valid
        "FALKLANDS_terrain"          # Should be valid
        "SINAIMAP_terrain"           # Should be valid
        "KOLA_terrain"               # Should be valid
        "AFGHANISTAN_terrain"        # Should be valid
        "Invalid@ID"                 # Should be invalid
        "Another\!Invalid#ID"        # Should be invalid
    )

    # Expected results corresponding to the test cases above (0 for valid, 1 for invalid)
    local expected_results=(0 0 0 0 0 0 0 0 0 0 0 0 0 1 1)

    for i in "${!tests[@]}"; do
        is_valid_id "${tests[$i]}"
        result=$?

        if [[ $result -eq ${expected_results[$i]} ]]; then
            echo "Test passed for input: ${tests[$i]}"
        else
            echo "Test failed for input: ${tests[$i]}"
        fi
    done
}

# Run the tests
run_tests