iptables -A FORWARD -i vmbr1 -o vmbr0 -j ACCEPT
iptables -A FORWARD -i  vmbr0 -o vmbr1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -o vmbr0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o vmbr1 -j MASQUERADE
apt install -y iptables-persistent

# Quitar acceso "publico" a ProxRouter
iptables -A INPUT -i vmbr1 -p tcp --dport 8006 -j ACCEPT
iptables -A INPUT -i vmbr1 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i vmbr0 -p tcp --dport 8006 -j DROP
iptables -A INPUT -i vmbr0 -p tcp --dport 22 -j DROP
sh -c "iptables-save > /etc/iptables/rules.v4"


##Redirigir el puerto 22 del WAN (vmbr0) al puerto 22 del LAN (vmbr1) para la IP 10.10.10.x:
iptables -t nat -A PREROUTING -i vmbr0 -p tcp --dport 22 -j DNAT --to-destination 10.10.10.x:22
iptables -A FORWARD -p tcp -d 10.10.10.x --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

##Redirigir el rango de puertos 8080-8084 del WAN (vmbr0) al mismo rango de puertos del LAN (vmbr1) para la IP 10.10.10.x:
iptables -t nat -A PREROUTING -i vmbr0 -p tcp --dport 8080:8084 -j DNAT --to-destination 10.10.10.x
iptables -A FORWARD -p tcp -d 10.10.10.x --dport 8080:8084 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

##Después de agregar estas reglas, no olvides guardarlas para que persistan tras un reinicio:
sh -c "iptables-save > /etc/iptables/rules.v4"


#Revertir el mapeo de puertos
iptables -t nat -D PREROUTING -i vmbr0 -p tcp --dport 22 -j DNAT --to-destination 10.10.10.x:22
iptables -D FORWARD -p tcp -d 10.10.10.x --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
