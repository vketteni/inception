FROM alpine:3.19

# Install MariaDB and prerequisites
RUN set -x \
    && apk add --no-cache \
        mariadb \
        mariadb-client \
        mariadb-server-utils \
        bash \
        curl \
        ca-certificates \
    && mkdir -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Add custom entrypoint script
COPY init-mariadb.sh /usr/local/bin/init-mariadb.sh
RUN chmod +x /usr/local/bin/init-mariadb.sh

# Configure MariaDB to listen on all interfaces
RUN echo -e "[mysqld]\nbind-address=0.0.0.0\n" > /etc/my.cnf.d/bind-address.cnf
RUN echo -e "[mysqld]\nbind-address=0.0.0.0" > /etc/my.cnf
RUN echo -e "port=3306\n" >> /etc/my.cnf

# Expose MariaDB port
EXPOSE 3306

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/init-mariadb.sh"]
