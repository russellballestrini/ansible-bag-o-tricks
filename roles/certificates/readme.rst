certificates
################

this role will automatically build a self signed CA on the host running ansible.

this role can also be used to copy files from:

* ~/ansible-secrets/files/tls/certs
* ~/ansible-secrets/files/tls/private

to all servers:

* /etc/pki/tls/certs/
* /etc/pki/tls/private/
