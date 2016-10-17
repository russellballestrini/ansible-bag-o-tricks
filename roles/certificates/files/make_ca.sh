#!/bin/bash
#
# Make a Certificate Authority for vpc_name.local

if [ "$#" -ne "2" ];
  then
    echo "$0 <vpc_name> <path_to_create_files>"
    exit 1
fi

vpc_name=$1
file_root=$2

echo "# 0 Set up directory structure"

mkdir -m 0700 $file_root

mkdir -m 0700 $file_root/CA

mkdir -m 0700 $file_root/CA/certs \
$file_root/CA/crl \
$file_root/CA/newcerts \
$file_root/CA/private \
$file_root/CA/requests

touch $file_root/CA/index.txt
echo '1000' > $file_root/CA/serial

echo "# 1 Variables"

domain="$vpc_name.local"

ca_key=$file_root/CA/private/$domain.ca.key
ca_crt=$file_root/CA/certs/$domain.ca.crt

echo "# 2 Generate CA Key"

openssl genrsa -out $ca_key 2048

echo "# 3 Generate CA Certificate"

# TODO: move the subj C, ST, L, O to vars.
openssl req -new -x509 -extensions v3_ca -key $ca_key -out $ca_crt -days 3650 \
 -subj "/C=US/ST=Florida/L=Gainesville/O=Managed Hosting/OU=$vpc_name/CN=VPC Internal CA $vpc_name"

echo "# 4 Successfully create CA for $domain"

exit 0
