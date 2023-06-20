set -xu;
# Start supervisor daemon / process manager
PATH="${PATH}" /usr/local/bin/supervisord -c /etc/supervisord.conf;
