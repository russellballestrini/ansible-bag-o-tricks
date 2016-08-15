Russell's ansible bag-o-tricks
##################################

.. contents:: 

genisis
==============

1. build VPC infra using botoform::

     bf -p dev -r us-east-1 create -e 'vpc_cidr=192.168.1.0/24' webdev01 dev.yaml

     # setup the hosts inventory file. You should copy this host file to the bastion.
     bf -p dev -r us-east-1 dump webdev01 ansible_hosts > webdev01

2. using the VPC specific "master" ssh key - 

   2a. configure bastion - setup ansible / ansible-secrets / playbooks::

       # add the new key to your ssh agent.
       ssh-add webdev01-default-20160801-1112.pem
       # forward agent with -A flag when connecting to bastion.
       ssh -A centos@52.77.84.171

       sudo yum install git
       git clone https://github.com/russellballestrini/ansible-bag-o-tricks.git
       cd ansible-bag-o-tricks
       ./install-ansible-on-centos-6.sh

       # setup the vars you need.
       mkdir ~/ansible-secrets
       mkdir ~/asible-secrets/vars

   2b. run nat.yml playbook to configure NAT hosts::

       ansible-playbook -i ~/ansible-secrets/hosts -v nat.yml

   2c. run base.yml playbook to configure hostname / jumpcloud on all hosts::

       ansible-playbook -i ~/ansible-secrets/hosts -v base.yml

3. configure all the other vpc env specific services via playbooks and using jumpcloud user / keys.

jumpcloud
=============

~/ansible-secrets/vars/jumpcloud.yml::

 # the api key to connect to jumpcloud - needed to install and register instances.
 jumpcloud_x_connect_key: the-key-to-connect-to-jumpcloud

 # used for adding new system to tags.
 jumpcloud_api_key: the-admin-api-key-to-talk-to-api-for-tagging

 # jump cloud tags to add to the systems in this environment.
 jumpcloud_system_tags:
   - ops-people
   - webapp-stage
 
jenkins-master with self signed tls
===================================

~/ansible-secrets/vars/jenkins-master.yml::

 # details about these secret vars may be found here:
 #   https://github.com/geerlingguy/ansible-role-jenkins
 
 jenkins_hostname: localhost
 
 jenkins_http_port: 8080
 
 jenkins_admin_username: admin
 jenkins_admin_password: changeme
 jenkins_jar_location: /opt/jenkins-cli.jar
 jenkins_plugins: []
 jenkins_url_prefix: ""
 jenkins_connection_delay: 5
 jenkins_connection_retries: 60
 
 # For RedHat/CentOS (role default):
 jenkins_repo_url: http://pkg.jenkins-ci.org/redhat/jenkins.repo
 jenkins_repo_key_url: http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

 jenkins_plugins: 
   - git
   - ssh-agent
 
 # TLS settings.
 # keytool -genkey -keyalg RSA -alias selfsigned -keystore ~/ansible-secrets/files/jenkins-keystore.jks -storepass example-password -dname "cn=localhost" -validity 3650
 jenkins_tls_keystore_src: ~/ansible-secrets/files/jenkins-keystore.jks
 jenkins_tls_keystore_dst: /opt/jenkins-keystore.jks
 
 # configure Jenkins to use https only and pass arguments for keystore.
 jenkins_init_changes:
   - option: "JENKINS_ARGS"
     value: "--httpsPort=4443 --httpsKeyStore=/opt/jenkins-keystore.jks --httpsKeyStorePassword=example-password"
 
 #  - option: "JENKINS_JAVA_OPTIONS"
 #    value: "{{ jenkins_java_options }}"


