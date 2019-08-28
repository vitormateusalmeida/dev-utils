#!/bin/bash

LGREEN='\033[1;32m'
NC='\033[0m'

if [ -f ~/.zshrc ]
  then
    if ! grep bash_aliases ~/.zshrc > /dev/null
      then
        if ! [ -f ~/.bash_aliases ]
          then
            sudo cp .bash_aliases ~/.bash_aliases
        fi &&
        echo "if [ -f ~/.bash_aliases ]; then; . ~/.bash_aliases; fi;" >> ~/.zshrc
    fi
  else
    printf "${LGREEN}zsh not installed!${NC}\n";
fi

printf "\n\n${LGREEN}Done!${NC}\n";


