#!/bin/bash

LGREEN='\033[1;32m'
NC='\033[0m'

printf "${LGREEN}==== Revoming old versions${NC}\n";
sudo apt-get remove -y docker docker-engine docker.io containerd runc &&

printf "${LGREEN}==== Update the apt package index${NC}\n";
sudo apt-get update ;

printf "${LGREEN}==== Install packages to allow apt to use a repository over HTTPS${NC}\n";
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y &&

printf "${LGREEN}==== Add Docker’s official GPG key${NC}\n";
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - ;

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable";

printf "${LGREEN}==== Install the latest version of Docker Engine - Community and containerd${NC}\n";
sudo apt-get install docker-ce docker-ce-cli containerd.io -y;

printf "${LGREEN}==== Install docker compose${NC}\n";
sudo apt-get install docker-compose -y

printf "\n\n${LGREEN}Done!${NC}\n";
