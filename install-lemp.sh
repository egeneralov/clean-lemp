#!/bin/bash

clear;
echo "Hello! Installation of LEMP (github.com/egeneralov/clean-LEMP) started";
read -p "Please provide password for MySQL root user: " mysqlpasswd;

echo "Update apt cache & upgrade system";
apt-get clean > /dev/null 2>&1;
apt-get update > /dev/null 2>&1;
apt-get upgrade > /dev/null 2>&1;

echo "Installing dependences";
apt-get install -y curl cron netcat > /dev/null 2>&1;

echo "installing acme.sh - lets encrypt client";
curl -s https://get.acme.sh | sh > /dev/null 2>&1;

echo "Adding repository dotdeb.org";
cat <<< 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list;
curl https://www.dotdeb.org/dotdeb.gpg -s | apt-key add - ;
apt-get update > /dev/null 2>&1;

debconf-set-selections <<< "mysql-server-5.5	mysql-server/root_password string $mysqlpasswd"
debconf-set-selections <<< "mysql-server-5.5	mysql-server/root_password_again string $mysqlpasswd"

echo "Installing LEMP (may cost time)";
apt-get install -y nginx mysql-server php7.0 php7.0-cli php7.0-fpm php7.0-curl php7.0-gd php7.0-imagick php7.0-mcrypt php7.0-imap php7.0-mbstring php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-json php7.0-memcached php7.0-apcu php7.0-apcu-bc php7.0-opcache php7.0-mysql php7.0-sqlite3 php7.0-pgsql php7.0-redis php7.0-interbase php7.0-odbc php7.0-zip php7.0-bz2 php7.0-dba php7.0-enchant php7.0-gmp php7.0-igbinary php7.0-intl php7.0-ldap php7.0-msgpack php7.0-geoip php7.0-readline php7.0-recode php7.0-tidy > /dev/null 2>&1;

#ssl
mkdir /etc/nginx/ssl
