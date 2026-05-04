#!/bin/bash

KEY_PUB="/home/natnaelae/.ssh/id_ed25519.pub"

declare -A NODES
NODES[192.168.122.10]="master"
NODES[192.168.122.11]="w1"
NODES[192.168.122.12]="w2"

for ip in "${!NODES[@]}"; do
    user=${NODES[$ip]}
    echo -e "\n→ Setting up $user@$ip"

    ssh-copy-id -i "$KEY_PUB" -o StrictHostKeyChecking=no "$user@$ip" || \
    ssh -o StrictHostKeyChecking=no "$user@$ip" "
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
        cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
    " < "$KEY_PUB"

    ssh -o StrictHostKeyChecking=no "$user@$ip" "
        echo '$user ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible > /dev/null
        sudo chmod 0440 /etc/sudoers.d/ansible
    "
done

echo -e "\n=== SSH + Sudo Setup Completed ===\n"
