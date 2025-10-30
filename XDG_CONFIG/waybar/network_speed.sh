#!/bin/bash

# Replace eth0 with your network interface
INTERFACE="eth0"

while true; do
    # Read initial values
    RX1=$(awk -v iface="$INTERFACE" '$1 ~ iface {print $2}' /proc/net/dev)
    TX1=$(awk -v iface="$INTERFACE" '$1 ~ iface {print $10}' /proc/net/dev)
    
    sleep 1
    
    # Read new values
    RX2=$(awk -v iface="$INTERFACE" '$1 ~ iface {print $2}' /proc/net/dev)
    TX2=$(awk -v iface="$INTERFACE" '$1 ~ iface {print $10}' /proc/net/dev)

    # Calculate speeds
    RX_SPEED=$(( (RX2 - RX1) / 1024 ))  # Speed in KB
    TX_SPEED=$(( (TX2 - TX1) / 1024 ))  # Speed in KB

    # Format output
    echo "{\"text\": \"↓ $RX_SPEED KB/s  ↑ $TX_SPEED KB/s\", \"class\": \"network-speed\"}"

    sleep 1
done

