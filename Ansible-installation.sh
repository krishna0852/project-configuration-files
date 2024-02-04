#!/bin/bash

getid=$(id -u)

if [ $getid -ne 0 ]; then 
echo "please run the script with root priveleages"
exit 1
fi 

getdate=$(date +%F)

logfile="Ansible-installaion-on-$getdate.log"

touch $logfile



validateCmndStatus(){
    cmndsts=$1
    description=$2
    if [ $cmndsts -ne 0 ]; then
    echo "$description failure"
    exit 1
    else
    echo "$description scucess"
    fi
}
echo "updating packages"

apt-get update -y >> $logfile

validateCmndStatus $? "updating packages is "

apt install software-properties-common -y >> $logfile
validateCmndStatus $? "installing software-properties is "

add-apt-repository --yes --update ppa:ansible/ansible >> $logfile

validateCmndStatus $? "adding repository ppa is "

echo "installing Ansible .."

apt-get install ansible -y  >> $logfile

validateCmndStatus $? "installing ansible is "

echo "checking installed ansible-version"

ansible_versions=$(ansible --version)

validateCmndStatus $? "version $ansible_versions"
exit 0
