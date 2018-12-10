#!/bin/bash
if [[ $UID -ne 0 ]];then
echo "You Must Run With Root ,Permission Denied"
else
NETMASK=$(route|tr -s " "|grep 192|cut -d " " -f3)
INTERFACE=$(route|tr -s " "|grep 192|cut -d " " -f8)
GATEWAY=$(route|tr -s " "|grep 192|cut -d " " -f2)
GR_IP=$(route|tr -s " "|grep 192|cut -d " " -f1|cut -d "." -f1,2,3)
IPNET=$(route|tr -s " "|grep 192|cut -d " " -f1)
IPSTATIC=$GR_IP.100
PATHNET=/etc/network/interfaces
STATUS_SERVICE=$(/etc/init.d/networking status|grep Active|tr -s " "|cut -d " " -f3)
RETURN_STATUS_SERVICE=$(/etc/init.d/networking status|grep Active|tr -s " "|cut -d " " -f3,4)
NBPATH=$(cat $PATHNET|wc -l)
PATHDHCPCONF=/etc/dhcp/dhcpd.conf
HOSTNAME=$(hostname -f)
case $1 in
-i | --install)
if [[ $2 == "dhcp" ]];then
apt-get install isc-dhcp-server -y
sleep 1.5
else
echo "Error"
fi
;;
-s | --server)
if [[ $2 == "" ]]; then
echo -e "No input file given. Quitting. \nusage : $0 -s <server>"
exit 0
fi
#DHCP SERVER_AUTO
if [[ $2 = 'dhcp' ]]; then
for INDICE_LINE in $(seq 1 1 $NBPATH)
do
SEARCH_NOTCOMBYLINE=$(cat $PATHNET|grep ^[^\#]|tail -$i|head -1|wc -l)
if [[ $SEARCH_NOTCOMBYLINE -ne 0 ]]; then
sed -i s/^/\#/ $PATHNET
fi
done    
sleep 0.2
echo -e "\033[32m[+] Your STATICIP $IPSTATIC \033[0m"
sudo cp $PATHNET ~/interfaces.old
echo -e "
auto lo
iface lo inet loopback
auto $INTERFACE
iface $INTERFACE inet static
address $IPSTATIC
netmask $NETMASK
network $GATEWAY" >> ~/Bureau/networking
sleep 0.2
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
#DHCP SERVER OPTIONS
case $3 in
-r | --range)
RANGEI=$4
RANGEO=$5
sleep 1
if [[ $RANGEI =~ ^[0-9]{1,3} ]] && [[ $RANGEO =~ ^[0-9]{1,3} ]];then
if [[ ${RANGEI} -lt 255 ]] && [[ ${RANGEO} -lt 255 ]];then
echo -e "\033[32m[+] Building RANGE IN [$RANGEI-$RANGEO]\033[0m"
cat $PATHDHCPCONF |grep ^[^\#]|grep 'domain-name '|sed -i s/"example.org"/"$HOSTNAME"/ $PATHDHCPCONF
sleep 1.5
echo -e "\033[32m[+] Building domain-name [$HOSTNAME]\033[0m"
cat $PATHDHCPCONF |grep ^[^\#]|grep 'domain-name-'|sed -i s/"ns1.example.org, ns2.example.org"/"$IPSTATIC, 8.8.8.8"/ $PATHDHCPCONF
sleep 1.1
echo -e "\033[32m[+] Building domain-name-server $ [$IPSTATIC, 8.8.8.8]\033[0m"
RANGEINPUT=$GR_IP.$RANGEI
RANGEOUTPUT=$GR_IP.$RANGEO
sudo echo -e "subnet $IPNET netmask $NETMASK {
range $RANGEINPUT $RANGEOUTPUT;
option domain-name-servers $IPSTATIC 8.8.8.8;
option domain-name "$HOSTNAME";
option subnet-mask $NETMASK;
option routers $IPSTATIC;
option broadcast-address $IPSTATIC;
default-lease-time 600;
max-lease-time 7200;
}" >> $PATHDHCPCONF
#################------------------------------###################
echo -e "\033[34m[~] Configure $PATHDHCPCONF ..\033[0m"
sleep 0.9
echo -e "\033[32m[+] subnet $IPNET netmask $NETMASK\033[0m"
sleep 1
echo -e "\033[32m[+] range $RANGEINPUT $RANGEOUTPUT\033[0m"
sleep 0.8
echo -e "\033[32m[+] option domain-name-servers $IPSTATIC 8.8.8.8\033[0m"
sleep 3
echo -e "\033[32m[+] option domain-name "$HOSTNAME"\033[0m"
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
echo -e "\033[34m[~] Configure /etc/default/isc-dhcp-server ..\033[0m"
sleep 0.6
echo -e "\033[32m[+] Building Default Interface $DefaultINT\033[0m"
cp /etc/default/isc-dhcp-server ~/isc-dhcp-server.old
sudo cat /etc/default/isc-dhcp-server|grep INTERFACESv4=|sed -i s/\"\"/\"$INTERFACE\"/ /etc/default/isc-dhcp-server
sleep 0.6
echo -e "\033[32m[+] Interface INTERFACESv4=\"$INTERFACE\"\033[0m"
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