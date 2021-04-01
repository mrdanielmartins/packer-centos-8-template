# Install NCPA

rpm -Uvh https://repo.nagios.com/nagios/8/nagios-repo-8-1.el8.noarch.rpm
yum install ncpa -y

# Set Token
function replaceToken() {
  cd /usr/local/ncpa/etc/
  sed -i 's/mytoken/notMyToken123/g' ncpa.cfg
  /etc/init.d/ncpa_listener restart
}

replaceToken