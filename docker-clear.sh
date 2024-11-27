#!/bin/sh

sudo docker stop $(sudo docker ps -q);
yes | sudo docker container prune; 

sudo docker volume rm wordpress_data
sudo docker volume rm mariadb_data
sudo docker volume create mariadb_data
sudo docker volume create wordpress_data
sudo chown -R 1000:1000 /var/lib/docker/volumes/wordpress_data

sudo docker build -t nginx nginx
sudo docker build -t mariadb mariadb
sudo docker build -t wordpress wordpress


