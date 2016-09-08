#!/bin/bash -v
oldHostname="( hostname )"
oldNodename="${oldHostname%%.*}"
newHostname="$1"
newNodename="${newHostname%%.*}"

[[ -z "$newHostname" ]] && exit 1
[[ "$oldHostname" = "$newHostname" ]] && exit 0

# set it in kernel memory.
hostname "$newHostname"

# set it on filesystem.
echo "$newHostname" > /etc/hostname

# set it in this area just incase its being used to overide /etc/hostname/
net_cfg="/etc/sysconfig/network"
net_tmp="/etc/sysconfig/network.tmp"
grep -v "HOSTNAME=" $net_cfg > $net_tmp && mv $net_tmp $net_cfg
echo "HOSTNAME=$newHostname" >> $net_cfg

# Clean up /etc/hosts
hostIP="$(ip route get 8.8.8.8 | head -n1)"
hostIP="${hostIP%% }"
hostIP="${hostIP## }"
hostIP="${hostIP##* }"

sed -i "/$oldHostname/d" /etc/hosts
sed -i "/$hostIP/d" /etc/hosts

sed -i "1s/^/$hostIP $newHostname $newNodename\n/" /etc/hosts

# reload network, maybe not needed, going to remove.
service network reload
exit 0
