#!/bin/bash
#Author: BENSAAD Anouar
if [[ $UID -ne 0 ]];then
#Testing if superuser run this script or no ?
echo -e "You Must Run With Root \033[31mPermission Denied \033[0m"
else
NETMASK=$(route|tr -s " "|grep 192|cut -d " " -f3)
INTERFACE=$(route|tr -s " "|grep 192|cut -d " " -f8)
GR_IP=$(route|tr -s " "|grep 192|cut -d " " -f1|cut -d "." -f1,2,3)
IPNET=$(route|tr -s " "|grep 192|cut -d " " -f1)
IPSTATIC=$GR_IP.100
PATHNET=/etc/network/interfaces
#NETWORKING_SERVICE
STATUS_SERVICE=$(/etc/init.d/networking status|grep Active|tr -s " "|cut -d " " -f3)
RETURN_STATUS_SERVICE=$(/etc/init.d/networking status|grep Active|tr -s " "|cut -d " " -f3,4)
#DHCP_SERVICE
STATUS_SERVICE_DHCP=$(/etc/init.d/isc-dhcp-server status|grep Active|tr -s " "|cut -d " " -f3)
RETURN_STATUS_SERVICE_DHCP=$(/etc/init.d/isc-dhcp-server status|grep Active|tr -s " "|cut -d " " -f3,4)
NBPATH=$(cat $PATHNET|wc -l)
PATHDHCPCONF=/etc/dhcp/dhcpd.conf
HOSTNAME=$(hostname -f)
BROADCAST=$(ifconfig|grep broadcast|tr -s " "|cut -d " " -f7)
GATEWAY=$GR_IP.1
case $1 in
-i | --install)
if [[ $2 == "dhcp" ]];then
apt-get install isc-dhcp-server -y
sleep 1.5
else
echo "[-] "
fi
;;
-s | --server)
if [[ $2 == "" ]]; then
echo -e "No input file given. Quitting. \nusage : $0 -s <server>"
exit 0
fi
#################----------SELECTING DHCP-----------###################
if [[ $2 = 'dhcp' ]]; then
for INDICE_LINE in $(seq 1 1 $NBPATH)
do
SEARCH_NOTCOMBYLINE=$(cat $PATHNET|grep ^[^\#]|tail -$i|head -1|wc -l)
if [[ $SEARCH_NOTCOMBYLINE -ne 0 ]]; then
sudo cat $PATHNET |sed s/\^[^\#]/\#/g|grep -v ^\# > $PATHNET
fi
done    
sleep 0.2
echo -e "\033[32m[+] Your STATICIP $IPSTATIC \033[0m"
sudo cp $PATHNET ~/interfaces.old
sudo echo -e "
auto lo
iface lo inet loopback
auto $INTERFACE
iface $INTERFACE inet static
address $IPSTATIC
netmask $NETMASK
network $IPNET
broadcast $BROADCAST
gateway $GATEWAY"> $PATHNET
sleep 0.2
#################----------/etc/network/interfaces-----------###################
echo -e "\033[34m[~] Configure $PATHDHCPCONF ..\033[0m"
sleep 0.9
echo -e "\033[32m[+] auto lo \033[0m"
sleep 1
echo -e "\033[32m[+] auto $INTERFACE\033[0m"
sleep 0.8
echo -e "\033[32m[+] iface $INTERFACE inet static\033[0m"
sleep 3
echo -e "\033[32m[+] address $IPSTATIC\033[0m"
sleep 1.1
echo -e "\033[32m[+] netmask $NETMASK\033[0m"
sleep 1.1
echo -e "\033[32m[+] network $IPNET\033[0m"
#Restarting service networking
/etc/init.d/networking restart
echo -e "\033[34m[~] Restarting Service ... \033[0m"
sleep 0.2
if [[ $STATUS_SERVICE = "active" ]]; then
echo -e "Status Of Service is : \033[32m$RETURN_STATUS_SERVICE\033[0m"
elif [[ $STATUS_SERVICE = "inactive" ]]; then
echo -e "Status Of Service is : \033[31m$RETURN_STATUS_SERVICE\033[0m"
else
echo "Service Error Unkown"
fi
#################----------DHCP_RANGE&DEFAULTINTERFACE-----------###################
#DHCP SERVER OPTIONS
case $3 in
-r | --range)
RANGEI=$4
RANGEO=$5
sleep 1
if [[ $RANGEI =~ ^[0-9]{1,3} ]] && [[ $RANGEO =~ ^[0-9]{1,3} ]];then
if [[ ${RANGEI} -lt 255 ]] && [[ ${RANGEO} -lt 255 ]];then
echo -e "\033[32m[+] Building RANGE IN [$RANGEI-$RANGEO]\033[0m"
sudo cat $PATHDHCPCONF |sed s/\^[^\#]/\#/g|grep -v ^\# > $PATHDHCPCONF
echo -e "\033[32m[+] Building domain-name-server $ [$IPSTATIC, 8.8.8.8]\033[0m"
RANGEINPUT=$GR_IP.$RANGEI
RANGEOUTPUT=$GR_IP.$RANGEO
sudo echo -e "
option domain-name \"$HOSTNAME\";
option domain-name-servers $IPSTATIC, 8.8.8.8;
default-lease-time 600;
max-lease-time 7200;
subnet $IPNET netmask $NETMASK {
range $RANGEINPUT $RANGEOUTPUT;
option domain-name-servers $IPSTATIC 8.8.8.8;
option domain-name \"$HOSTNAME\";
option subnet-mask $NETMASK;
option routers $IPSTATIC;
option broadcast-address $IPSTATIC;
default-lease-time 600;
max-lease-time 7200;
}" > $PATHDHCPCONF
#################----------/etc/dhcp/dhcpd.conf-----------###################
echo -e "\033[34m[~] Configure $PATHDHCPCONF ..\033[0m"
sleep 0.9
echo -e "\033[32m[+] subnet $IPNET netmask $NETMASK\033[0m"
sleep 1
echo -e "\033[32m[+] range $RANGEINPUT $RANGEOUTPUT\033[0m"
sleep 0.8
echo -e "\033[32m[+] option domain-name-servers $IPSTATIC 8.8.8.8\033[0m"
sleep 3
echo -e "\033[32m[+] option domain-name \"$HOSTNAME\"\033[0m"
sleep 1.1
echo -e "\033[32m[+] option subnet-mask $NETMASK\033[0m"
sleep 0.2
echo -e "\033[32m[+] option routers $IPSTATIC\033[0m"
sleep 1.1
echo -e "\033[32m[+] option broadcast-address $IPSTATIC\033[0m"
sleep 0.7
echo -e "\033[32m[+] default-lease-time 600\033[0m"
sleep 0.6
echo -e "\033[32m[+] max-lease-time 7200\033[0m"
sleep 0.5
else
echo -e "\033[31m[-] Range must be in 1 - 254\033[0m"
fi
fi
case $6 in
-d | --default-interface)
DefaultINT=$7
if [[ $DefaultINT = $INTERFACE ]];then
cp /etc/default/isc-dhcp-server ~/isc-dhcp-server.old
sudo cat /etc/default/isc-dhcp-server|grep INTERFACESv4=|sed -i s/\"\"/\"$INTERFACE\"/ /etc/default/isc-dhcp-server
sleep 0.6
#################----------/etc/dhcp/dhcpd.conf-----------###################
echo -e "\033[34m[~] Configure /etc/default/isc-dhcp-server ..\033[0m"
sleep 0.6
echo -e "\033[32m[+] Building Default Interface $DefaultINT\033[0m"
sleep 0.4
echo -e "\033[32m[+] Interface INTERFACESv4=\"$INTERFACE\"\033[0m"
#################----------STATUS_OF_SERVICE DHCP-----------###################
/etc/init.d/isc-dhcp-server restart
echo -e "\033[34m[~] Restarting Service DHCP... \033[0m"
sleep 0.2
if [[ $STATUS_SERVICE_DHCP = "active" ]]; then
echo -e "Status Of Service is : \033[32m$RETURN_STATUS_SERVICE_DHCP\033[0m"
elif [[ $STATUS_SERVICE_DHCP = "inactive" ]]; then
echo -e "Status Of Service is : \033[31m$RETURN_STATUS_SERVICE_DHCP\033[0m"
else
echo "Service Error Unkown"
fi
#ELSE
else
sleep 0.4
echo -e "\033[31m[-] Error To Build The Interface\033[0m"
fi
;;
*)
;;
esac
;;
*)
echo "selecting range"
;;
esac
else
echo "error selecting dhcp"
fi
;;
*)
echo -e "Error select"
;;
esac

fi
