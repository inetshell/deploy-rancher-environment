#!/usr/bin/env bash
SCRIPT_HOME="$( cd "$(dirname "${0}")" ; pwd -P )"
VARS_FILE="${SCRIPT_HOME}/vars/load_vars.sh"
INVENTORY_FILE="${SCRIPT_HOME}/vars/hosts"
SSH_KEY_PATH="${SCRIPT_HOME}/secrets/ssh"
SSH_KEY_FILE="${SSH_KEY_PATH}/id_ecdsa"
RANCHER_USER="admin"
RANCHER_PASS_FILE="${SCRIPT_HOME}/secrets/rancher/password"
RANCHER_CMD_FILE="${SCRIPT_HOME}/secrets/rancher/command"