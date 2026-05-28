#!/bin/sh
set -eu
while true; do
  php /var/www/html/admin.php clean_expired || true
  php /var/www/html/admin.php clean_async || true
  sleep "${CLEANUP_INTERVAL_SECONDS:-300}"
done
