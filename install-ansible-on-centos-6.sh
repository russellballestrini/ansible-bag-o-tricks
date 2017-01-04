#! /bin/bash
sudo yum -y install gcc python-devel libffi-devel openssl-devel
sudo easy_install pip
sudo pip install --upgrade pip
sudo pip install ansible
sudo pip install Jinja2==2.2
sudo pip install paramiko==1.10

which ansible
ansible --version

echo "Creating the '~/ansible-secrets' directories."

mkdir ~/ansible-secrets
mkdir ~/ansible-secrets/vars
mkdir ~/ansible-secrets/hosts
mkdir ~/ansible-secrets/keys
mkdir ~/ansible-secrets/files
mkdir ~/ansible-secrets/files/tls
mkdir ~/ansible-secrets/files/tls/certs
mkdir ~/ansible-secrets/files/tls/private

touch ~/ansible-secrets/vars/common.yml
