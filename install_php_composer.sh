#!/bin/sh

LGREEN='\033[1;32m'
NC='\033[0m'

printf "${LGREEN}==== Update packages${NC}\n";
sudo apt-get update -qq &&

if ! [ -x "$(command -v php --v)" ]; then
  printf "${LGREEN}==== Install PHP${NC}\n";
  sudo apt-get install php
fi &&

if ! [ -x "$(command -v curl --V)" ]; then
  printf "${LGREEN}==== Install curl${NC}\n" &&
  sudo apt-get install curl -qq
fi &&

if ! [ -x "$(command -v composer -V)" ]; then
  printf "${LGREEN}==== Geting the composer${NC}\n" &&
  sudo curl -sqq https://getcomposer.org/installer | php &&
  sudo mv composer.phar /usr/local/bin/composer
fi &&

printf "${LGREEN}==== Test composer installation${NC}\n" &&
composer -V

printf "\n\n${LGREEN}Done!${NC}\n";
