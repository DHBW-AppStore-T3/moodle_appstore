#!/bin/sh
# Apache in the foreground; its runtime files live on the /tmp volume (the root
# filesystem is read-only). Set via the environment because the Debian envvars
# file only takes these as defaults.
set -eu
mkdir -p /tmp/apache2
export APACHE_RUN_DIR=/tmp/apache2 APACHE_LOCK_DIR=/tmp/apache2 APACHE_PID_FILE=/tmp/apache2/apache2.pid
exec apache2-foreground
