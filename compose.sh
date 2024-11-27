#!/bin/sh

# Exit on errors and log all commands for debugging
set -e
set -x

# Define network
NETWORK_NAME="inception_network"


# Create Docker network if it doesn't already exist
if ! docker network ls | grep -q $NETWORK_NAME; then
  echo "Creating Docker network: $NETWORK_NAME"
  docker network create $NETWORK_NAME
fi

# Start MariaDB
MARIADB_CONTAINER="mariadb"
MARIADB_DATA_VOLUME="mariadb_data"
MARIADB_ENV_FILE="mariadb/.env"

if docker ps -a | grep -q $MARIADB_CONTAINER; then
  echo "Starting existing MariaDB container..."
  docker start $MARIADB_CONTAINER
else
  echo "Creating and starting MariaDB container..."
  docker run --detach \
      --name $MARIADB_CONTAINER \
      --network $NETWORK_NAME \
      --env-file $MARIADB_ENV_FILE \
      --mount source=$MARIADB_DATA_VOLUME,target=/var/lib/mysql \
      --health-cmd="mysqladmin ping --silent --user=root --password=${MYSQL_ROOT_PASSWORD}" \
      --health-interval=10s \
      --health-timeout=5s \
      --health-retries=3 \
      mariadb

fi

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until docker exec $MARIADB_CONTAINER mysqladmin ping --silent; do
  sleep 1
done
echo "MariaDB is ready."

# Start WordPress
WORDPRESS_CONTAINER="wordpress"
WORDPRESS_DATA_VOLUME="wordpress_data"
WORDPRESS_ENV_FILE="wordpress/.env"
WORDPRESS_PORT=9000

if docker ps -a | grep -q $WORDPRESS_CONTAINER; then
  echo "Starting existing WordPress container..."
  docker start $WORDPRESS_CONTAINER
else
  echo "Creating and starting WordPress container..."
  docker run --detach \
    --name $WORDPRESS_CONTAINER \
    --network $NETWORK_NAME \
    --env-file $WORDPRESS_ENV_FILE \
    --mount source=$WORDPRESS_DATA_VOLUME,target=/var/www/html \
    -p $WORDPRESS_PORT:$WORDPRESS_PORT \
    wordpress
fi

# Start Nginx
NGINX_CONTAINER="nginx"
NGINX_CONF_DIR="/home/vketteni/inception/nginx/conf.d"
NGINX_PORT=80

if docker ps -a | grep -q $NGINX_CONTAINER; then
  echo "Starting existing Nginx container..."
  docker start $NGINX_CONTAINER
else
  echo "Creating and starting Nginx container..."
  docker run --detach \
    --name $NGINX_CONTAINER \
    --network $NETWORK_NAME \
    --mount type=bind,source=$NGINX_CONF_DIR,target=/etc/nginx/conf.d \
    --mount source=$WORDPRESS_DATA_VOLUME,target=/var/www/html \
    -p $NGINX_PORT:$NGINX_PORT \
    nginx
fi

echo "All containers started successfully."

#sudo docker stop $(sudo docker ps -q);
#yes | sudo docker container prune; 
#
#sudo docker run --network inception_network --name mariadb --env-file mariadb/.env --mount source=mariadb_data,target=/var/lib/mysql mariadb & 
#sudo docker run --network inception_network --name wordpress -p 9000:9000 --env-file wordpress/.env --mount source=wordpress_data,target=/wordpress-data wordpress &
#sudo docker run --network inception_network --name nginx -p 80:80 --mount type=bind,source=/home/vketteni/inception/nginx/conf.d/,target=/etc/nginx/conf.d --mount source=wordpress_data,target=/var/www/html nginx &
#

