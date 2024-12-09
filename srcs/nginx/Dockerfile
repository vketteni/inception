# Use a lightweight base image for better security and performance
FROM alpine:3.19

# Set a non-root user as the default early to avoid running unnecessary commands as root
ARG USERNAME=vketteni
ARG USER_UID=1000
ARG USER_GID=1000

# Install required dependencies
RUN apk add --no-cache \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre2-dev \
    zlib-dev \
    linux-headers \
    curl \
    gd-dev

# Define NGINX version for reproducible builds
ENV NGINX_VERSION=1.27.2

# Download, build, and install NGINX
RUN curl -fSL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx.tar.gz \
    && tar -xvzf nginx.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_gzip_static_module \
        --with-pcre-jit \
        --with-threads \
    && make \
    && make install \
    && rm -rf /nginx-${NGINX_VERSION} nginx.tar.gz

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
#COPY conf.d/nginx.conf /etc/nginx/conf.d/nginx.conf

# Create required directories with appropriate permissions
RUN mkdir -p /var/log/nginx /var/cache/nginx/client_temp \
    && chmod -R 755 /var/cache/nginx \
    && chown -R ${USER_UID}:${USER_GID} /var/log/nginx /var/cache/nginx /etc/nginx

# Create and set a non-root user
RUN adduser -D -u ${USER_UID} -g ${USER_GID} ${USERNAME}
USER ${USERNAME}

# Expose necessary port
EXPOSE 443

# Use a secure entrypoint
CMD ["nginx", "-g", "daemon off;"]

