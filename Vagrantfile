# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # web server with Magento 2.3.5
  config.vm.define "web" do |web|
    web.vm.box = "ubuntu/bionic64"
    web.vm.network "private_network", ip: "192.168.50.4"
    web.vm.hostname = "web"
    web.vm.provider "virtualbox" do |wvb|
      wvb.customize ["modifyvm", :id, "--name", "web"]
      wvb.customize ["modifyvm", :id, "--memory", 6144] # 6 GB
      wvb.customize ["modifyvm", :id, "--cpus", 4] # 4 CPUs
      wvb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      wvb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
  
    # Install LEMP and copy config files to appropriate locations
    # Note, we will use the "file" provisioner as we don't configure synced folders at all.
    web.vm.provision "file", source: "vm/config", destination: "$HOME/config"
    web.vm.provision "setup_environment_software", type: "shell" do |s|
      s.path = "vm/provision/web.sh"
      s.env = {
        "DB_ROOT_PASSWORD" => ENV['J2M_DB_ROOT_PASSWORD'],
      }
    end
  
    web.vm.provision "setup_tools_non_privileged", type: "shell" do |s|
      s.privileged = false
      s.path = "vm/provision/composer.sh"
    end

    web.vm.provision "install_magento_ce_235", type: "shell" do |s|
      s.privileged = false
      s.path = "vm/provision/magento.sh"
      s.env = {
        "COMPOSER_MAGENTO_REPO_USERNAME" => ENV['J2M_CMRU'],
        "COMPOSER_MAGENTO_REPO_PASSWORD" => ENV['J2M_CMRP'],
        "DB_HOST" => ENV['J2M_DB_HOST'],
        "DB_NAME" => ENV['J2M_DB_NAME'],
        "DB_USER" => ENV['J2M_DB_USER'],
        "DB_PASSWORD" => ENV['J2M_DB_PASSWORD'],
        "DB_ROOT_PASSWORD" => ENV['J2M_DB_ROOT_PASSWORD'],
        "MAGENTO_BASE_URL" => ENV['J2M_MAGENTO_BASE_URL'],
        "MAGENTO_ADMIN_FIRSTNAME" => ENV['J2M_MAGENTO_ADMIN_FIRSTNAME'],
        "MAGENTO_ADMIN_LASTNAME" => ENV['J2M_MAGENTO_ADMIN_LASTNAME'],
        "MAGENTO_ADMIN_EMAIL" => ENV['J2M_MAGENTO_ADMIN_EMAIL'],
        "MAGENTO_ADMIN_USER" => ENV['J2M_MAGENTO_ADMIN_USER'],
        "MAGENTO_ADMIN_PASSWORD" => ENV['J2M_MAGENTO_ADMIN_PASSWORD'],
        "MAGENTO_LANGUAGE" => ENV['J2M_MAGENTO_LANGUAGE'],
        "MAGENTO_CURRENCY" => ENV['J2M_MAGENTO_CURRENCY'],
        "MAGENTO_TIMEZONE" => ENV['J2M_MAGENTO_TIMEZONE'],
        "MAGENTO_BACKEND_FRONTNAME" => ENV['J2M_MAGENTO_BACKEND_FRONTNAME'],
      }
    end

    # Always restart services on boot, even when not running the full provisioner
    web.vm.provision "shell", inline: "sudo systemctl restart mysql", run: "always"
    web.vm.provision "shell", inline: "sudo systemctl restart nginx", run: "always"
    web.vm.provision "shell", inline: "sudo systemctl restart php7.3-fpm", run: "always"
  end

  # Jenkins
  config.vm.define "jenkins" do |j|
    j.vm.box = "ubuntu/bionic64"
    j.vm.network "private_network", ip: "192.168.50.5"
    j.vm.hostname = "jenkins"
    j.vm.provider "virtualbox" do |jvb|
      jvb.customize ["modifyvm", :id, "--name", "jenkins"]
      jvb.customize ["modifyvm", :id, "--memory", 4096] # 4 GB
      jvb.customize ["modifyvm", :id, "--cpus", 4] # 4 CPUs
      jvb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      jvb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    j.vm.provision "setup_jenkins", type: "shell" do |s|
      s.path = "vm/provision/jenkins.sh"
    end
  end

  # Disabling the default /vagrant share
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provisioning for all VMs
  config.vm.provision "fix_no_tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision "apt_upgrade", type: "shell" do |s|
    s.inline = "apt-get update --fix-missing > /dev/null 2>&1 && apt-get -y upgrade > /dev/null 2>&1"
  end
end
