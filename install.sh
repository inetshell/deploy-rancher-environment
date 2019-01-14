#!/bin/bash
VARS_FILE="vars/load_vars.sh"
INVENTORY_FILE="vars/hosts"
SSH_KEY_PATH="secrets/ssh"
SSH_KEY_FILE="${SSH_KEY_PATH}/id_ecdsa"


function error() {
    ERROR="${1}"
    echo -e "\e[31m${ERROR}\e[0m"
    exit 1
}

function install_requirements() {
    yum install -y epel-release || error "Error while trying to install EPEL Repository."
    yum install -y python python-pip || error "Error while trying to install Python."
    pip install -r requirements.txt || error "Error while trying to install Python requirements."
}

function define_vars() {
    echo "Please define the environment variables:"

    echo -n -e "\e[32mCERTBOT_EMAIL\e[0m="; read CERTBOT_EMAIL
    if [[ -z ${CERTBOT_EMAIL} ]]; then
        error "Error while reading variables"
    fi

    echo -n -e "\e[32mCTIMEZONE\e[0m="; read TIMEZONE
    if [[ -z ${TIMEZONE} ]]; then
        error "Error while reading variables"
    fi

    echo -n -e "\e[32mRANCHER_DNS\e[0m="; read RANCHER_DNS
    if [[ -z ${RANCHER_DNS} ]]; then
        error "Error while reading variables"
    fi

    echo -n -e "\e[32mRANCHER_VERSION\e[0m="; read RANCHER_VERSION
    if [[ -z ${RANCHER_VERSION} ]]; then
        error "Error while reading variables"
    fi
}

function write_vars_file() {
cat > "${VARS_FILE}" <<-EOM
#!/bin/sh
export CERTBOT_EMAIL="${CERTBOT_EMAIL}"
export TIMEZONE="${TIMEZONE}"
export RANCHER_DNS="${RANCHER_DNS}"
export RANCHER_VERSION="${RANCHER_VERSION}"
EOM
}

function write_inventory_file() {
echo "Generating Ansible inventory file in ${INVENTORY_FILE}"
cat > "${INVENTORY_FILE}" <<-EOM
[all:vars]
ansible_ssh_private_key_file=${SSH_KEY_FILE}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[docker]
rancher-server
rancher-nodes

[rancher-server]
${RANCHER_DNS}

[rancher-nodes]
EOM
}

function gen_ssh_keys() {
    echo "Generating SSH key in ${SSH_KEY_FILE}"
    mkdir -p "${SSH_KEY_PATH}"
    COMMENT="${RANCHER_DNS} $(date +"%F %T")"
    ssh-keygen -q -N '' -C "${COMMENT}" -t ecdsa -f "${SSH_KEY_FILE}"
    echo -e "\e[36mPlease add the following SSH-KEY to the instances:\e[0m"
    echo -e "\e[32m$(cat ${SSH_KEY_FILE}.pub)\e[0m"

}

function gather_ssh_keys_for_ansible() {
    echo "Gathering SSH keys for ansible in ${SSH_KEY_PATH}/public_keys"
    cat ${SSH_KEY_PATH}/*.pub > "${SSH_KEY_PATH}/public_keys"
}

function main() {
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
}

main