#!/bin/bash -v
oldHostname="( hostname )"
oldNodename="${oldHostname%%.*}"
newHostname="$1"
newNodename="${newHostname%%.*}"

[[ -z "$newHostname" ]] && exit 1
[[ "$oldHostname" = "$newHostname" ]] && exit 0

hostname "$newHostname"
sed -i "s/HOSTNAME=.*/HOSTNAME=$newHostname/g" /etc/sysconfig/network

# Clean up /etc/hosts
hostIP="$(ip route get 8.8.8.8 | head -n1)"
hostIP="${hostIP%% }"
hostIP="${hostIP## }"
hostIP="${hostIP##* }"

sed -i "/$oldHostname/d" /etc/hosts
sed -i "/$hostIP/d" /etc/hosts

sed -i "1s/^/$hostIP $newHostname $newNodename\n/" /etc/hosts

service network reload
exit 0
