sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove

apt install -y net-tools  vim terminator curl 


curl -s "https://get.sdkman.io" | bash

source "~/.sdkman/bin/sdkman-init.sh"

sdk version

sdk install  java 17.0.2-tem

java --version

sdk use java 17.0.2-tem
sdk default java 17.0.2-tem


 apt -y install openssh-server
 sudo systemctl status ssh

 ufw allow ssh

 ip a


# install docker 

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

