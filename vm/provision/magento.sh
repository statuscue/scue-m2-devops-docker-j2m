#!/usr/bin/env bash

# Create a database
mysql --user=root --password=$DB_ROOT_PASSWORD <<SQL
DROP DATABASE IF EXISTS $DB_NAME;
DROP USER IF EXISTS $DB_USER;
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@localhost IDENTIFIED BY '$DB_PASSWORD';
FLUSH PRIVILEGES;
SQL

if [ "$(ls -A /var/www/html)" ]; then
     rm -rf /var/www/html/*
fi
composer config --global http-basic.repo.magento.com $COMPOSER_MAGENTO_REPO_USERNAME $COMPOSER_MAGENTO_REPO_PASSWORD && \
composer create-project --no-interaction --repository=https://repo.magento.com/ magento/project-community-edition=2.3.5 ~/magento2 && \
sudo cp -a ~/magento2/. /var/www/html/ && \
rm -rf ~/magento2 && \
cd /var/www/html && \
chmod u+x bin/magento && \
bin/magento setup:install \
    --base-url=http://$MAGENTO_BASE_URL/ \
    --db-host=$DB_HOST \
    --db-name=$DB_NAME \
    --db-user=$DB_USER \
    --db-password=$DB_PASSWORD \
    --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME \
    --admin-lastname=$MAGENTO_ADMIN_LASTNAME \
    --admin-email=$MAGENTO_ADMIN_EMAIL \
    --admin-user=$MAGENTO_ADMIN_USER \
    --admin-password=$MAGENTO_ADMIN_PASSWORD \
    --backend-frontname=$MAGENTO_BACKEND_FRONTNAME \
    --language=$MAGENTO_LANGUAGE \
    --currency=$MAGENTO_CURRENCY \
    --timezone=$MAGENTO_TIMEZONE \
    --use-rewrites=1 && \
bin/magento deploy:mode:set developer
