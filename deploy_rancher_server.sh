#!/bin/bash
VARS_FILE="vars/load_vars.sh"
INVENTORY_FILE="vars/hosts"

# Load vars_file
source "${VARS_FILE}"

ansible-playbook -i "${INVENTORY_FILE}" ansible/tasks/all/*.yml
ansible-playbook -i "${INVENTORY_FILE}" ansible/tasks/docker/*.yml
ansible-playbook -i "${INVENTORY_FILE}" ansible/tasks/rancher-server/*.yml
