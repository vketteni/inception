#!/bin/bash
set -e

echo "LOG--"${MYSQL_DATABASE}

# Check if MariaDB has already been initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  echo "MariaDB data directory initialized."

  echo "Starting MariaDB for initialization..."
  mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
  pid="$!"

  echo "Waiting for MariaDB to start..."
  until mysqladmin ping --silent; do
    sleep 1
  done

  echo "Running initialization SQL..."
  mysql -u root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

  echo "MariaDB initialization complete."
  kill "$pid"
  wait "$pid"
fi

echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --port=3306

