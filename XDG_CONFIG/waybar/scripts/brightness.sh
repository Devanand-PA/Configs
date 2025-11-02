#!/bin/bash

# Get brightness from ddcutil
get_brightness() {
    # Use display 1 specifically
    local monitor="1"
    
    # Get current brightness
    local brightness_output=$(ddcutil getvcp 10 --brief --display $monitor 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "󰃠 Err"
        return 1
    fi
    
    local brightness=$(echo "$brightness_output" | awk -F'[, ]' '{print $4}')
    
    if [ -z "$brightness" ]; then
        echo "󰃠 0%"
        return 1
    fi
    
    echo "󰃠 ${brightness}%"
}


get_brightness
