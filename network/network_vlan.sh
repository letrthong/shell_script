#!/bin/bash
#
# fileName: network_vlan.sh
# Description:
#   This script allows you to create a VLAN interface on a specified network interface,
#   assign it an IP address, and later restore the original IP configuration.
#
# Usage:
#   Make the script executable:
#     chmod +x network_vlan.sh
#
#   Create VLAN 30 on eth0 with IP 192.168.30.2:
#     ./network_vlan.sh eth0 create 30 192.168.30.2
#
#   Delete VLAN 30 and restore original IP:
#     ./network_vlan.sh eth0 delete 30
#   Tool
#    sudo ethtool  eth0.30 
#

# Read arguments from command line
iface="$1"              # Network interface (e.g., eth0)
cli="$2"                # Command: create or delete
vlan_id="$3"            # VLAN ID (e.g., 30)
vlan_ip_addr="$4"       # VLAN IP address (e.g., 192.168.30.2)

# Validate required arguments
if [ -z "$iface" ] || [ -z "$cli" ]; then
    echo "Usage: $0 <interface> <command: create|delete> <vlan_id> <vlan_ip_addr>"
    ifconfig
    exit 1
fi

# Construct VLAN interface name (e.g., eth0.30)
inface_vlan=${iface}.${vlan_id}

# Get the current date for backup file naming
current_date=$(date +"%Y-%m-%d")

# Define backup file names for IP and netmask
file_name_ip4="${current_date}_${iface}_ipv4.txt"
file_name_netmask="${current_date}_${iface}_netmask.txt"

# Check if the base interface exists
if ifconfig "$iface" >/dev/null 2>&1; then
    echo "Interface $iface exists."
else
    echo "Interface $iface does not exist."
    ifconfig
    exit 1
fi

# Backup current IP and netmask if not already backed up
if [ -f "$file_name_ip4" ]; then
    echo "Backup file '$file_name_ip4' already exists."
else
    echo "Creating backup of current IP and netmask..."
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

# Create VLAN interface and assign IP
if [ "$cli" = "create" ]; then
    echo "Create command received."
    ip_addr=$(ifconfig "$iface" | grep 'inet ' | awk '{print $2}')
    if [ -z "$ip_addr" ]; then
        echo "No IPv4 address assigned to $iface."
    else
        echo "Creating VLAN interface $inface_vlan with IP $vlan_ip_addr..."
        sudo ip link add link "$iface" name "$inface_vlan" type vlan id "$vlan_id"
        sudo ip link set "$inface_vlan" up
        sudo ip addr add "${vlan_ip_addr}/24" dev "$inface_vlan"
        echo "VLAN $inface_vlan created and configured with IP $vlan_ip_addr."
    fi
fi

# Delete VLAN interface and restore original IP
if [ "$cli" = "delete" ]; then
    echo "Delete command received."

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
    sudo ip link delete "$inface_vlan"
    echo "Restoration complete."
else
    echo "No restore action taken."
fi
