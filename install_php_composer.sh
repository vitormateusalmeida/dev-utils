#!/bin/sh

echo "Update packages"
sudo apt-get update -qq &&

echo "Install curl" &&
sudo apt-get install curl -qq &&

echo "Geting the composer" &&
sudo curl -sqq https://getcomposer.org/installer | php &&
sudo mv composer.phar /usr/local/bin/composer &&

echo "Test composer installation" &&
composer
