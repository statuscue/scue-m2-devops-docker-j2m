#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install all required software at once
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1
debconf-set-selections <<EOF
mysql-server mysql-server/root_password password $DB_ROOT_PASSWORD
mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWORD
EOF
apt-get -y install \
    software-properties-common \
    zip \
    unzip \
    nginx \
    mysql-server \
    php7.3-fpm \
    php7.3-cli \
    php7.3-common \
    php7.3-mysql \
    php7.3-bcmath \
    php7.3-curl \
    php7.3-xml \
    php7.3-gd \
    php7.3-intl \
    php7.3-mbstring \
    php7.3-soap \
    php7.3-xsl \
    php7.3-zip \
    > /dev/null 2>&1

# Copy configs previously copied to VM to /home/vagrant/config
# via "file" provisioner. See Vagrantfile
cp /home/vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
cp /home/vagrant/config/nginx/vhost.conf /etc/nginx/conf.d/default.conf
cp /home/vagrant/config/php/www.conf /etc/php/7.3/fpm/pool.d/www.conf
cp /home/vagrant/config/php/php-fpm.ini /etc/php/7.3/fpm/php.ini
cp /home/vagrant/config/php/php-cli.ini /etc/php/7.3/cli/php.ini

# Remove default config
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default

# Configure root directory
chown -R vagrant:vagrant /var/www/html
rm -f /var/www/html/index.nginx-debian.html

