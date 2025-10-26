# Workflow Migration zwischen Macs

**Ziel:** Workflows vom Original-Mac auf neuen Mac übertragen
**Zeitaufwand:** ~15-30 Minuten
**Voraussetzungen:** n8n auf beiden Macs installiert

---

## 📋 Übersicht

Diese Anleitung zeigt dir, wie du:
1. **Workflows exportierst** (Original-Mac)
2. **Workflows importierst** (Neuer Mac)
3. **Credentials migrierst** (sicher!)
4. **Custom Nodes überträgst**
5. **Regelmäßige Synchronisation** einrichtest

---

## 🎯 Migrations-Strategie

### Option 1: Export/Import via CLI (Empfohlen)
✅ Schnell und vollständig
✅ Enthält alle Workflow-Daten
⚠️ Credentials müssen separat übertragen werden

### Option 2: Git-basiert (Für kontinuierliche Entwicklung)
✅ Versionskontrolle
✅ Einfache Synchronisation
⚠️ Erfordert Git-Setup

### Option 3: Datenbank-Migration (Für komplettes Setup)
✅ Enthält alles (Workflows, Credentials, Historie)
⚠️ Komplexer, nur bei Vollmigration

---

## 🚀 Methode 1: CLI Export/Import (Empfohlen)

### Schritt 1: Workflows exportieren (Original-Mac)

#### 1.1 Alle Workflows exportieren

```bash
# Im n8n-Verzeichnis
cd ~/n8n

# Alle Workflows in eine Datei exportieren
docker exec threema_n8n n8n export:workflow --all --output=/home/node/.n8n/workflows_export.json

# Datei aus Container kopieren
docker cp threema_n8n:/home/node/.n8n/workflows_export.json ~/n8n/workflows_export.json
```

#### 1.2 Einzelne Workflows exportieren

```bash
# Liste aller Workflows anzeigen
docker exec threema_n8n n8n list:workflow

# Einzelnen Workflow exportieren (per ID)
docker exec threema_n8n n8n export:workflow --id=123 --output=/home/node/.n8n/workflow_123.json
```

#### 1.3 Workflow-Dateien sichern

```bash
# Auf externes Volume kopieren
cp ~/n8n/workflows_export.json /Volumes/iQ_BERENT/1_Projekte/n8n/backups/workflows/

# ODER: Auf USB-Stick
cp ~/n8n/workflows_export.json /Volumes/USB-STICK/n8n-backup/

# ODER: Zu GitHub hochladen (OHNE Credentials!)
cd ~/n8n-workflows/
cp ~/n8n/workflows_export.json .
git add workflows_export.json
git commit -m "Workflow backup $(date +%Y%m%d)"
git push
```

---

### Schritt 2: Workflows importieren (Neuer Mac)

#### 2.1 Workflow-Datei auf neuen Mac übertragen

```bash
# Von externem Volume
cp /Volumes/iQ_BERENT/1_Projekte/n8n/backups/workflows/workflows_export.json ~/n8n/

# ODER: Von GitHub
cd ~/n8n-workflows/
git pull
cp workflows_export.json ~/n8n/

# ODER: Via scp/AirDrop/USB
```

#### 2.2 Workflows importieren

```bash
cd ~/n8n

# In Container kopieren
docker cp workflows_export.json threema_n8n:/home/node/.n8n/

# Importieren
docker exec threema_n8n n8n import:workflow --input=/home/node/.n8n/workflows_export.json
```

#### 2.3 Import verifizieren

```bash
# Workflow-Liste anzeigen
docker exec threema_n8n n8n list:workflow

# n8n-Editor öffnen
open http://localhost:5678
```

Prüfe im Editor:
- Alle Workflows vorhanden?
- Workflow-Namen korrekt?
- Verbindungen zwischen Nodes intakt?

---

## 🔐 Schritt 3: Credentials migrieren

### ⚠️ WICHTIG: Sicherheit

Credentials enthalten sensitive Daten (API-Keys, Passwörter)!
- **NIEMALS** in Git committen
- Verschlüsselt übertragen
- Auf neuem Mac neu eingeben (sicherer)

### 3.1 Credentials-Liste exportieren (OHNE Werte)

```bash
# Zeigt nur die Namen der Credentials
docker exec threema_n8n n8n list:credentials
```

Beispiel-Ausgabe:
```
- OpenAI Credentials (id: 1)
- Gmail OAuth2 (id: 2)
- Threema Gateway (id: 3)
```

### 3.2 Credentials manuell auf neuem Mac anlegen

