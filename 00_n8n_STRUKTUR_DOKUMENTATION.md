# n8n Struktur-Dokumentation

**Stand:** 25. Oktober 2025
**Erstellt nach:** Docker Desktop → OrbStack Migration

---

## 📁 Übersicht: Alle n8n-Verzeichnisse

### 1. Haupt-Arbeitsverzeichnis (PRODUKTIV)

**`/Users/kunkel/n8n/`** - 1.3 GB
```
Hauptprojekt mit vollständigem Docker-Setup
├── docker-compose.yml          # Container-Konfiguration (n8n, PostgreSQL, Redis)
├── .env                        # Umgebungsvariablen (Passwörter, API-Keys)
├── env.list                    # Backup der Umgebungsvariablen
├── init.sql                    # PostgreSQL Initialisierung
├── custom_nodes/               # Eigene n8n Nodes
├── workflows/                  # Workflow-Definitionen
│   ├── ai-agents/
│   ├── analysis/
│   ├── business/
│   └── communication/
├── modules/                    # Modulare Workflows
│   ├── belegchat/
│   ├── ki-avatare/
│   ├── linkedin-content/
│   ├── shared/
│   └── threema-gateway/
├── logs/                       # n8n Logs
├── binaryData/                 # Hochgeladene Dateien
└── backups/                    # Alte Backups
    └── docker-reset-backup-20250904_105615/

Status: ✅ Aktiv, Git-Repository
Docker Container:
  - n8n:latest (v1.116.2) auf Port 5678
  - postgres:15-alpine auf Port 5432
  - redis:7-alpine auf Port 6379
```

---

### 2. Workflow-Archiv

**`/Users/kunkel/n8n-workflows/`** - 3.8 MB
```
Separates Repository für Workflow-Backups und Dokumentation
├── backup.sh                   # Backup-Skript
├── backups/                    # Workflow-Backups
├── Claude Project System Prompt.pdf
├── Claude Prompt Guidelines.pdf
├── compiled-n8n-docs.docx      # Zusammengefasste Dokumentation
└── config

Status: ✅ Aktiv, Git-Repository
Zweck: Workflow-Versionierung, Dokumentation
```

---

### 3. Alte/Nicht mehr aktive Verzeichnisse

#### **`/Users/kunkel/.n8n/`** - 476 KB
```
Alte lokale n8n-Installation (SQLite-basiert)
├── database.sqlite             # Letzte Änderung: 15. August 2025
├── config
├── binaryData/
├── nodes/
└── n8nEventLog*.log

Status: ⚠️ Veraltet (nicht mehr aktiv seit Migration auf Docker)
Kann gelöscht werden: Ja (nach Prüfung der SQLite-DB auf alte Workflows)
```

#### **`/Users/kunkel/n8n-data/`** - 12 KB
```
Alter Test-Ordner mit einfachem Docker-Setup
├── docker-compose.simple.yml
└── threema-n8n-stack/

Status: ⚠️ Veraltet (ersetzt durch ~/n8n/)
Kann gelöscht werden: Ja
```

#### **`/Users/kunkel/Backup n8n-Workflows/`** - 0 B
```
Leerer Backup-Ordner

Status: ⚠️ Leer
Kann gelöscht werden: Ja
```

---

### 4. Externe Dokumentation/Downloads

#### **`/Users/kunkel/Downloads/n8n-docs-main/`**
```
Heruntergeladene n8n-Dokumentation

Status: ℹ️ Referenzmaterial
Kann archiviert werden: Nach /Volumes/iQ_BERENT/1_Projekte/n8n/docs/
```

---

## 🔄 Aktuelle Migration & Backups

### Migrations-Backup (25. Oktober 2025)

**`/Users/kunkel/n8n/backup-migration-20251025_183343/`**
```
Vollständiges Backup bei Docker Desktop → OrbStack Migration
├── docker-compose.yml
├── .env                        # WICHTIG: Enthält alle Passwörter!
├── env.list
├── init.sql
└── MIGRATION_INFO.txt

Status: ✅ Sicherheitskopie
Zweck: Rollback bei Problemen
Aufbewahrung: Bis erfolgreicher Betrieb bestätigt
```

---

## 🗄️ Zentrale Dokumentation (Externes Volume)

**`/Volumes/iQ_BERENT/1_Projekte/n8n/`**
```
Neuer zentraler Dokumentations- und Backup-Speicherort
├── n8n_Migration_Doku/
│   ├── DOCKER_MIGRATION_PLAN.md
│   └── MIGRATION_SUCCESS.md
├── 00_n8n_STRUKTUR_DOKUMENTATION.md (diese Datei)
└── [zukünftig: Workflow-Backups, Dokumentationen]

Status: ✅ Neue zentrale Ablage
Zweck: Langzeitarchivierung, Dokumentation
```

---

## 🎯 Empfohlene Struktur für externes Volume

### Vorgeschlagene Ordnerstruktur:

