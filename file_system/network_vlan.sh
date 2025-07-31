#!/bin/bash
#
# fileName: network_vlan.sh
# You can run it like this:
# chmod +x network_vlan.sh
#
# 
#** Create VLAN 30 on eth0 with IP 192.168.30.2
#  ./network_vlan.sh eth0 create  30 192.168.30.2
#
# 
#** Delete VLAN 30 and restore original IP
#  ./network_vlan.sh eth0 restore
# 

# Read arguments from command line
iface="$1"              # e.g., eth0 (Define the network interface)
cli="$2"                # e.g., create or restore (cli)
vlan_id="$3"            # e.g., 30
vlan_ip_addr="$4"       # e.g., 192.168.30.2

# Check if both arguments are provided
if [ -z "$iface" ] || [ -z "$cli" ]; then
    echo "Usage: $0 <interface> <command: create|delete> <vlan_id> <vlan_ip_addr>"
    ifconfig
    exit 1
fi

inface_vlan=${1}.${3}

# Get the current date in YYYY-MM-DD format
current_date=$(date +"%Y-%m-%d")

# Store IPv4 and netmask to backup
file_name_ip4="${current_date}_${iface}_ipv4.txt"
file_name_netmask="${current_date}_${iface}_netmask.txt"

# Check if the interface exists
if ifconfig "$iface" >/dev/null 2>&1; then
    echo "Interface $iface exists."
else
    echo "Interface $iface does not exist."
    ifconfig
    exit 1
fi

# Backup IP and netmask if not already backed up
if [ -f "$file_name_ip4" ]; then
    echo "File '$file_name_ip4' exists."
else
    echo "File '$file_name_ip4' does not exist."
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

# Create VLAN if cli = create
if [ "$cli" = "create" ]; then
    echo "create command received"
    ip_addr=$(ifconfig "$iface" | grep 'inet ' | awk '{print $2}')
    if [ -z "$ip_addr" ]; then
        echo "No IPv4 address assigned to $iface."
    else
        echo "Creating VLAN interface $inface_vlan with IP $vlan_ip_addr..."
        # Create VLAN interface
        sudo ip link add link "$iface"  name "$inface_vlan" type vlan id $vlan_id
        #  Bring VLAN interface up
        sudo ip link set "$inface_vlan"  up
        # Assign IP address to VLAN interface
        sudo ip addr add ${vlan_ip_addr}/24 dev "$inface_vlan"
        echo "VLAN $inface_vlan created and configured with IP $vlan_ip_addr."
    fi
fi

# Delete  IP if cli = delete
# sudo ifconfig eth0 10.0.2.15 netmask 255.255.255.0 up
# sudo ip link delete eth0.30
if [ "$cli" = "delete" ]; then
    echo "Restore command received."

    if [ -f "$file_name_ip4" ]; then
        read -r current_ip < "$file_name_ip4"
        echo "Restoring IP: $current_ip"
    else
        echo "File '$file_name_ip4' not found."
        exit 1
    fi

    if [ -f "$file_name_netmask" ]; then
        read -r current_netmask < "$file_name_netmask"
        echo "Restoring Netmask: $current_netmask"
    else
        echo "File '$file_name_netmask' not found."
        exit 1
    fi

    sudo ifconfig "$iface" "$current_ip" netmask "$current_netmask" up

    sudo ip link delete "$inface_vlan"
    echo "Restoration complete."
else
    echo "No restore action taken."
fi
