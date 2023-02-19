#!/bin/bash
set -x

#SYSTEM UPDATE
#=============
sudo apt -y update > /dev/null 2>&1
sudo apt install -y make \
build-essential checkinstall libssl-dev zlib1g-dev libbz2-dev libreadline-dev libreadline-gplv2-dev \
libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
libgdbm-dev libc6-dev libbz2-dev zlib1g-dev python3-dev python3-setuptools git terraform unzip git > /dev/null 2>&1

#AGENT
#============
mkdir /home/azureuser/myagent/
mkdir /home/azureuser/agent/_work
cd /home/azureuser
sudo chown -R azureuser:azureuser /home/azureuser/
echo "start"
cd /home/azureuser/myagent/
echo "Downloading..."
wget -O agent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.213.2/vsts-agent-linux-x64-2.213.2.tar.gz
tar zxvf agent.tar.gz
chmod -R 777 .
echo "extracted"
sudo ./bin/installdependencies.sh
echo "dependencies installed"
sudo -u azureuser ./config.sh --unattended --url ${url} --auth pat --token ${pat} --pool ${pool} --acceptTeeEula --work /home/azureuser/agent/_work --runAsService
echo "configuration done"
sudo ./svc.sh install
# sudo -u azureuser ./run.sh > /dev/null 2>&1 & 


#Pyenv - optional:
#==================
sudo git init > /dev/null 2>&1

git clone https://github.com/pyenv/pyenv.git /home/azureuser/.pyenv > /dev/null 2>&1
sudo chown -R azureuser:azureuser /home/azureuser/.pyenv > /dev/null 2>&1

sudo /bin/echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /home/azureuser/.bashrc 
sudo /bin/echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/azureuser/.bashrc
sudo /bin/echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> /home/azureuser/.bashrc
sudo /bin/echo 'eval "$(pyenv init -)"' >> /home/azureuser/.bashrc
source /home/azureuser/.bashrc > /dev/null 2>&1
# sleep 3
# sudo ln -s /home/azureuser/.pyenv/bin/pyenv /usr/local/bin > /dev/null 2>&1
#cd /home/azureuser/.pyenv/bin/ && sudo /home/azureuser/.pyenv/bin/pyenv install 3.7.9
#/home/azureuser/.pyenv/bin/pyenv versions

#Python3.7
#=========
sudo add-apt-repository ppa:deadsnakes/ppa -y > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt install -y python3.7
sudo update-alternatives  --set python /usr/bin/python3.7  python --version
echo "alias python=python3.7" >> /home/azureuser/.bashrc 
source /home/azureuser/.bashrc 
alias python=python3.7

#Install PIP
#===========
sudo apt install -y python-pip > /dev/null 2>&1


#Install Az Cli
#==============
sudo apt update -y > /dev/null 2>&1
sudo apt install -y ca-certificates curl apt-transport-https lsb-release gnupg  > /dev/null 2>&1
curl -sL https://packages.microsoft.com/keys/microsoft.asc |     gpg --dearmor |     sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null 2>&1
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt -y update > /dev/null 2>&1
sudo apt install -y azure-cli > /dev/null 2>&1
###

#INSTALL AZURE-CORE
#==================
pip install --upgrade --force-reinstall azure-core > /dev/null 2>&1

##
#INSTALL DOCKER
#==============
sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common > /dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update > /dev/null 2>&1
sudo apt-get install -y docker-ce > /dev/null 2>&1
# Linux post-install
sudo groupadd docker > /dev/null 2>&1
sudo usermod -aG docker azureuser > /dev/null 2>&1
docker info > /dev/null 2>&1

##
#INSTALL DOCKER COMPOSE
#======================
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose > /dev/null 2>&1
sudo chmod +x /usr/local/bin/docker-compose > /dev/null 2>&1
###

#CREATING DIRECTORIES AND TOUCHING FILES
#=======================================
mkdir -p /home/azureuser/agent/_work/_tool/python/3.7.9/x64
touch /home/azureuser/agent/_work/_tool/python/3.7.9/x64.complete > /dev/null 2>&1
sudo chown -R  azureuser:azureuser /home/azureuser/agent/

#CREATE SYMLINKS
#===============
sudo ln -s /usr/bin/pip /home/azureuser/agent/_work/_tool/python/3.7.9/x64
sudo ln -s /usr/bin/python /home/azureuser/agent/_work/_tool/python/3.7.9/x64


echo "#INSTALLED PACKAGES"
echo "#=================="
#pyenv versions
pip --version
az --version
docker --version
docker-compose --version
python --version

sudo reboot

#end#