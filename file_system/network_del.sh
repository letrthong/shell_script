#!/bin/bash
#
# fileName: network_del.sh
# You can run it like this:
# chmod +x network_del.sh
#
#  network_del.sh eth0 del
#  network_del.sh eth0 restore
# 

# Read arguments from command line
iface="$1"       # e.g., eth0 (Define the network interface)
cli="$2"         # e.g., del or restore (cli)

# Check if both arguments are provided
if [ -z "$iface" ] || [ -z "$cli" ]; then
    echo "Usage: $0 <interface> <command: del|restore>"
    ifconfig
    exit 1
fi


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

# Delete IP if cli = del
if [ "$cli" = "del" ]; then
    echo "Delete command received. Performing deletion..."
    ip_addr=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}/\\d+')
    if [ -z "$ip_addr" ]; then
        echo "No IPv4 address assigned to $iface."
    else
        echo "Deleting IP address $ip_addr from $iface..."
        sudo ip addr del "$ip_addr" dev "$iface"
        echo "Done."
    fi
fi

# Restore IP if cli = restore
# sudo ifconfig eth0 10.0.2.15 netmask 255.255.255.0 up
if [ "$cli" = "restore" ]; then
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
    echo "Restoration complete."
else
    echo "No restore action taken."
fi
