FROM alpine:3.19

# Environment variables for MariaDB version and other configurations
ENV MARIADB_VERSION=10.6

# Install MariaDB and its prerequisites
RUN set -x \
    && apk add --no-cache \
        mariadb=10.11.6-r0 \
        mariadb-client=10.11.6-r0 \
        mariadb-server-utils=10.11.6-r0 \
        openssl \
        bash \
        curl \
        ca-certificates \
    && mkdir -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld

ARG MYSQL_ROOT_PASSWORD
ENV MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

# Expose MariaDB default port
EXPOSE 3306

# Command to initialize MariaDB data directory and start the server
CMD ["sh", "-c", "mariadb-install-db --user=mysql --datadir=/var/lib/mysql && exec mysqld --user=mysql --datadir=/var/lib/mysql"]

