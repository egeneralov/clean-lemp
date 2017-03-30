#!/bin/bash
apt-get clean;
apt-get update;
apt-get upgrade;
apt-get install -y curl cron > /dev/null 2>&1;
curl https://get.acme.sh | sh;
cat <<< 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list;
curl https://www.dotdeb.org/dotdeb.gpg | apt-key add - ;
apt-get update;
apt-get install -y nginx mysql-server php7.0 php7.0-cli php7.0-fpm php7.0-curl php7.0-gd php7.0-imagick php7.0-mcrypt php7.0-imap php7.0-mbstring php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-json php7.0-memcached php7.0-apcu php7.0-apcu-bc php7.0-opcache php7.0-mysql php7.0-sqlite3 php7.0-pgsql php7.0-redis php7.0-interbase php7.0-odbc php7.0-zip php7.0-bz2 php7.0-dba php7.0-enchant php7.0-gmp php7.0-igbinary php7.0-intl php7.0-ldap php7.0-msgpack php7.0-geoip php7.0-readline php7.0-recode php7.0-tidy;
