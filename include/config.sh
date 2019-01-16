#!/usr/bin/env bash
export SCRIPT_HOME="$( cd "$(dirname "${0}")" ; pwd -P )"
export VARS_FILE="${SCRIPT_HOME}/vars/load_vars.sh"
export INVENTORY_FILE="${SCRIPT_HOME}/vars/hosts"
export SSH_KEY_PATH="${SCRIPT_HOME}/secrets/ssh"
export SSH_KEY_FILE="${SSH_KEY_PATH}/rancher_ssh_key"
export RANCHER_USER="admin"
export RANCHER_PASS_FILE="${SCRIPT_HOME}/secrets/rancher/password"
export RANCHER_CMD_FILE="${SCRIPT_HOME}/secrets/rancher/command"