```
/Volumes/iQ_BERENT/1_Projekte/n8n/
├── 00_n8n_STRUKTUR_DOKUMENTATION.md
├── docs/                           # Alle Dokumentationen
│   ├── migration/                  # Migrations-Dokumentation
│   ├── setup/                      # Setup-Anleitungen
│   ├── workflows/                  # Workflow-Dokumentation
│   └── reference/                  # Referenzmaterial (n8n-docs)
├── backups/                        # Regelmäßige Backups
│   ├── workflows/                  # Workflow-Exports (JSON)
│   ├── database/                   # PostgreSQL Dumps
│   └── config/                     # Konfigurationsdateien
└── assets/                         # Zusätzliche Ressourcen
    ├── scripts/                    # Hilfs-Skripte
    └── templates/                  # Workflow-Templates
```

---

## 📊 Speicherplatz-Übersicht

| Verzeichnis | Größe | Status | Aktion |
|-------------|-------|--------|--------|
| ~/n8n/ | 1.3 GB | ✅ Produktiv | Behalten |
| ~/n8n-workflows/ | 3.8 MB | ✅ Aktiv | Behalten |
| ~/.n8n/ | 476 KB | ⚠️ Veraltet | Prüfen & ggf. löschen |
| ~/n8n-data/ | 12 KB | ⚠️ Veraltet | Löschen |
| ~/Backup n8n-Workflows/ | 0 B | ⚠️ Leer | Löschen |
| ~/Downloads/n8n-docs-main/ | ? | ℹ️ Referenz | Archivieren |

**Gesamt (aktiv):** ~1.3 GB
**Potenziell freizugeben:** ~500 KB (vernachlässigbar)

---

## 🔧 Docker-Setup (OrbStack)

### Container-Konfiguration

**n8n (threema_n8n)**
- Image: n8nio/n8n:latest (Version 1.116.2)
- Port: 127.0.0.1:5678
- Volumes: n8n_data, custom_nodes/, logs/
- Abhängig von: PostgreSQL, Redis

**PostgreSQL (threema_postgres)**
- Image: postgres:15-alpine
- Port: 127.0.0.1:5432
- Volume: postgres_data
- Datenbank: threema_db

**Redis (threema_redis)**
- Image: redis:7-alpine
- Port: 127.0.0.1:6379
- Volume: redis_data

**Network:** threema_network (bridge)

### Wichtige Dateien

1. **docker-compose.yml** - Container-Definition
2. **.env** - Umgebungsvariablen (NICHT in Git!)
3. **init.sql** - PostgreSQL-Initialisierung
4. **custom_nodes/** - Eigene n8n-Erweiterungen

---

## 🔐 Sicherheit & Credentials

### Gespeicherte Credentials (in .env)

```bash
# Datenbank
POSTGRES_DB=threema_db
POSTGRES_USER=n8n_user
POSTGRES_PASSWORD=[gesetzt]

# Redis
REDIS_PASSWORD=[gesetzt]

# n8n Auth
N8N_AUTH_USER=[gesetzt]
N8N_AUTH_PASSWORD=[gesetzt]

# APIs
THREEMA_GATEWAY_ID=[zu konfigurieren]
THREEMA_GATEWAY_SECRET=[zu konfigurieren]
AZURE_OPENAI_API_KEY=[zu konfigurieren]
AZURE_OPENAI_ENDPOINT=[zu konfigurieren]
```

**⚠️ Wichtig:** 
- `.env` ist in `.gitignore` und wird NICHT committet
- Backups der `.env` nur auf sichere externe Medien
- Regelmäßig Passwörter rotieren

---

## 🚀 Zugriff & URLs

- **n8n Editor:** http://localhost:5678
- **PostgreSQL:** localhost:5432 (nur lokal)
- **Redis:** localhost:6379 (nur lokal)
- **pgAdmin:** http://localhost:5050 (optional, per Profile aktivierbar)

---

## 📝 Git-Repositories

### Repository 1: Haupt-Setup
```
Pfad: /Users/kunkel/n8n/
Remote: [zu prüfen mit: git remote -v]
Branch: main
Status: Aktiv
```

### Repository 2: Workflows
```
Pfad: /Users/kunkel/n8n-workflows/
Remote: [zu prüfen mit: git remote -v]
Branch: main
Status: Aktiv
```

---

## 📅 Wichtige Daten

- **Migration auf OrbStack:** 25. Oktober 2025
- **Docker Desktop entfernt:** 25. Oktober 2025
- **n8n Version aktualisiert:** 1.106.3 → 1.116.2
- **Letzte Änderung alte .n8n Installation:** 15. August 2025

---

## ✅ Nächste Schritte

1. [ ] Alte ~/.n8n/ Datenbank auf wichtige Workflows prüfen
2. [ ] Workflow-Backups auf externes Volume kopieren
3. [ ] n8n-docs auf externes Volume archivieren
4. [ ] Alte Verzeichnisse aufräumen (nach Bestätigung)
5. [ ] Automatisches Backup-Skript für externes Volume einrichten
6. [ ] Cursor Workspace für n8n erstellen

---

**Erstellt von:** Claude (Cursor AI)
**Dokumentversion:** 1.0
**Letztes Update:** 25. Oktober 2025

