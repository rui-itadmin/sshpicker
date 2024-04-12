#!/bin/bash 
# 2024-04-07 rui
# read the host/ip list from hosts.conf or give file and make an ssh connection


set -euo pipefail

separator=";"
remote_user=rui

help() {

 echo -e "usage: 
 ---
 This program reads hosts.conf as the list of connection hosts, selects a host code number, and then establishes an SSH connection. 
 The host list can also be read from parameter 1. For example, $0 foobar."

}


ssh2host() {

if [[ -z "$1" ]]; then 
# If the host information does not exist, an error will be reported, and the script will exit with status code 2.
  echo  -e '\nneed $1 for ssh2host' 
  exit 2
fi

remote_host="$1"

echo -e "\nss2host> remote host: ${remote_host}\n"

ssh ${remote_user}@${remote_host}
# ssh -o StrictHostKeyChecking=no ${remote_user}@${remote_host}
# ssh -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p ${bastion_user}@${bastion_host}" ${remote_user}@${remote_host}

}


###### main

[[ "$#" > 0 ]] && hostsini=$1 || hostsini="hosts.conf"
# If there is no parameter 1, the host settings will be read from hosts.conf.

if [[ ! -f "${hostsini}" ]]; then
# If the file does not exist, an error will be reported, and the script will exit with status code 1.
 echo -e "error: ${hostsini} not exist\n-----\n"
 help
 exit 1
fi


host_list=$(cat $hostsini | grep -Ev '^#' |awk -F"#" '{print $1}'  | awk -F"$separator" '{ print $1}' | tr -d ' '  | xargs | sort)
# After excluding comments,space and blank lines, extract field 1 as the hostname, and store it in a list.
ip_list=$(cat $hostsini | grep -Ev '^#' |awk -F"#" '{print $1}'  | awk -F"$separator" '{ if($2!="") {print $2} else {print $1}}' | tr -d ' '  | xargs | sort)
# After excluding comments,space and blank lines, extract field 2 as the ip, and store it in a list. 
# If field 2 does not exist, then field 1 will be used.


echo "Please enter the number preceding the host list."
select host in ${host_list}
do
    echo -e "\nSelected host: ${host}"
    echo "Selected number: ${REPLY}"
    remote_host=$(echo ${ip_list} | cut -d' ' -f${REPLY})

    ssh2host ${remote_host}
    exit 0
done




