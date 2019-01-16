#!/usr/bin/env bash
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
    echo "Please define the environment variables, Press ENTER for default:"

    echo -n -e "\e[32mCERTBOT_EMAIL\e[0m[No default]:"; read CERTBOT_EMAIL
    if [[ -z ${CERTBOT_EMAIL} ]]; then
        error "CERTBOT_EMAIL must be defined"
    fi

    echo -n -e "\e[32mRANCHER_DNS\e[0m[No default]:"; read RANCHER_DNS
    if [[ -z ${RANCHER_DNS} ]]; then
        error "RANCHER_DNS must be defined"
    fi

    echo -n -e "\e[32mRANCHER_VERSION\e[0m[stable]:"; read RANCHER_VERSION
    if [[ -z ${RANCHER_VERSION} ]]; then
        RANCHER_VERSION="stable"
    fi

    echo -n -e "\e[32mTIMEZONE\e[0m[UTC]:"; read TIMEZONE
    if [[ -z ${TIMEZONE} ]]; then
        TIMEZONE="UTC"
    fi

    echo -n -e "\e[32mSSH_KEY_TYPE\e[0m[RSA]:"; read SSH_KEY_TYPE
    if [[ -z ${SSH_KEY_TYPE} ]]; then
        SSH_KEY_TYPE="RSA"
    fi
}

function write_vars_file() {
cat > "${VARS_FILE}" <<-EOM
#!/bin/sh
export CERTBOT_EMAIL="${CERTBOT_EMAIL}"
export RANCHER_DNS="${RANCHER_DNS}"
export RANCHER_VERSION="${RANCHER_VERSION}"
export TIMEZONE="${TIMEZONE}"
export SSH_KEY_TYPE="${SSH_KEY_TYPE}"
EOM
}

function write_inventory_file() {
echo "Generating Ansible inventory file in ${INVENTORY_FILE}"
cat > "${INVENTORY_FILE}" <<-EOM
[all:vars]
ansible_ssh_private_key_file=${SSH_KEY_FILE}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[rancher-server]
${RANCHER_DNS}

[rancher-nodes]
EOM
}

function gen_ssh_keys() {
    echo "Generating SSH key in ${SSH_KEY_FILE}"
    mkdir -p "${SSH_KEY_PATH}"
    COMMENT="${RANCHER_DNS} $(date +"%F %T")"
    ssh-keygen -q -N '' -C "${COMMENT}" -t "${SSH_KEY_TYPE}" -f "${SSH_KEY_FILE}"
}

function gather_ssh_keys_for_ansible() {
    echo "Gathering SSH keys for ansible in ${SSH_KEY_PATH}/public_keys"
    cat ${SSH_KEY_PATH}/*.pub > "${SSH_KEY_PATH}/public_keys"
}

function gen_password() {
    LENGTH="${1:-50}"
    strings /dev/urandom | grep -o '[[:alnum:]]' | head -n ${LENGTH} | tr -d '\n'; echo
}

function gen_rancher_password() {
    if [[ -f "${RANCHER_PASS_FILE}" ]]; then
        echo "Rancher admin password found in ${RANCHER_PASS_FILE}"
    else
        echo "Generating Rancher admin password to ${RANCHER_PASS_FILE}"
        gen_password 50 > "${RANCHER_PASS_FILE}"
    fi
}

function new_section() {
    echo -e "\n========================================================"
}

function run_ansible() {
    LIMIT="${1}"
    PLAYBOOK="${2}"
    ansible-playbook -i "${INVENTORY_FILE}" --limit "${LIMIT}" ${PLAYBOOK} || error "Error during ansible execution"
}
