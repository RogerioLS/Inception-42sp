FROM debian:oldstable

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY ./tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    mkdir -p /etc/nginx/ssl && \
    chmod 700 /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ssl.key \
    -out /etc/nginx/ssl/ssl.crt \
    -subj "/C=BR/ST=SP/L=SP/O=42/OU=42/CN=roglopes.42.fr"

ENV CERT_PATH="/etc/nginx/ssl/ssl.crt"
ENV KEY_PATH="/etc/nginx/ssl/ssl.key"

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]