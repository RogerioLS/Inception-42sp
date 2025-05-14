#!/bin/sh

/etc/init.d/mariadb start

sleep 3;

mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "
    ALTER USER 'root'@'localhost' IDENTIFIED BY '"${MYSQL_ROOT_PASSWORD}"';
    CREATE DATABASE IF NOT EXISTS WordPress; 

    CREATE ROLE IF NOT EXISTS developer; 
    GRANT ALL PRIVILEGES ON WordPress.* TO developer; 

    CREATE USER IF NOT EXISTS '"${MYSQL_USER}"'@'%';
    ALTER USER '"${MYSQL_USER}"'@'%' IDENTIFIED BY '"${MYSQL_PASSWORD}"';
    GRANT 'developer' TO '"${MYSQL_USER}"'@'%'; 

    CREATE USER IF NOT EXISTS '"${MYSQL_USER}"'@'localhost';
    ALTER USER '"${MYSQL_USER}"'@'localhost' IDENTIFIED BY '"${MYSQL_PASSWORD}"';
    GRANT 'developer' TO '"${MYSQL_USER}"'@'localhost'; 

    SET DEFAULT ROLE 'developer' FOR '"${MYSQL_USER}"'@'%';
    SET DEFAULT ROLE 'developer' FOR '"${MYSQL_USER}"'@'localhost';

    FLUSH PRIVILEGES;
"

sleep 3;

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown;

mariadbd-safe;