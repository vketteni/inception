FROM alpine:3.19

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

ENV NGINX_VERSION=1.27.2

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
    && make install

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/nginx.conf /etc/nginx/conf.d/nginx.conf

RUN mkdir -p /var/cache/nginx/client_temp
RUN chmod -R 755 /var/cache/nginx

RUN rm -rf /var/cache/apk/* /tmp/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]




