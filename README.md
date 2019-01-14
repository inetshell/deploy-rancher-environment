# Infrastructure of net-tools

Ansible playbooks used to configure the net-tools infrastructure.

* db01:
  - openvpn-server
  - nfs-ganesha
  - mysql
  
* master01:
  - rancher-server
  - rancher-node
  - sites
  - mailserver
  - jenkins
  - zabbix
  