#! /bin/bash
sudo yum -y install gcc python-devel libffi-devel openssl-devel
sudo easy_install pip
sudo pip install --upgrade pip
sudo pip install ansible
sudo pip install Jinja2==2.2
sudo pip install paramiko==1.10
which ansible
ansible --version