Im n8n-Editor:
1. **Settings → Credentials**
2. Für jedes Credential:
   - Klick auf **"Add Credential"**
   - Typ auswählen (z.B. "OpenAI API")
   - Werte aus sicherem Passwort-Manager eintragen
   - **Save**

### 3.3 Credentials automatisch exportieren (Verschlüsselt)

```bash
# Credentials exportieren (VORSICHT: Enthält sensible Daten!)
docker exec threema_n8n n8n export:credentials --all --output=/home/node/.n8n/credentials_export.json

# Datei verschlüsseln
docker cp threema_n8n:/home/node/.n8n/credentials_export.json ~/n8n/
openssl enc -aes-256-cbc -salt -in ~/n8n/credentials_export.json -out ~/n8n/credentials_export.json.enc

# Verschlüsselte Datei übertragen
# Original LÖSCHEN
rm ~/n8n/credentials_export.json
```

### 3.4 Credentials importieren (Entschlüsseln)

```bash
# Auf neuem Mac: Entschlüsseln
openssl enc -aes-256-cbc -d -in credentials_export.json.enc -out credentials_export.json

# In Container kopieren
docker cp credentials_export.json threema_n8n:/home/node/.n8n/

# Importieren
docker exec threema_n8n n8n import:credentials --input=/home/node/.n8n/credentials_export.json

# Datei SOFORT löschen
rm credentials_export.json
```

---

## 🔧 Schritt 4: Custom Nodes übertragen

### 4.1 Custom Nodes identifizieren (Original-Mac)

```bash
cd ~/n8n
ls -la custom_nodes/

# ODER: Prüfen ob package.json existiert
ls -la nodes/package.json
```

### 4.2 Custom Nodes kopieren

```bash
# Auf externem Volume sichern
cp -r ~/n8n/custom_nodes /Volumes/iQ_BERENT/1_Projekte/n8n/backups/custom_nodes_backup/

# ODER: In Git-Repository
cd ~/n8n-workflows
mkdir -p custom_nodes_export
cp -r ~/n8n/custom_nodes/* custom_nodes_export/
git add custom_nodes_export/
git commit -m "Custom nodes backup"
git push
```

### 4.3 Custom Nodes auf neuem Mac installieren

```bash
# Vom Backup
cp -r /Volumes/iQ_BERENT/1_Projekte/n8n/backups/custom_nodes_backup/* ~/n8n/custom_nodes/

# ODER: Von Git
cd ~/n8n-workflows
git pull
cp -r custom_nodes_export/* ~/n8n/custom_nodes/

# Container neu starten
cd ~/n8n
docker-compose restart n8n
```

### 4.4 Custom Nodes verifizieren

```bash
# Logs prüfen
docker logs threema_n8n | grep -i "custom"

# Im n8n-Editor
# Settings → Community Nodes → sollte Custom Nodes auflisten
```

---

## 🔄 Methode 2: Git-basierte Synchronisation

### Vorteile
- Kontinuierliche Synchronisation
- Versionskontrolle
- Einfaches Rollback

### Setup auf Original-Mac

```bash
cd ~/n8n-workflows

# Git-Repository initialisieren (falls noch nicht geschehen)
git init
git remote add origin https://github.com/[USERNAME]/n8n-workflows.git

# .gitignore erstellen
cat > .gitignore << 'EOF'
# Keine Credentials!
**/credentials*.json
**/.env
**/secrets/

# Keine großen Binärdateien
*.zip
*.tar.gz
EOF

# Workflows regelmäßig committen
cp ~/n8n/workflows/* ~/n8n-workflows/workflows/
git add workflows/
git commit -m "Update workflows $(date +%Y%m%d)"
git push
```

### Synchronisation auf neuem Mac

```bash
cd ~/n8n-workflows
git pull

# Workflows kopieren
cp -r workflows/* ~/n8n/workflows/

# n8n neu laden
docker-compose restart n8n
```

---

## 🗄️ Methode 3: Vollständige Datenbank-Migration

### Nur für komplette Systemmigration!

#### Schritt 1: PostgreSQL Dump erstellen (Original-Mac)

```bash
cd ~/n8n

# Datenbank-Dump
docker exec threema_postgres pg_dump -U n8n_user -d threema_db -F c -f /tmp/n8n_dump.backup

# Aus Container kopieren
docker cp threema_postgres:/tmp/n8n_dump.backup ~/n8n/

# Auf externes Volume sichern
cp ~/n8n/n8n_dump.backup /Volumes/iQ_BERENT/1_Projekte/n8n/backups/database/
```

#### Schritt 2: Datenbank wiederherstellen (Neuer Mac)

