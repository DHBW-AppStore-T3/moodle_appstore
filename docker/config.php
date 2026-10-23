<?php
// Moodle configuration of the container image: everything comes from the
// environment (the Kubernetes chart sets it; the secrets from Secrets).
// Not committed as config.php: that name is git-ignored in this repository.

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'pgsql';
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('MOODLE_DB_HOST') ?: 'postgres-cluster-rw';
$CFG->dbname    = getenv('MOODLE_DB_NAME') ?: 'moodle';
$CFG->dbuser    = getenv('MOODLE_DB_USER') ?: 'moodle';
$CFG->dbpass    = (string) getenv('MOODLE_DB_PASSWORD');
$CFG->prefix    = 'mdl_';
$CFG->dboptions = [
    'dbpersist' => false,
    'dbsocket'  => false,
    'dbport'    => getenv('MOODLE_DB_PORT') ?: '5432',
    'sslmode'   => getenv('MOODLE_DB_SSLMODE') ?: 'require',
];

$CFG->wwwroot   = rtrim((string) getenv('MOODLE_WWWROOT'), '/');
$CFG->dataroot  = getenv('MOODLE_DATAROOT') ?: '/var/www/moodledata';
$CFG->localcachedir = getenv('MOODLE_LOCALCACHEDIR') ?: '/var/www/localcache';
$CFG->tempdir   = getenv('MOODLE_TEMPDIR') ?: '/tmp/moodle-temp';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 02770;
$CFG->pathtophp = '/usr/local/bin/php';

// TLS ends at the ingress controller: Moodle must see itself as https.
$CFG->sslproxy = true;
// The code is read-only: no plugin installs or updates from the web UI.
$CFG->disableupdateautodeploy = true;

require_once(__DIR__ . '/lib/setup.php'); // Do not edit

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
