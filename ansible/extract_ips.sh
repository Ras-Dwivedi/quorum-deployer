#!/bin/bash

# Path to the Ansible inventory file
inventory_file="inventory.ini"  # Replace with the actual path to your inventory file

# Extract IP addresses using grep
ip_addresses=$(grep -Eo 'ansible_host=[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' $inventory_file | cut -d= -f2)

# Print the IP addresses
echo "IP Addresses:"
echo "$ip_addresses"
cd ../QBFT-Network/artifacts/goQuorum/
# Path to the static-nodes.json file
json_file="static-nodes.json"  # Replace with the actual path to your JSON file

# Loop through each IP address and replace <HOST> in the i+2th line
i=1
for ip_address in $ip_addresses; do
    sed -i "$((i+1)) s/<HOST>/$ip_address/" $json_file
    ((i++))
done

# Print the modified JSON file
cat $json_file