```bash
# ACHTUNG: Überschreibt alle Daten!

cd ~/n8n

# In Container kopieren
docker cp /Volumes/iQ_BERENT/1_Projekte/n8n/backups/database/n8n_dump.backup threema_postgres:/tmp/

# Alte Datenbank löschen
docker exec threema_postgres dropdb -U n8n_user threema_db
docker exec threema_postgres createdb -U n8n_user threema_db

# Dump wiederherstellen
docker exec threema_postgres pg_restore -U n8n_user -d threema_db -F c /tmp/n8n_dump.backup

# n8n neu starten
docker-compose restart n8n
```

---

## ⚙️ Schritt 5: Workflow-Einstellungen anpassen

### Auf neuem Mac überprüfen/ändern:

#### 5.1 Webhook-URLs

Falls sich der Hostname geändert hat:
```bash
# In .env
WEBHOOK_URL=http://localhost:5678
# ODER für produktiv
WEBHOOK_URL=https://dein-hostname.de
```

Container neu starten nach Änderung!

#### 5.2 Cron-Schedules

Timezone prüfen:
```bash
# Im n8n-Editor: Settings → General → Timezone
# Auf beiden Macs identisch setzen!
```

#### 5.3 Externe Integrations

- Webhook-URLs bei externen Services aktualisieren
- OAuth-Callbacks anpassen (falls Domain geändert)
- API-Endpoints verifizieren

---

## 🔁 Schritt 6: Regelmäßige Synchronisation einrichten

### Auto-Backup Skript (Original-Mac)

Siehe: [`assets/scripts/backup-workflows.sh`](../../assets/scripts/backup-workflows.sh)

```bash
# Crontab einrichten
crontab -e

# Täglich um 2 Uhr Workflows exportieren
0 2 * * * /Users/[USERNAME]/n8n/assets/scripts/backup-workflows.sh
```

### Auto-Sync Skript (Neuer Mac)

```bash
#!/bin/bash
# sync-workflows.sh

cd ~/n8n-workflows
git pull

# Workflows aktualisieren
if [ -f workflows_export.json ]; then
    docker cp workflows_export.json threema_n8n:/home/node/.n8n/
    docker exec threema_n8n n8n import:workflow --input=/home/node/.n8n/workflows_export.json --separate
    echo "Workflows synchronized at $(date)"
fi
```

Crontab:
```bash
# Täglich um 3 Uhr synchronisieren
0 3 * * * /Users/[USERNAME]/n8n/assets/scripts/sync-workflows.sh >> ~/n8n/logs/sync.log 2>&1
```

---

## ✅ Verifizierung

### Checkliste nach Migration

- [ ] Alle Workflows importiert
- [ ] Workflow-Namen korrekt
- [ ] Node-Verbindungen intakt
- [ ] Credentials neu erstellt/importiert
- [ ] Custom Nodes geladen
- [ ] Webhook-URLs aktualisiert
- [ ] Test-Workflows erfolgreich ausgeführt
- [ ] Cron-Schedules funktionieren
- [ ] Externe Integrationen funktionieren

### Test durchführen

1. **Einfachen Workflow testen:**
   - Schedule Trigger (manuell ausführen)
   - HTTP Request zu öffentlicher API
   - Sollte erfolgreich durchlaufen

2. **Workflow mit Credentials testen:**
   - Workflow mit API-Zugriff wählen
   - Ausführen und Erfolg prüfen

3. **Webhook-Workflow testen:**
   - Webhook-URL kopieren
   - Mit curl/Postman aufrufen
   - Sollte triggern und ausführen

---

## 🐛 Troubleshooting

### Workflow-Import schlägt fehl

```bash
# Einzeln importieren statt alle auf einmal
docker exec threema_n8n n8n import:workflow --input=/home/node/.n8n/workflows_export.json --separate
```

### Credentials fehlen

```bash
# Liste der benötigten Credentials
docker exec threema_n8n n8n list:workflow | grep "credentials"

# Manuell im Editor anlegen
```

### Workflows inactive nach Import

Im n8n-Editor:
- Workflow öffnen
- Oben rechts: **Activate** togglen
- Speichern

### Node-Fehler "Unknown node type"

```bash
# Custom Nodes fehlen - installieren
cp -r /backup/custom_nodes/* ~/n8n/custom_nodes/
docker-compose restart n8n
```

---

## 📚 Weiterführende Links

- [n8n Export/Import Docs](https://docs.n8n.io/workflows/export-import/)
- [n8n Credentials Docs](https://docs.n8n.io/credentials/)
- [Backup-Strategien](../../README.md#backup-strategie)

---

**Migrations-Anleitung Version:** 1.0
**Zuletzt aktualisiert:** 25. Oktober 2025
**Getestet auf:** n8n v1.116.2, macOS Sonoma


