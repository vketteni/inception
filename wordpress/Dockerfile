FROM alpine:3.19

# Set environment variables
ENV WORDPRESS_VERSION=6.3.1
ENV WORDPRESS_PATH=/var/www/html

# Install dependencies
RUN apk add --no-cache \
    php81 php81-fpm php81-mysqli php81-curl php81-json php81-mbstring php81-xml php81-gd php81-zip php81-opcache \
    curl wget tar bash

# Create WordPress directory
RUN mkdir -p $WORDPRESS_PATH && \
    chown -R nobody:nobody $WORDPRESS_PATH

# Download and extract WordPress
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz --strip-components=1 -C $WORDPRESS_PATH && \
    rm /tmp/wordpress.tar.gz

# Set ownership and permissions
RUN chown -R nobody:nobody $WORDPRESS_PATH

RUN mkdir -p /var/log/php81 && \
chmod 755 /var/log/php81 && \
chown nobody:nobody /var/log/php81

# Configure PHP-FPM
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php81/php.ini && \
    echo "listen = 0.0.0.0:9000" >> /etc/php81/php-fpm.d/www.conf && \
    echo "clear_env = no" >> /etc/php81/php-fpm.d/www.conf && \
    mkdir -p /run/php-fpm && \
    chown -R nobody:nobody /run/php-fpm

# Switch to non-root user
USER nobody

# Expose port for PHP-FPM
EXPOSE 9000

# Entrypoint to start php-fpm
CMD ["php-fpm81", "-F"]

