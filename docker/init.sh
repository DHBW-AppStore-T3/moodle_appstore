#!/bin/sh
# Install Moodle into an empty database on the first start, upgrade it on
# later ones (a new image with a newer version.php). Run as an init container
# of the single web pod, so nothing else touches the database meanwhile.
set -eu
cd /var/www/html
mkdir -p /tmp/moodle-temp

: "${MOODLE_ADMIN_PASSWORD:?MOODLE_ADMIN_PASSWORD is required}"
: "${MOODLE_WWWROOT:?MOODLE_WWWROOT is required}"

echo "init: waiting for the database"
tries=0
while :; do
  rc=0; php /usr/local/bin/is-installed.php || rc=$?
  [ "$rc" -ne 2 ] && break
  tries=$((tries + 1))
  [ "$tries" -lt 60 ] || { echo "init: database not reachable" >&2; exit 1; }
  sleep 5
done

if [ "$rc" -eq 1 ]; then
  echo "init: empty database, installing Moodle"
  php admin/cli/install_database.php --agree-license --lang=en \
    --fullname="${MOODLE_SITE_NAME:-DHBW AppStore Moodle}" --shortname="${MOODLE_SITE_SHORTNAME:-moodle}" \
    --adminuser="${MOODLE_ADMIN_USER:-admin}" --adminpass="$MOODLE_ADMIN_PASSWORD" \
    --adminemail="${MOODLE_ADMIN_EMAIL:-admin@example.org}"
else
  echo "init: database installed, upgrading if needed"
  # --allow-unstable: this fork follows Moodle's development branch.
  php admin/cli/upgrade.php --non-interactive --allow-unstable
fi
echo "init: done"
