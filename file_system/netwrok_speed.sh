


#!/bin/bash

#
#sudo apt install c  
#
#ethtool eth0  -> speed
#iperf3 -s
#iperf3 -c <IP của máy A>
#

# Check if ethtool is installed
if ! command -v ethtool &> /dev/null; then
    echo "ethtool is not installed. Please install it using: sudo apt install ethtool"
    exit 1
fi

# Interface to check (change if not eth0)
INTERFACE="eth0"

# Get speed information
SPEED=$(ethtool $INTERFACE 2>/dev/null | grep "Speed:" | awk '{print $2}')

# Display result
if [ -z "$SPEED" ]; then
    echo "Unable to retrieve speed information for interface $INTERFACE."
else
    echo "Ethernet port speed for $INTERFACE: $SPEED"
fi
