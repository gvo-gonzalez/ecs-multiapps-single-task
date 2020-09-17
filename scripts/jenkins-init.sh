#!/bin/bash

# Volume setup
sudo vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
    sudo pvcreate ${DEVICE}
    sudo vgcreate data ${DEVICE}
    sudo lvcreate    --name volume1 -l 100%FREE data
    sudo mkfs.ext4 /dev/data/volume1
fi
sudo mkdir -p /var/lib/jenkins
sudo echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
sudo mount /var/lib/jenkins

# install jenkins and docker
sudo apt install openjdk-8-jre-headless
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins unzip docker.io
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
# install pip
sudo wget -q https://bootstrap.pypa.io/get-pip.py
#python get-pip.py
sudo apt-get install python3-distutils
sudo python3 get-pip.py
sudo rm -f get-pip.py
# install awscli
pip install awscli

# install terraform
cd /usr/local/bin
sudo wget -q https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
sudo unzip terraform_0.12.24_linux_amd64.zip

# clean up
sudo apt-get clean
sudo rm -f terraform_0.12.24_linux_amd64.zip
sudo service jenkins restart