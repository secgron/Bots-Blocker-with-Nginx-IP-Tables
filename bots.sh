#!/bin/bash
# Nginx Bad Bots Blocker Auto Installer
# Created by Teguh Aprianto
# https://bukancoder | https://teguh.co

IJO='\e[38;5;82m'
MAG='\e[35m'
RESET='\e[0m'

echo -e "$IJO                                                                                   $RESET"
echo -e "$IJO __________       __                    $MAG _________            .___             $RESET"
echo -e "$IJO \______   \__ __|  | _______    ____   $MAG \_   ___ \  ____   __| _/___________  $RESET"
echo -e "$IJO  |    |  _/  |  \  |/ /\__  \  /    \  $MAG /    \  \/ /  _ \ / __ |/ __ \_  __ \ $RESET"
echo -e "$IJO  |    |   \  |  /    <  / __ \|   |  \ $MAG \     \___(  <_> ) /_/ \  ___/|  | \/ $RESET"
echo -e "$IJO  |______  /____/|__|_ \(____  /___|  / $MAG  \______  /\____/\____ |\___  >__|    $RESET"
echo -e "$IJO        \/           \/     \/     \/   $MAG        \/            \/    \/         $RESET"
echo -e "$IJO ---------------------------------------------------------------------------       $RESET"
echo -e "$IJO |$MAG        Auto Installer to Block Bad Bots with Nginx and IPTables         $IJO| $RESET"
echo -e "$IJO ---------------------------------------------------------------------------       $RESET"
echo -e "$IJO |$IJO                               Created by                                $IJO| $RESET"
echo -e "$IJO |$MAG                             Teguh Aprianto                              $IJO| $RESET"
echo -e "$IJO ---------------------------------------------------------------------------       $RESET"
echo ""

echo -e "$MAG--=[ To start blocking bad bots to access your server, press any key to continue ]=--$RESET"
read answer 

echo -e "$MAG--=[ Creating bots.d directory ]=--$IJO"
if [ ! -d /etc/nginx/bots.d  ]; then
  mkdir /etc/nginx/bots.d 
fi
echo
echo

echo -e "$MAG--=[ Download bot list from Bukan Coder Archive ]=--$IJO"
yum -y install wget
cd /etc/nginx/bots.d 
wget https://arc.bukancoder.co/Nginx-Bad-Bot-Blocker/blacklist.conf.txt -O blacklist.conf
wget https://arc.bukancoder.co/Nginx-Bad-Bot-Blocker/blockips.conf.txt -O blockips.conf
    
echo
echo

echo -e "$MAG--=[ Updating Nginx Configuration ]=--$IJO"
rm -rf /etc/nginx/nginx.conf 
cat >/etc/nginx/nginx.conf<<eof
$alf
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;
    client_max_body_size 500M;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    include /etc/nginx/bots.d/*;
}

eof
echo
echo

echo -e "$MAG--=[ Blocking bots with iptables ]=--$IJO"
cd ~
wget https://arc.bukancoder.co/Bots-Iptables/block.txt -O block 
wget https://arc.bukancoder.co/Bots-Iptables/ips.txt -O ips 
chmod +x block 
./block

echo -e "$MAG--=[ Save iptables ]=--$IJO"

systemctl stop firewalld
systemctl mask firewalld

yum install iptables-services

systemctl enable iptables

service iptables save

echo
echo -e "$MAG--=[Done! Bots has been blocked using Nginx Bad Bots Blocker and iptables]=--$IJO"

