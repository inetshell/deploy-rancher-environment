#!/usr/bin/env bash
# Load configuration
source "include/config.sh"
source "include/functions.sh"

# Load vars_file
source "${VARS_FILE}"

new_section
echo "Execute Ansible playbooks for Rancher-Nodes"
run_ansible "rancher-nodes" "ansible/tasks/all/*.yml"
run_ansible "rancher-nodes" "ansible/tasks/docker/*.yml"
run_ansible "rancher-nodes" "ansible/tasks/rancher-node/*.yml"

new_section
echo -e "\e[32mFINISHED!\e[0m"
