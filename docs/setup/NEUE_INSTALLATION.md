# n8n Neue Installation - Komplette Anleitung

**Ziel:** Identische n8n-Installation auf einem neuen Mac erstellen
**Zeitaufwand:** ~30-45 Minuten
**Voraussetzungen:** Mac mit Apple Silicon (M1/M2/M3) oder Intel

---

## 📋 Übersicht

Diese Anleitung führt dich Schritt für Schritt durch die Installation von n8n mit Docker auf einem neuen Mac. Am Ende hast du ein identisches Setup wie auf dem Original-Mac.

---

## 🎯 Was wird installiert

- **OrbStack** - Leichtgewichtige Docker-Alternative (statt Docker Desktop)
- **n8n** - Version 1.116.2+ (via Docker)
- **PostgreSQL 15** - Datenbank
- **Redis 7** - Cache/Queue-System
- **Git** - Versionskontrolle

---

## 📦 Schritt 1: System vorbereiten

### 1.1 Xcode Command Line Tools installieren

```bash
xcode-select --install
```

Bestätige die Installation im Pop-up-Fenster.

### 1.2 Homebrew installieren (optional, aber empfohlen)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Nach der Installation, füge Homebrew zum PATH hinzu:

```bash
# Für Apple Silicon (M1/M2/M3)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Für Intel Macs
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

### 1.3 Git installieren

```bash
brew install git
```

Oder prüfen ob bereits installiert:
```bash
git --version
```

---

## 🐳 Schritt 2: OrbStack installieren

### 2.1 Download OrbStack

**Option A: Mit Homebrew**
```bash
brew install --cask orbstack
```

**Option B: Manueller Download**
1. Öffne: https://orbstack.dev/download
2. Lade die ARM64-Version herunter (für Apple Silicon)
3. Öffne die DMG-Datei
4. Ziehe OrbStack.app in den Programme-Ordner

### 2.2 OrbStack starten und konfigurieren

```bash
open -a OrbStack
```

- Beim ersten Start: Setup-Assistent folgen
- **Wichtig:** Docker-Kompatibilität aktivieren
- Empfohlene Einstellungen:
  - Memory: 4-6 GB
  - CPU: 4 Cores
  - Disk: 60 GB

### 2.3 Docker CLI verifizieren

```bash
# PATH aktualisieren (falls nötig)
echo 'export PATH="$HOME/.orbstack/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Docker testen
docker --version
docker-compose --version
```

**Erwartete Ausgabe:**
```
Docker version 28.3.3+
Docker Compose version v2.39.2+
```

---

## 📁 Schritt 3: n8n-Verzeichnis erstellen

### 3.1 Projektordner anlegen

```bash
mkdir -p ~/n8n
cd ~/n8n
```

### 3.2 GitHub-Repository klonen

```bash
# Wenn Repository bereits existiert:
git clone https://github.com/[DEIN-USERNAME]/n8n-setup.git temp
cp -r temp/config-templates/* ~/n8n/
rm -rf temp

# ODER: Dateien manuell kopieren von externem Volume/USB-Stick
```

---

## ⚙️ Schritt 4: Konfiguration anpassen

### 4.1 Umgebungsvariablen erstellen

```bash
cd ~/n8n
cp config-templates/env.template .env
```

### 4.2 .env bearbeiten

Öffne `.env` in einem Editor:

```bash
nano .env
# ODER
open -e .env
```

**Wichtige Werte anpassen:**

```bash
# Datenbank-Passwörter (NEUE sichere Passwörter generieren!)
POSTGRES_PASSWORD=dein_sicheres_passwort_hier

# Redis-Passwort
REDIS_PASSWORD=dein_redis_passwort_hier

# n8n Login-Credentials
N8N_AUTH_USER=dein_username
N8N_AUTH_PASSWORD=dein_sicheres_passwort

# Hostname (für neuen Mac anpassen)
N8N_HOST=localhost

# Webhook-URL
WEBHOOK_URL=http://localhost:5678

# API-Keys (falls benötigt)
THREEMA_GATEWAY_ID=*GATEWAY_ID*
THREEMA_GATEWAY_SECRET=*GATEWAY_SECRET*
AZURE_OPENAI_API_KEY=*API_KEY*
AZURE_OPENAI_ENDPOINT=https://your-endpoint.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4
```

**💡 Tipp:** Sichere Passwörter generieren:
```bash
openssl rand -base64 32
```

### 4.3 docker-compose.yml kopieren

```bash
cp config-templates/docker-compose.yml.template docker-compose.yml
```

**Optional:** Ports anpassen, falls bereits belegt:
- Standard: 5678 (n8n), 5432 (PostgreSQL), 6379 (Redis)

---

## 🚀 Schritt 5: n8n starten

### 5.1 Container starten

```bash
cd ~/n8n
docker-compose up -d
```

**Erwartete Ausgabe:**
```
Creating network "n8n_threema_network"...
Creating volume "n8n_postgres_data"...
Creating volume "n8n_redis_data"...
Creating volume "n8n_n8n_data"...
Creating threema_postgres...
Creating threema_redis...
Creating threema_n8n...
```

### 5.2 Status prüfen

```bash
docker-compose ps
```

Alle Container sollten **"healthy"** sein.

### 5.3 Logs prüfen

```bash
docker logs threema_n8n --tail 50
```

Suche nach:
```
Editor is now accessible via:
http://localhost:5678
```

---

## 🌐 Schritt 6: n8n aufrufen und einrichten

### 6.1 Browser öffnen

```bash
open http://localhost:5678
```

### 6.2 Erster Login

- **Benutzername:** Dein `N8N_AUTH_USER` aus .env
- **Passwort:** Dein `N8N_AUTH_PASSWORD` aus .env

### 6.3 Initiale Einrichtung

- Owner-Account erstellen (falls Erstes Setup)
- Timezone einstellen
- Optional: Telemetrie deaktivieren

---

## 📥 Schritt 7: Workflows importieren

Siehe separate Anleitung: [`WORKFLOW_MIGRATION.md`](./WORKFLOW_MIGRATION.md)

Kurzversion:
```bash
# Vom Original-Mac: Workflows exportieren
docker exec threema_n8n n8n export:workflow --all --output=/tmp/workflows.json

# Auf neuem Mac: Workflows importieren
docker exec threema_n8n n8n import:workflow --input=/tmp/workflows.json
```

---

## 🔧 Schritt 8: Custom Nodes installieren (falls vorhanden)

### 8.1 Custom Nodes kopieren

```bash
# Custom Nodes vom Backup/Git kopieren
cp -r /pfad/zu/backup/custom_nodes ~/n8n/custom_nodes/

# Container neu starten
docker-compose restart n8n
```

### 8.2 Verifizieren

Im n8n-Editor unter **Settings → Community Nodes** prüfen.

---

## ✅ Schritt 9: Installation verifizieren

### 9.1 Checkliste

- [ ] n8n läuft: http://localhost:5678
- [ ] Login funktioniert
- [ ] PostgreSQL verbunden (keine DB-Fehler in Logs)
- [ ] Redis verbunden
- [ ] Custom Nodes geladen (falls vorhanden)
- [ ] Workflows importiert (falls bereits vorhanden)
- [ ] Credentials konfiguriert

### 9.2 Test-Workflow erstellen

Erstelle einen einfachen Test-Workflow:
1. **Schedule Trigger** (1x pro Tag)
2. **HTTP Request** zu https://api.github.com/
3. **Set** Node mit aktuellem Timestamp

Speichern und manuell ausführen → sollte erfolgreich sein.

---

## 🔐 Schritt 10: Sicherheit & Backups

### 10.1 .env sichern

```bash
# Backup der .env (verschlüsselt!)
cp .env ~/.n8n-backup-env

# NICHT in Git committen!
echo ".env" >> .gitignore
```

### 10.2 Automatisches Backup einrichten

Siehe: [`assets/scripts/backup-workflows.sh`](../../assets/scripts/backup-workflows.sh)

Crontab-Eintrag erstellen:
```bash
crontab -e

# Täglich um 2 Uhr morgens
0 2 * * * /Users/[USERNAME]/n8n/assets/scripts/backup-workflows.sh
```

### 10.3 Firewall konfigurieren (Optional)

```bash
# n8n nur auf localhost zugänglich (Standard-Config)
# Falls öffentlich: Reverse-Proxy mit SSL verwenden (nginx/Caddy)
```

---

## 🐛 Troubleshooting

### Container startet nicht

```bash
# Logs prüfen
docker logs threema_n8n
docker logs threema_postgres

# Container neu erstellen
docker-compose down
docker-compose up -d
```

### Port bereits belegt

```bash
# Prüfen welcher Prozess Port 5678 nutzt
lsof -i :5678

# Port in docker-compose.yml ändern
# z.B. von "5678:5678" zu "5679:5678"
```

### PostgreSQL Verbindungsfehler

```bash
# PostgreSQL Health-Check
docker exec threema_postgres pg_isready -U n8n_user

# Passwort in .env prüfen
grep POSTGRES_PASSWORD .env
```

### OrbStack CLI funktioniert nicht

```bash
# PATH überprüfen
echo $PATH | grep orbstack

# Falls nicht vorhanden:
export PATH="$HOME/.orbstack/bin:$PATH"
echo 'export PATH="$HOME/.orbstack/bin:$PATH"' >> ~/.zshrc
```

---

## 📚 Weiterführende Dokumentation

- [Workflow Migration](./WORKFLOW_MIGRATION.md)
- [Backup-Strategien](../../README.md#backup-strategie)
- [n8n Offizielle Docs](https://docs.n8n.io)
- [OrbStack Dokumentation](https://docs.orbstack.dev)

---

## 🆘 Support

Bei Problemen:
1. Logs prüfen: `docker logs threema_n8n`
2. GitHub Issues: [Repository-Link]
3. n8n Community: https://community.n8n.io

---

**Installations-Anleitung Version:** 1.0
**Zuletzt aktualisiert:** 25. Oktober 2025
**Getestet auf:** macOS Sonoma 14.x, Apple Silicon M3


