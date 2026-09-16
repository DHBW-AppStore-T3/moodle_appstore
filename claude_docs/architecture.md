# moodle_appstore — Architektur

Vollständiger Moodle-Core-Fork (`moodle/moodle` → `leamar1e/moodle_appstore`
→ `DHBW-AppStore-T3/moodle_appstore`), nicht ein schlankes
Integrations-Repo. Stand 2026-09-15: **keine eigenen Commits
gegenüber `leamar1e/moodle_appstore`** — reiner Fork ohne
DHBW-AppStore-spezifische Änderungen bisher.

## Verhältnis zum lokalen `moodle/`-Dev-Stack

Das separate `moodle/`-Verzeichnis in `deployment` (bzw. lokal im
AppStore-Projekt) ist ein **eigenständiger, schlanker Docker-Build**
(`moodlehq/moodle-php-apache`-Basis + eigenes Entrypoint-Skript), der
den offiziellen `moodle/moodle`-Mirror bei Bedarf frisch klont — **kein**
direkter Bezug zu diesem Fork-Repo. Dieser Fork
(`moodle_appstore`) existiert als Ziel für zukünftige
LTI-Integrationsarbeit, falls direkte Code-Änderungen am Moodle-Core
nötig werden, die über Plugin-Mechanismen hinausgehen.

## Wann dieses Repo tatsächlich relevant wird

Sobald echte LTI-Integrationsarbeit beginnt (AppStore als externes
Tool in Moodle-Kursen einbinden), gehört hierher: welche
Moodle-Core-Dateien angepasst wurden (idealerweise keine — Moodle
bevorzugt Plugin-basierte Erweiterung), welche Plugins installiert
sind, welche Moodle-Version/Branch als Basis dient
(`MOODLE_405_STABLE`, siehe `moodle/Dockerfile` im `deployment`-Repo).

Bis dahin: dieses Repo ist ein vorbereiteter Platzhalter, kein aktiv
weiterentwickelter Service.
