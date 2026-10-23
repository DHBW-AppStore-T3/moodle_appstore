#!/bin/sh
# Apache in the foreground; its runtime directory lives on the /tmp volume.
set -eu
mkdir -p /tmp/apache2
exec apache2-foreground
