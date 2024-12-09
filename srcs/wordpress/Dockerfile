# Base image
FROM alpine:3.19 AS builder

ENV WORDPRESS_VERSION=6.3.1
ENV WORDPRESS_PATH=/usr/src/wordpress

# Install dependencies for extraction
RUN apk add --no-cache curl tar

# Create WordPress directory and download WordPress
RUN mkdir -p $WORDPRESS_PATH && \
    curl -fsSL -o /tmp/wordpress.tar.gz https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz --strip-components=1 -C $WORDPRESS_PATH && \
    rm /tmp/wordpress.tar.gz


# Set ownership and permissions
RUN chown -R 1000:1000 $WORDPRESS_PATH && chmod -R 755 $WORDPRESS_PATH

# Final image
FROM alpine:3.19

# Add custom entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/



# Copy wp-config.php and set permissions
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh



# Set the custom entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

ENV WORDPRESS_PATH=/var/www/html

# Install runtime dependencies
RUN apk add --no-cache \
    php81 php81-fpm php81-mysqli php81-curl php81-json php81-mbstring php81-xml php81-gd php81-zip php81-opcache bash curl


# Copy WordPress files from builder
 COPY --from=builder /usr/src/wordpress /usr/src/wordpress

# Ensure /var/www/html has correct permissions
RUN mkdir -p /var/www/html && \
    chown -R 1000:1000 /var/www/html && \
    chmod -R 755 /var/www/html

# Configure PHP-FPM
RUN mkdir -p /var/log/php81 /run/php-fpm && \
    chown -R 1000:1000 /var/log/php81 /run/php-fpm && \
    echo "cgi.fix_pathinfo=0" >> /etc/php81/php.ini && \
    echo "listen = 0.0.0.0:9000" >> /etc/php81/php-fpm.d/www.conf && \
    echo "clear_env = no" >> /etc/php81/php-fpm.d/www.conf


# Set non-root user
USER 1000

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm81", "-F"]

