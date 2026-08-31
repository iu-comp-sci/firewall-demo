#!/bin/sh

set -eu

iptables -F
iptables -t nat -F
iptables -P FORWARD DROP
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# DNAT attacker traffic to the actual web server in the DMZ.
iptables -t nat -A PREROUTING -d 10.10.1.254 -p tcp --dport 5000 -j DNAT --to-destination 10.10.2.10:5000
iptables -t nat -A POSTROUTING -d 10.10.2.10 -p tcp --dport 5000 -j SNAT --to-source 10.10.2.254

iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -d 10.10.2.10 -p tcp --dport 5000 -m conntrack --ctstate NEW -j LOG --log-prefix "FW ACCEPT 5000: " --log-level 4
iptables -A FORWARD -d 10.10.2.10 -p tcp --dport 5000 -j ACCEPT
iptables -A FORWARD -s 10.10.2.10 -d 10.10.3.10 -p tcp --dport 5678 -m conntrack --ctstate NEW -j LOG --log-prefix "FW ACCEPT 5678: " --log-level 4
iptables -A FORWARD -s 10.10.2.10 -d 10.10.3.10 -p tcp --dport 5678 -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate NEW -j LOG --log-prefix "FW DROP NEW: " --log-level 4

echo "Firewall started"

exec tail -F /dev/null
