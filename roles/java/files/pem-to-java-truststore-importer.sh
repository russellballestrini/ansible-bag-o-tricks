#!/bin/sh -e

# Purpose: this script accepts a path to a bundled pem file with multiple
#          certificates and imports them each individually into the default
#          Java truststore (cacerts). This script was originally written to
#          import a pem from AWS which had over 10 certs in it for RDS.
#

# Ref: http://blog.swwomm.com/2015/02/importing-new-rds-ca-certificate-into.html

# the bundled up pem that needs to be imported.
BUNDLE="$1"

# location of the truststore to import into.
TRUSTSTORE="/usr/lib/jvm/jre/lib/security/cacerts"

# directory to work out of.
TMP_DIR="/tmp/pem-to-java-truststore-importer"

# create a temp dir and change dir.
OLD_DIR="$PWD"

if [ ! -f "$BUNDLE" ]
  then
    echo "Usage: $0 /path/to/bundle.pem"
    exit 1
fi

mkdir "$TMP_DIR" && cd "$TMP_DIR"

# split the bundle into individual certs (prefixed with xx)
csplit -sz "$BUNDLE" '/-BEGIN CERTIFICATE-/' '{*}'

# import each cert individually
for CERT in xx*; do

    # extract a human-readable alias from the cert
    ALIAS=$(openssl x509 -noout -text -in $CERT |
        perl -ne 'next unless /Subject:/; s/.*CN=//; print')

    echo "deleting $ALIAS if it exsits"
    sudo keytool -delete \
        -keystore $TRUSTSTORE \
        -storepass changeit -noprompt \
        -alias "$ALIAS" || echo "alias not found"

    # import the cert into the default java keystore
    echo "importing $ALIAS"
    sudo keytool -import \
        -keystore $TRUSTSTORE \
        -storepass changeit -noprompt \
        -alias "$ALIAS" -file $CERT
done

# back out of the temp dir and delete it
cd "$OLD_DIR"
rm -r "$TMP_DIR"
