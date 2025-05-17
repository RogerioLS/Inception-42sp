#!/bin/sh
set -e

# Substitui variáveis no template e gera o nginx.conf final
envsubst '$CERT_PATH $KEY_PATH' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Inicia o NGINX
exec nginx -g 'daemon off;'
