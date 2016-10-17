#!/bin/bash
#
# Make a Certificate for vpc_name.local
#

if [ "$#" -ne "2" ];
  then
    echo "$0 <vpc_name> <path_to_create_files>"
    exit 1
fi

vpc_name=$1

file_root=$2

domain="$vpc_name.local"

ca_key=$file_root/CA/private/$domain.ca.key
ca_crt=$file_root/CA/certs/$domain.ca.crt
ca_cfg=$file_root/CA/openssl.cfg

key=$file_root/CA/private/$domain.key
csr=$file_root/CA/requests/$domain.csr
crt=$file_root/CA/certs/$domain.crt

echo "# Generate private key"

openssl genrsa -out $key 2048

echo "# Generate CSR for *.$domain"

openssl req -out $csr -key $key -days 3650 -new \
-subj "/C=US/ST=Florida/L=Gainesville/O=Managed Hosting/OU=$vpc_name/CN=*.$domain"

echo "# Sign CSR"

cd $file_root/CA

openssl ca -config $ca_cfg -batch -keyfile $ca_key -cert $ca_crt -notext -md sha256 -in $csr -out $crt

#echo "———————————————————————————————————————————————"
#echo " Making Diffie Hellman Ephemeral Parameters "
#echo " Takes about 1 minute for 2048 bit output "
#openssl dhparam -out $file_root/dhparam.pem 2048

exit 0
