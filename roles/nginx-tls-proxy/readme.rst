Nginx TLS proxy
###################

This role expects that the nginx role was also installed first.

If you enable swagger ui then first execute swagger-ui role before this role

This role uses the following vars:

.. code-block:: yaml

 # manage the nginx tls proxy.
 nginx_tls_proxy:
   # the path to the certificate file with bundled intermediate and root certs.
   tls_crt: /etc/pki/tls/certs/example.com.bundled.pem
   # the path to the private key portion of the certificate.
   tls_key: /etc/pki/tls/private/example.com.key.pem
   # the port to proxy to on localhost.
   upstream_port: 5006
   # for example: https://nbpdev1-ui.mobproto.com
   cors_origin: '*'
   # enable or disable swagger ui.
   swagger: False

We assume the *tls_crt* and *tls_key* files exist on the servers running nginx.

You can use the `certificate` role to install the certificates.
