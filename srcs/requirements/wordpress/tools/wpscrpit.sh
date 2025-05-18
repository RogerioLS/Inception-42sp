#!/bin/sh

sleep 10;
cd /srv/www/wordpress;

if [ ! -f wp-config.php ]; then
  echo "Generating wp-config.php file. Connecting to mysql database:";
  wp config create --dbname=WordPress --dbuser=$WORDPRESS_MYSQL_USER --dbpass=$WORDPRESS_MYSQL_PASSWORD --dbhost=$WORDPRESS_MYSQL_HOST --allow-root;

  if [ -f wp-config.php ]; then
    echo "wp-config.php generated succefully.";
  else
    echo "Generating wp-config.php failed. Check DB connection";
    exit 1;
  fi
else
  echo "wp-config.php file already exists";
fi

if ! wp core is-installed --allow-root; then
  echo "Installing wp core.";
  wp core install --url=$WORDPRESS_HOSTNAME --title="Roglope's Inception" --admin_user=$WORDPRESS_USER --admin_password=$WORDPRESS_PASSWORD --admin_email=$WORDPRESS_EMAIL --allow-root; 

  if wp core is-installed --allow-root; then
    echo "Wp core installed succefully.";
    wp user create $WORDPRESS_GUEST_USER $WORDPRESS_GUEST_EMAIL --role=author --user_pass=$WORDPRESS_GUEST_PASSWORD --allow-root;
  else
    echo "Wp core installation failed."
    exit 2;
  fi
else
  echo "wp core already installed";
fi

wp plugin update --all --allow-root;

sleep 10;

echo "Starting php-fpm..."

exec /usr/sbin/php-fpm7.4 -F