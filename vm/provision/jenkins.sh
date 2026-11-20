#!/usr/bin/env bash

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - > /dev/null 2>&1
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update > /dev/null 2>&1
apt-get -y install default-jre default-jdk jenkins git > /dev/null 2>&1
sudo systemctl start jenkins.service

sleep 1m

JENKINSPWD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo $JENKINSPWD