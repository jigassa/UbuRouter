# --== REFERENCIA ==--
# https://kifarunix.com/configure-ubuntu-20-04-as-linux-router/


sudo sed -i '/net.ipv4.ip_forward/s/^#//' /etc/sysctl.conf
sudp sysctl -p
sudo sysctl net.ipv4.ip_forward
sudo iptables -A FORWARD -i enp2s0 -o enp1s0 -j ACCEPT
sudo iptables -A FORWARD -i eno1 -o enp1s0 -j ACCEPT
sudo iptables -A FORWARD -i enp7s0 -o enp1s0 -j ACCEPT
sudo iptables -A FORWARD -i enp8s0 -o enp1s0 -j ACCEPT
sudo iptables -A FORWARD -i enp9s0 -o enp1s0 -j ACCEPT 
sudo iptables -A FORWARD -i  enp1s0 -o enp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i  enp1s0 -o eno1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i  enp1s0 -o enp7s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i  enp1s0 -o enp8s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i  enp1s0 -o enp9s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o enp1s0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o enp7s0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o enp8s0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o enp9s0 -j MASQUERADE
sudo apt install -y iptables-persistent
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
