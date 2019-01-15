#!/usr/bin/env bash
# Load configuration
source "include/config.sh"
source "include/functions.sh"


install_requirements

if [[ -f "${VARS_FILE}" ]]; then
    echo "Vars file found in ${VARS_FILE}"
    source ${VARS_FILE}
else
    echo "Vars file is missing"
    define_vars
    write_vars_file
fi

if [[ -f "${INVENTORY_FILE}" ]]; then
    echo "Ansible inventory file found in ${INVENTORY_FILE}"
else
    echo "No Ansible inventory file found"
    write_inventory_file
fi

if [[ -f "${SSH_KEY_FILE}" ]]; then
    echo "SSH key found in ${SSH_KEY_FILE}"
else
    echo "No SSH key found"
    gen_ssh_keys
fi

gather_ssh_keys_for_ansible

echo  "\n\nPlease add the following SSH-KEY to the instances:"
echo -e "\e[32m$(cat ${SSH_KEY_FILE}.pub)\e[0m"