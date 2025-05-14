# Use the official MariaDB base image from Debian
FROM debian:oldstable

# Install MariaDB Server
RUN apt-get update && apt-get install -y mariadb-server

# Set permissions for MariaDB directories
RUN chown -R mysql:mysql /var/lib/mysql && chmod -R 755 /var/lib/mysql

# Copy initialization script
COPY ./tools/dbscript.sh /usr/local/bin/dbscript.sh

# Copy custom configuration file
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Make the initialization script executable
RUN chmod +x /usr/local/bin/dbscript.sh

# Set the entrypoint to the initialization script
ENTRYPOINT ["/usr/local/bin/dbscript.sh"]