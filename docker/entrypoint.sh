#!/bin/bash
set -e
cd /opt

# Fix permissions
chown -R 1000:1000 /var/lib/mysql

# Force mariaDb Restart
service mysql restart

# To confirm mysql socket
mysql -e '\s;' | grep 'UNIX socket:'

# Attempt to create database
rake db:create

# Attempt to run migrations
rake db:migrate

# Remove a potentially pre-existing server.pid for Rails.
rm -f /opt/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"