#!/bin/bash

declare -A NODES
NODES[192.168.122.10]="master"
NODES[192.168.122.11]="w1"
NODES[192.168.122.12]="w2"

for ip in "${!NODES[@]}"; do
    user=${NODES[$ip]}
    echo "→ Fixing sudo for $user@$ip"
    
    ssh -o StrictHostKeyChecking=no $user@$ip "
        echo '$user ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible
        sudo chmod 0440 /etc/sudoers.d/ansible
    " 2>/dev/null && echo "   ✓ Sudo fixed for $ip" || echo "   ✗ Failed for $ip"
done

echo -e "\n=== Sudo Fix Attempt Completed ===\n"
