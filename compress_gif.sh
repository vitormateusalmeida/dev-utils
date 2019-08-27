#!/bin/bash

LGREEN='\033[1;32m'
NC='\033[0m'

if ! [ -x "$(command -v gifsicle --help)" ]; then
  printf "${LGREEN}Installing gifsicle... ${NC}\n";
  sudo apt-get update -yq && sudo apt-get install gifsicle -yq >&2
fi

printf "${LGREEN}Nome/Caminho do arquivo gif: ${NC}";
read archive
printf "\n";
printf "${LGREEN}Escala(0.5): ${NC}";
read scale
printf "\n";
printf "${LGREEN}Nome/Caminho do arquivo gif comprimido: ${NC}";
read newarchive
printf "\n";
printf "${LGREEN}Executando gifsicle ... ${NC}";
gifsicle -i $archive --optimize=3 --scale=${scale:=0.5} -o $newarchive && 

printf "\n\n${LGREEN}Done!${NC}\n";
