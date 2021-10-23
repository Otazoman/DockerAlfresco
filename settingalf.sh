#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo '*** start setting user and directory ****'

sudo useradd -u 33007 solr
mkdir data logs
mkdir data/postgres-data
sudo chown -R 999 data/postgres-data
mkdir data/solr-data
sudo chown -R 33007 data/solr-data
mkdir logs/postgres
sudo chown -R 999 logs/postgres

echo '**** setting fonts ****'

sudo apt install -y fonts-ipafont fonts-ipaexfont
mkdir libreoffice-fonts-data
sudo cp /usr/share/fonts/opentype/ipafont-gothic/ipag.ttf $SCRIPT_DIR/libreoffice-fonts-data
sudo cp /usr/share/fonts/opentype/ipafont-gothic/ipagp.ttf $SCRIPT_DIR/libreoffice-fonts-data
sudo cp /usr/share/fonts/opentype/ipafont-mincho/ipam.ttf $SCRIPT_DIR/libreoffice-fonts-data
sudo cp /usr/share/fonts/opentype/ipafont-mincho/ipamp.ttf $SCRIPT_DIR/libreoffice-fonts-data

echo '**** setting end!! ****'
