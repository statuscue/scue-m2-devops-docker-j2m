include .env

up: ## Boot virtual machine(s)
	@J2M_CMRU=$(COMPOSER_MAGENTO_REPO_USERNAME) \
	J2M_CMRP=$(COMPOSER_MAGENTO_REPO_PASSWORD) \
	J2M_DB_HOST=$(DB_HOST) \
	J2M_DB_NAME=$(DB_NAME) \
	J2M_DB_USER=$(DB_USER) \
	J2M_DB_PASSWORD=$(DB_PASSWORD) \
	J2M_DB_ROOT_PASSWORD=$(DB_ROOT_PASSWORD) \
	J2M_MAGENTO_BASE_URL=$(MAGENTO_BASE_URL) \
	J2M_MAGENTO_ADMIN_FIRSTNAME=$(MAGENTO_ADMIN_FIRSTNAME) \
	J2M_MAGENTO_ADMIN_LASTNAME=$(MAGENTO_ADMIN_LASTNAME) \
	J2M_MAGENTO_ADMIN_EMAIL=$(MAGENTO_ADMIN_EMAIL) \
	J2M_MAGENTO_ADMIN_USER=$(MAGENTO_ADMIN_USER) \
	J2M_MAGENTO_ADMIN_PASSWORD=$(MAGENTO_ADMIN_PASSWORD) \
	J2M_MAGENTO_LANGUAGE=$(MAGENTO_LANGUAGE) \
	J2M_MAGENTO_CURRENCY=$(MAGENTO_CURRENCY) \
	J2M_MAGENTO_TIMEZONE=$(MAGENTO_TIMEZONE) \
	J2M_MAGENTO_BACKEND_FRONTNAME=$(MAGENTO_BACKEND_FRONTNAME) \
	vagrant up

down: ## Halt virtual machine(s)
	@vagrant halt

prune: ## Destroy virtual machine(s)
	@vagrant destroy -f

.PHONY: up down prune

.DEFAULT_GOAL := help
help: ## Print this help
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| sed -e 's/^.*Makefile://g' \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
		| sed -e 's/\[32m##/[33m/'
.PHONY: help

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
