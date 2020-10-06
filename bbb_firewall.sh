# Add firewall rules for a BigBlueButton server

sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 16384:32768/udp
sudo ufw enable