<?php
// Exit code: 0 Moodle's tables exist, 1 empty database, 2 database unreachable.
$dsn = sprintf(
    "host='%s' port='%s' dbname='%s' user='%s' password='%s' sslmode='%s' connect_timeout=5",
    addcslashes(getenv('MOODLE_DB_HOST') ?: 'postgres-cluster-rw', "'\\"),
    addcslashes(getenv('MOODLE_DB_PORT') ?: '5432', "'\\"),
    addcslashes(getenv('MOODLE_DB_NAME') ?: 'moodle', "'\\"),
    addcslashes(getenv('MOODLE_DB_USER') ?: 'moodle', "'\\"),
    addcslashes((string) getenv('MOODLE_DB_PASSWORD'), "'\\"),
    addcslashes(getenv('MOODLE_DB_SSLMODE') ?: 'require', "'\\")
);
$conn = @pg_connect($dsn);
if (!$conn) {
    exit(2);
}
$result = pg_query($conn, "SELECT to_regclass('public.mdl_config')");
exit(pg_fetch_result($result, 0, 0) ? 0 : 1);
