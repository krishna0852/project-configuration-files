#!/bin/bash

getid=$(id -u)

if [ $getid -ne 0 ]; then 
echo "please run the script with root priveleages"
exit 1
fi 

getdate=$(date +%F)

logfile="Ansible-installaion-on-$getdate.log"

touch $logfile

awscli="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"



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

echo "Ansible installed.."

echo "Installing  pip3.."

# Set debconf frontend to noninteractive to suppress prompts
# it's aksing to restart services while installing python3-module, below export will do it in non-interactive mode
export DEBIAN_FRONTEND=noninteractive

apt-get install python3-pip -y  >> $logfile

validateCmndStatus $? "installing python3-pip"

echo "Installing boto3"

pip3 install boto3

validateCmndStatus $? "installing boto3"

apt-get update -y >> $logfile

validateCmndStatus $? "updating packages before installing aws-cli "

echo "installing unzip"

apt-get install unzip -y  >> $logfile

validateCmndStatus $? "installing unzip is "

echo "installing aws cli"

curl $awscli -o "awscliv2.zip"  >> $logfile

validateCmndStatus $? "importing aws cli file using curl"
#-o to -over-write
unzip -o awscliv2.zip >> $logfile

validateCmndStatus $? "unzipping awscli is" 

echo "install in the newly unzipped aws directory. By default, the files are all installed to /usr/local/aws-cli, and a symbolic link is created in /usr/local/bin"
 
 #--update 
 ./aws/install --update >> $logfile

validateCmndStatus $? "creating symbolic link is "

echo "awscli-installed, checking aws cli version"

aws_cli_version=$(aws --version) 


echo "executing python script to get private ips "

python3 getprivateips.py

exit 0
