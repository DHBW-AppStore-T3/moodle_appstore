# Entscheidungen

## Fork statt Submodule/Vendoring

`moodle_appstore` wurde als vollständiger GitHub-Fork angelegt statt
z. B. als Git-Submodule im `deployment`-Repo — erlaubt eigene
Branches/PRs gegen den Moodle-Core, falls das je nötig wird, ohne den
`deployment`-Repo-Verlauf mit Moodle-Core-Commits zu vermischen.

## Kein Merge mit `leamar1e/moodle_appstore` bisher nötig

Da noch keine eigenen Änderungen existieren, gibt es aktuell keinen
Divergenz-/Merge-Bedarf gegenüber dem Upstream-Fork. Sobald eigene
Commits entstehen, sollte periodisch gegen `leamar1e/moodle_appstore`
und/oder den offiziellen `moodle/moodle`-Mirror synchronisiert werden,
um nicht auf einem veralteten Moodle-Core-Stand hängen zu bleiben.
