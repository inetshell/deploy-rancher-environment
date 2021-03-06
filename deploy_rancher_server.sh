#!/usr/bin/env bash
# Load configuration
source "include/config.sh"
source "include/functions.sh"

# Load vars_file
source "${VARS_FILE}"

echo "Generating password for Rancher admin"
gen_rancher_password
export RANCHER_PASS=$(cat ${RANCHER_PASS_FILE})

new_section
echo "Execute Ansible playbooks for Rancher-Server"
run_ansible "rancher-server" "ansible/tasks/all/*.yml"
run_ansible "rancher-server" "ansible/tasks/docker/*.yml"
run_ansible "rancher-server" "ansible/tasks/rancher-server/*.yml"

new_section
echo -e "\e[32mFINISHED!\e[0m"
echo "You can access Rancher server using the following credentials"
echo "URL: https://${RANCHER_DNS}"
echo "Username: admin"
echo "Password: ${RANCHER_PASS}"

new_section
echo "To add a host into the Rancher environment, execute the following command in every rancher agent node:"
echo "$(cat ${RANCHER_CMD_FILE})"
