#!/bin/bash

# Exit on errors
set -e

# Container and volume names
WORDPRESS_CONTAINER="wordpress"
NGINX_CONTAINER="nginx"
WORDPRESS_DATA_VOLUME="wordpress_data"

# Helper function to list directory contents inside a container
list_container_directory() {
  local container=$1
  local directory=$2
  echo "Listing contents of directory $directory in container $container:"
  docker exec $container sh -c "ls -l $directory"
  echo
}

# Helper function to list volume contents
list_volume_contents() {
  local volume=$1
  echo "Listing contents of Docker volume $volume:"
  docker run --rm -v $volume:/data alpine sh -c "ls -l /data"
  echo
}

# WordPress checks
if docker ps -a --format '{{.Names}}' | grep -q $WORDPRESS_CONTAINER; then
  echo "Checking WordPress container..."
  list_container_directory $WORDPRESS_CONTAINER "/var/www/html"
else
  echo "WordPress container not found. Skipping..."
fi

# WordPress data volume
if docker volume ls --format '{{.Name}}' | grep -q $WORDPRESS_DATA_VOLUME; then
  echo "Checking WordPress data volume..."
  list_volume_contents $WORDPRESS_DATA_VOLUME
else
  echo "WordPress data volume not found. Skipping..."
fi

# Nginx checks
if docker ps -a --format '{{.Names}}' | grep -q $NGINX_CONTAINER; then
  echo "Checking Nginx container..."
  list_container_directory $NGINX_CONTAINER "/var/www/html"
else
  echo "Nginx container not found. Skipping..."
fi

