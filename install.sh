#!/bin/bash

red="\e[0;31m"
blue="\e[0;94m"
green="\e[0;32m"
off="\e[0m"
echo -e "$red [$green+$red]$off Installing docker... ";
sudo apt-get install docker
echo -e "$red [$green+$red]$off Creating group docker... ";
sudo groupadd docker
echo -e "$red [$green+$red]$off Changing permissions... ";
USER=$(who|tr -s " "|cut -d" " -f1)
sudo usermod -aG docker $USER
echo -e "$red [$green+$red]$off Installing Ansible... ";
sudo apt-get install ansible