#!/bin/bash
# ******************************************
# Program: Web dev Installation Script
# Developer: Aakash TM
# Date: 16-01-2021
# Last Updated: 16-01-2021
# ******************************************


DIRNAME=$(pwd)

usage () { echo "
    -h -- Opens up this help message
"; }

installEssentials() {
    echo "<<== Installing essentials now ==>>"
    sudo apt install curl
    installNode;
    sudo snap install skype --classic
    sudo snap install slack --classic
    sudo snap install discord
    installVSCode;
    installGo;
    installMongo;
    installPostgresql
}

function installVSCode() {
    sudo apt install software-properties-common apt-transport-https wget;
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -;
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main";
    sudo apt install code
}

function installNode() {
    echo "<<== Installing node now ==>>"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash;
    source ~/.bashrc;
    nvm install --lts;

    echo $(node -v);
    echo "<<== Installed $(node -v);  ==>>";

    installYarn;
}

function installYarn() {
    echo "<<== Installing yarn now ==>>"
    npm i -g yarn
    echo "<<== Installed $(yarn -v);  ==>>"
}

function installGo() {
    echo "<<== Installing go now ==>>"

    wget -c https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
    export PATH=$PATH:/usr/local/go/bin
    source ~/.profile

    echo "<<== Installed $(go version);  ==>>"
}

function installMongo() {
    echo "<<== Installing mongo now ==>>"

    curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -;
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
    
    sudo apt update
    sudo apt install mongodb-org

    sudo systemctl start mongod.service
    sudo systemctl status mongod
    sudo systemctl enable mongod

    mongo --eval 'db.runCommand({ connectionStatus: 1 })'

    echo "<<== Installed $(go version);  ==>>"
}

function installPostgresql() {
    echo "<<== Installing mongo now ==>>"

    sudo apt install postgresql postgresql-contrib

    echo "<<== Installed $(psql -V);  ==>>"
}

options=':n:p:r:e:dh'

sudo apt update

while getopts $options option
do
    case "$option" in
        h  ) usage; exit;;
        node  ) installNode; exit;;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

