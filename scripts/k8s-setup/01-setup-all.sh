#! /bin/bash

echo "Set variables"
read -r -p "Enter Hostname: " HOSTNAME
read -r -p "Enter static IP address (e. g. 192.168.1.10): " STATIC_IP
read -r -p "Enter Gateway address (e. g. 192.168.1.1): " GATEWAY4

read -r -p "Enter Admin Username: " ADMIN_USR
read -s -r -p "Enter Admin users password: " ADMIN_USR_PASSWD

echo "Set hostname"
hostnamectl set-hostname "${HOSTNAME}"

echo "Create user and add user to sudoers group"
useradd "${ADMIN_USR}" -m -s /bin/bash
usermod -aG sudo "${ADMIN_USR}"

echo "Setting the password for the new user"
echo "${ADMIN_USR}:${ADMIN_USR_PASSWD}" | chpasswd

echo "Setting static IP address"
rm /etc/netplan/*

echo "Enable cgroups"
sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt

echo "# setting static IP address
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            addresses: [${STATIC_IP}/24]
            gateway4: ${GATEWAY4}
            nameservers:
                addresses: [${GATEWAY4}, 8.8.8.8]
    version: 2" | tee /etc/netplan/00-static.yaml

echo "The new network settings will be applied.
Your SSH connection will break.
You need to reconnect with the following information:
ssh ${ADMIN_USR}@${STATIC_IP}
PWD: ${ADMIN_USR_PASSWD}
Hostname is: ${HOSTNAME}"
netplan apply

reboot