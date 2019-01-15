#!/usr/bin/env bash
echo -e "\e[33mWARNING! The environment info will be terminated!\e[0m"
echo "Press [ENTER] to continue..."
echo "Press [Ctrl+C] to cancel..."
read
echo "The files will be deleted in 15 seconds!"
echo "Press [Ctrl+C] to cancel..."
sleep 15
rm -vf vars/hosts
rm -vf vars/load_vars.sh
rm -vf secrets/rancher/password
rm -vf secrets/rancher/command
rm -vf secrets/ssh/id_ecdsa
rm -vf secrets/ssh/id_ecdsa.pub
rm -vf secrets/ssh/public_keys
echo "Press [Ctrl+C] to cancel..."