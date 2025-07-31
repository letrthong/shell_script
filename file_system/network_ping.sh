#!/bin/bash
#
# File: network_ping.sh
# Description:
#   This script pings a destination IP using a specified network interface.
#   If the ping fails, it checks the link status of the interface using ethtool.
#
# Usage:
#   chmod +x network_ping.sh
#   ./network_ping.sh <interface> <destination IP>
#
# Example:
#   ./network_ping.sh eth0 192.168.30.2

# Read arguments from command line
iface="$1"              # Network interface (e.g., eth0)
des="$2"                # Destination IP address

# Validate required arguments
if [ -z "$iface" ] || [ -z "$des" ]; then
    echo "Usage: $0 <interface> <destination IP>"
    echo "Available interfaces:"
    ifconfig | grep '^[a-zA-Z0-9]' | awk '{print $1}'
    exit 1
fi

# Check if the specified interface exists
if ! ifconfig "$iface" >/dev/null 2>&1; then
    echo "Error: Interface '$iface' does not exist."
    echo "Available interfaces:"
    ifconfig | grep '^[a-zA-Z0-9]' | awk '{print $1}'
    exit 1
fi

# Check if ethtool is installed
if ! command -v ethtool >/dev/null 2>&1; then
    echo "Error: 'ethtool' is not installed. Please install it to check link status."
    exit 1
fi

# Perform ping test
echo "Pinging from interface '$iface' to destination '$des'..."
ping -I "$iface" -c 4 "$des" > /tmp/ping_output.txt 2>&1

# Check ping result
if [ $? -eq 0 ]; then
    echo "Ping successful."
else
    echo "Ping failed. Reason:"
    grep -E "ping:|100% packet loss|unknown host|Network is unreachable|Name or service not known" /tmp/ping_output.txt

    # Check link status using ethtool
    if ethtool "$iface" | grep -q "Link detected: yes"; then
         # The network cable is plugged in and there is a physical link signal
        echo "Link status: '$iface' is UP."
    else
        # The network cable is unplugged or damaged, or the switch or the device on the other end is powered off
        echo "Link status: '$iface' is DOWN."
    fi
fi

# Clean up temporary file
rm -f /tmp/ping_output.txt
