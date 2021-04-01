echo "==> Clear up yum"
yum clean all

echo "==> Clear out machine id"
rm -f /etc/machine-id
touch /etc/machine-id

echo "==> Removing temporary files used to build box"
rm -rf /tmp/*