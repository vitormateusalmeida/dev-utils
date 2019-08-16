#!/bin/bash

if ! [ -x "$(command -v gifsicle --help)" ]; then
  sudo apt-get update -yq && sudo apt-get install gifsicle -yq >&2
fi

echo -n "Nome/Caminho do arquivo gif: "
read archive
echo ""
echo -n "Escala(0.5): "
read scale
echo ""
echo -n "Nome/Caminho do arquivo gif comprimido: "
read newarchive
echo ""
echo "Executando gifsicle ..."
gifsicle -i $archive --optimize=3 --scale=${scale:=0.5} -o $newarchive && 
echo "Done!"
