#!/bin/bash
#
# File Name: network_del.sh
# Description:
#   This script allows you to delete or restore the IPv4 address of a specified network interface.
#   It backs up the current IP and netmask before deletion and restores them when requested.
#
# Usage:
#   Make the script executable:
#     chmod +x network_del.sh
#
#   To delete the IP address from eth0:
#     ./network_del.sh eth0 del
#
#   To restore the IP address to eth0:
#     ./network_del.sh eth0 restore
#

# Read arguments from command line
iface="$1"       # Network interface name (e.g., eth0)
cli="$2"         # Command: 'del' to delete IP, 'restore' to restore IP

# Validate input arguments
if [ -z "$iface" ] || [ -z "$cli" ]; then
    echo "Usage: $0 <interface> <command: del|restore>"
    ifconfig
    exit 1
fi

# Get the current date in YYYY-MM-DD format for backup file naming
current_date=$(date +"%Y-%m-%d")

# Define backup file names for IP address and netmask
file_name_ip4="${current_date}_${iface}_ipv4.txt"
file_name_netmask="${current_date}_${iface}_netmask.txt"

# Check if the specified interface exists
if ifconfig "$iface" >/dev/null 2>&1; then
    echo "Interface $iface exists."
else
    echo "Interface $iface does not exist."
    ifconfig
    exit 1
fi

# Backup IP and netmask if not already backed up
if [ -f "$file_name_ip4" ]; then
    echo "Backup file '$file_name_ip4' already exists."
else
    echo "Creating backup for interface $iface..."
    ip_addr=$(ifconfig "$iface" | grep 'inet ' | awk '{print $2}')
    netmask=$(ifconfig "$iface" | grep 'inet ' | awk '{print $4}')

    if [ -z "$ip_addr" ]; then
        echo "No IPv4 address assigned to $iface."
    else
        echo "$ip_addr" > "$file_name_ip4"
        echo "$netmask" > "$file_name_netmask"
        echo "Backed up IP: $ip_addr and Netmask: $netmask"
    fi
fi

# Delete IP address if command is 'del'
if [ "$cli" = "del" ]; then
    echo "Delete command received. Removing IP address from $iface..."
    ip_addr=$(ifconfig "$iface" | grep 'inet ' | awk '{print $2}')
    if [ -z "$ip_addr" ]; then
        echo "No IPv4 address assigned to $iface."
    else
        sudo ip addr del "$ip_addr" dev "$iface"
        echo "IP address $ip_addr deleted from $iface."
    fi
fi

# Restore IP address if command is 'restore'
if [ "$cli" = "restore" ]; then
    echo "Restore command received. Restoring IP configuration to $iface..."

    if [ -f "$file_name_ip4" ]; then
        read -r current_ip < "$file_name_ip4"
        echo "Restoring IP: $current_ip"
    else
        echo "Backup file '$file_name_ip4' not found."
        exit 1
    fi

    if [ -f "$file_name_netmask" ]; then
        read -r current_netmask < "$file_name_netmask"
        echo "Restoring Netmask: $current_netmask"
    else
        echo "Backup file '$file_name_netmask' not found."
        exit 1
    fi

    sudo ifconfig "$iface" "$current_ip" netmask "$current_netmask" up
    echo "Restoration complete for $iface."
else
    echo "No restore action taken."
fi
