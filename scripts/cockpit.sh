yum install cockpit -y
systemctl enable --now cockpit.socket
systemctl start cockpit