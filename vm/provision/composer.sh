#!/usr/bin/env bash

# Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
mkdir -p /home/$USER/.composer
sudo chown -R $USER:$USER /home/$USER/.composer
composer global require hirak/prestissimo