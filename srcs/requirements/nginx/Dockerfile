FROM debian:oldstable

RUN apt-get update && apt-get install -y nginx openssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod -R 755 /srv/ && chmod +x /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/ssl && \ 
    chmod 700 /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ssl.key \
    -out /etc/nginx/ssl/ssl.crt \
    -subj "/C=BR/ST=SP/L=SP/O=42/OU=42/CN=roglopes.42.fr"  

EXPOSE 443

ENTRYPOINT ["nginx"]

CMD ["-g", "daemon off;"]