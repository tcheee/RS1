IP=iptables

$IP -F
$IP -X
$IP -t mangle -F
$IP -t mangle -X
$IP -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IP -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IP -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
$IP -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
$IP -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
$IP -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
$IP -t mangle -A PREROUTING -f -j DROP
$IP -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset
$IP -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT
$IP -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP
$IP -A INPUT -p tcp --dport 5555 -m conntrack --ctstate NEW -m recent --set
$IP -A INPUT -p tcp --dport 5555 -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
$IP -N port-scanning
$IP -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
$IP -A port-scanning -j DROP
$IP -A INPUT -p tcp --dport 5555 -j ACCEPT
$IP -A OUTPUT -p tcp --sport 5555 -j ACCEPT
$IP -A INPUT -p udp --sport 53 -j ACCEPT
$IP -A OUTPUT -p udp --dport 53 -j ACCEPT
$IP -t filter -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
$IP -t filter -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
$IP -t filter -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
$IP -t filter -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
$IP -A OUTPUT -j DROP
$IP -A INPUT -j DROP
