echo "Allowing port 587 in iptables"
echo ""
echo ""
sudo iptables -A OUTPUT -p tcp --sport 587 -j ACCEPT
echo ""
echo ""


echo "Installing postfix , mailx and packages for SASL"
echo ""
sudo yum update && yum -y install postfix mailx cyrus-sasl cyrus-sasl-plain
echo ""
echo ""


echo "Removing old configuration file"
echo ""
sudo rm -f /etc/postfix/main.cf
echo ""
echo ""


echo "Adding needed configuration into config file"
echo ""
sudo echo "relayhost = [smtp.gmail.com]:587" >> /etc/postfix/main.cf
sudo echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
sudo echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
sudo echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
sudo echo "smtp_tls_CAfile = /etc/postfix/cacert.crt" >> /etc/postfix/main.cf
sudo echo "smtp_use_tls = yes" >>/etc/postfix/main.cf
echo ""
echo ""


echo "Adding Email Account and Password into config file"
echo ""
sudo echo "[smtp.gmail.com]:587    you-email@example.com:PASSWORD" >> /etc/postfix/sasl_passwd
echo ""
echo ""


echo "Changing permission of file"
echo ""
sudo chmod 600 /etc/postfix/sasl_passwd
echo ""
echo ""


echo "Making required database file of login infomation"
echo ""
sudo postmap /etc/postfix/sasl_passwd
echo ""
echo ""


echo "Coping certificate content to required certificate file"
echo ""
sudo cat /etc/ssl/certs/ca-bundle.crt | sudo tee -a /etc/postfix/cacert.crt
echo ""
echo ""


echo "Service Restarting"
echo ""
sudo service postfix restart

sudo mkdir /var/log/clamav
