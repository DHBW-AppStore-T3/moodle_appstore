# Handover — moodle_appstore

Lebendes Übergabedokument gemäß [HARNESS.md](https://github.com/DHBW-AppStore-T3/.github/blob/main/docs/HARNESS.md) Abschnitt 1.2.
Jede Session liest dieses Dokument zu Beginn und aktualisiert es vor dem Abschluss.

---

## 1. Status & Fokus
- **Stack:** PHP, Moodle Core (Fork von `leamar1e/moodle_appstore` basierend auf `moodle/moodle`).
- **Rolle:** Integrationsziel für Moodle- und LTI-Funktionalitäten (AppStore als externes LTI-Tool in Moodle einbinden).
- **Aktueller Stand:** IPv6-Fixes für Host-Header-Parsing (`setuplib.php`) und URL-Validierung (`validateUrlSyntax()`) sind implementiert und gemergt (#3, #4).
- **Verhältnis zum Dev-Stack:** Das schlanke Docker-Setup für lokale Moodle-Tests liegt im `deployment`-Repo (`docker-compose.moodle.yml`).

---

## 2. In Arbeit & Nächste Schritte
- [ ] LTI-Tool-Konfiguration und Endpunkte im AppStore definieren.
- [ ] Integrationstests zwischen Moodle-Container und AppStore-Backend (Rollenübergabe, SSO/Auth).

---

## 3. Bekannte Fallstricke & Blocker
1. **Repo-Größe:** Vollständiger Moodle-Core-Fork (>60.000 Dateien) — Git-Operationen dauern ohne Sparse-Checkout oder Index-Caching spürbar länger.
2. **IPv6-Literale:** Müssen in URLs und Host-Headern in eckige Klammern gesetzt werden (`[::1]`), um nicht mit Port-Trennzeichen zu kollidieren (bereits in #3/#4 gefixt).

---

## 4. Letzte Übergaben (Historie)
- **2026-09-18:** `claude_docs/HANDOVER.md` angelegt und `CLAUDE.md` aktualisiert (Harness System 1.2).
- **2026-09-17:** IPv6 HTTP_HOST Parsing und URL Syntax Validierungs-Fixes gemergt (#3, #4).
- **2026-09-16:** Flache `claude_docs/`-Basisstruktur (`architecture.md`, `decisions.md`) initial aufgesetzt (#2).
