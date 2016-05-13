## This script is courtesy of the Linux from Scratch book!

SLDIR=/etc/ssl
# Set the URL to get the certificate data from.
URL=http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt

# If 
if [ $(id -u) != 0 ]; then
  echo "Please run script as root user!"
  exit 1
fi

# Remove previous certificate data.
rm -f certdata.txt
# Get the data.
wget $URL
make-ca.sh
remove-expired-certs.sh certs
install -d ${SSLDIR}/certs 
cp -v certs/*.pem ${SSLDIR}/certs
c_rehash
install BLFS-ca-bundle*.crt ${SSLDIR}/ca-bundle.crt
ln -sfv ../ca-bundle.crt ${SSLDIR}/certs/ca-certificates.crt
rm -r certs BLFS-ca-bundle*
