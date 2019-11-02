#!/bin/bash

LGREEN='\033[1;32m'
NC='\033[0m'

printf "${LGREEN}==== Create dir and clone bigbluebutton${NC}\n";
mkdir $HOME/docker_bbb/ ;
cd $HOME/docker_bbb/ &&
git clone git@github.com:iMDT/bigbluebutton.git ;

printf "${LGREEN}==== Create dir and clone bbb-docker-dev${NC}\n";
git clone git@github.com:iMDT/bbb-docker-dev.git ;
cd bbb-docker-dev &&

printf "${LGREEN}==== Change hostname${NC}\n";
sed -i 's/--cap-add=NET_ADMIN --name/--cap-add=NET_ADMIN --hostname bbb22 --name/' build-and-start.sh;

printf "${LGREEN}==== Build bbb${NC}\n";
./build-and-start.sh bbb $HOME/docker_bbb/bigbluebutton/ ;

printf "${LGREEN}==== Define password for user bbb${NC}\n";
docker exec -ti bbb passwd bbb;

ssh bbb@127.0.0.1 -p 9922 'bash -s' < dev-install.sh;

cd $HOME/docker_bbb/bigbluebutton;
git remote rm origin &&
git remote add origin git@github.com:vitormateusalmeida/bigbluebutton.git;
git remote add upstream git@github.com:bigbluebutton/bigbluebutton.git;

printf "\n\n${LGREEN}==== Login into container: ssh bbb@127.0.0.1 -p 9922${NC}\n";
printf "\n\n${LGREEN}==== Util:${NC}\n";
printf "${LGREEN}==== sudo bbb-conf -- clean; sudo systemctl disable bbb-html5.service; sudo systemctl stop bbb-html5.service; cd ~/dev/bigbluebutton/bigbluebutton-html5; npm install; meteor npm install; npm install;${NC}\n";


printf "\n\n${LGREEN}Done!${NC}\n";
