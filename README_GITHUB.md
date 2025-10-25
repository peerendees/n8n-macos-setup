# 🚀 n8n Setup & Documentation

> Vollständige Setup-Anleitung und Dokumentation für n8n-Installation auf macOS mit OrbStack

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![n8n version](https://img.shields.io/badge/n8n-v1.116.2-blue.svg)](https://n8n.io)
[![Docker](https://img.shields.io/badge/Docker-OrbStack-2496ED?logo=docker)](https://orbstack.dev)

---

## 📖 Überblick

Dieses Repository enthält alles, was du brauchst, um **n8n** (Workflow-Automatisierung) auf einem **neuen Mac** zu installieren - inklusive:

- ✅ Vollständige Installationsanleitung
- ✅ Docker Compose Konfiguration (PostgreSQL + Redis + n8n)
- ✅ Workflow-Migrations-Guide
- ✅ Automatische Backup-Skripte
- ✅ Setup-Automatisierung für neuen Mac
- ✅ DSGVO-konforme Datenbankstruktur

**Perfekt für:**
- Workflow-Entwicklung auf mehreren Macs
- Backup & Disaster Recovery
- Team-Setups
- Produktions-Deployments

---

## 🎯 Schnellstart

### Option 1: Automatisiertes Setup (Empfohlen)

```bash
# 1. Repository klonen
git clone https://github.com/[DEIN-USERNAME]/n8n-setup.git
cd n8n-setup

# 2. Setup-Skript ausführen
chmod +x assets/scripts/setup-new-mac.sh
./assets/scripts/setup-new-mac.sh

# 3. .env bearbeiten (Passwörter setzen)
nano ~/n8n/.env

# 4. n8n starten
cd ~/n8n
docker-compose up -d

# 5. Browser öffnen
open http://localhost:5678
```

### Option 2: Manuelles Setup

Siehe **[Detaillierte Installationsanleitung](docs/setup/NEUE_INSTALLATION.md)**

---

## 📁 Repository-Struktur

```
n8n-setup/
├── README.md                              # Diese Datei
├── README_GITHUB.md                       # GitHub-optimiertes README
├── 00_n8n_STRUKTUR_DOKUMENTATION.md       # Vollständige Strukturdokumentation
│
├── docs/                                  # Dokumentation
│   ├── setup/
│   │   ├── NEUE_INSTALLATION.md           # ← Start hier!
│   │   └── WORKFLOW_MIGRATION.md          # Workflows zwischen Macs übertragen
│   ├── migration/
│   │   ├── DOCKER_MIGRATION_PLAN.md       # Docker Desktop → OrbStack
│   │   └── MIGRATION_SUCCESS.md
│   ├── workflows/                         # Workflow-Dokumentation
│   └── reference/                         # Referenzmaterial
│
├── config-templates/                      # Konfigurationsvorlagen
│   ├── docker-compose.yml.template        # Docker Compose Config
│   ├── env.template                       # Umgebungsvariablen
│   └── init.sql                           # PostgreSQL Initialisierung
│
├── assets/                                # Scripts & Ressourcen
│   ├── scripts/
│   │   ├── backup-workflows.sh            # Automatisches Workflow-Backup
│   │   └── setup-new-mac.sh               # Automatisiertes Setup
│   └── templates/                         # Workflow-Templates
│
└── backups/                               # Backup-Speicher (lokal)
    ├── workflows/                         # Workflow-Exports
    ├── database/                          # PostgreSQL Dumps
    └── config/                            # Konfigurationsdateien
```

---

## 🚀 Features

### 🐳 Moderne Docker-Stack

- **OrbStack** statt Docker Desktop (schneller, ressourcenschonender)
- **PostgreSQL 15** - Hauptdatenbank
- **Redis 7** - Cache & Queue
- **n8n latest** - Workflow Engine
- **Health Checks** - Automatische Container-Überwachung

### 🔐 Sicherheit & Compliance

- ✅ DSGVO-konforme Datenbankstruktur
- ✅ Verschlüsselte Credentials
- ✅ Audit-Logging
- ✅ Automatische Datenaufbewahrungsfristen
- ✅ Sichere Passwort-Verwaltung

### 📦 Backup & Migration

- ✅ Automatische Workflow-Backups
- ✅ Datenbank-Dumps
- ✅ Credentials-Export (verschlüsselt)
- ✅ Custom Nodes-Migration
- ✅ Git-basierte Synchronisation

### 🛠️ Developer-Friendly

- ✅ Ein-Befehl Setup
- ✅ Hot-Reload für Entwicklung
- ✅ Detaillierte Logs
- ✅ pgAdmin für DB-Management
- ✅ Vollständig dokumentiert

---

## 📖 Dokumentation

### Für Einsteiger

1. **[Neue Installation](docs/setup/NEUE_INSTALLATION.md)**
   - Komplette Schritt-für-Schritt Anleitung
   - OrbStack Setup
   - n8n Konfiguration
   - ~30-45 Minuten

2. **[Workflow Migration](docs/setup/WORKFLOW_MIGRATION.md)**
   - Workflows exportieren/importieren
   - Credentials übertragen
   - Custom Nodes kopieren
   - ~15-30 Minuten

### Für Fortgeschrittene

3. **[Struktur-Dokumentation](00_n8n_STRUKTUR_DOKUMENTATION.md)**
   - Vollständige System-Übersicht
   - Docker-Setup Details
   - Verzeichnisstruktur
   - Aufräum-Empfehlungen

4. **[Backup-Strategien](README.md#backup-strategie)**
   - Automatische Backups einrichten
   - Cron-Jobs
   - Externe Volumes

---

## ⚙️ Systemvoraussetzungen

- **macOS:** 12.0+ (Monterey oder neuer)
- **Architektur:** Apple Silicon (M1/M2/M3) oder Intel
- **RAM:** Minimum 8 GB, empfohlen 16 GB
- **Speicher:** Minimum 10 GB frei
- **Internet:** Für Downloads

---

## 🔧 Konfiguration

### Ports

| Service    | Port  | Beschreibung           |
|------------|-------|------------------------|
| n8n        | 5678  | Web-UI                |
| PostgreSQL | 5432  | Datenbank (nur lokal) |
| Redis      | 6379  | Cache (nur lokal)     |
| pgAdmin    | 5050  | DB-Management (optional) |

**Hinweis:** Alle Ports sind standardmäßig nur auf `127.0.0.1` gebunden (localhost).

### Umgebungsvariablen

Vollständige Liste in [`config-templates/env.template`](config-templates/env.template)

**Wichtigste Variablen:**

```bash
# Datenbank
POSTGRES_PASSWORD=...    # ← Generiere sicheres Passwort!

# Redis
REDIS_PASSWORD=...       # ← Generiere sicheres Passwort!

# n8n Auth
N8N_AUTH_USER=...        # ← Dein Username
N8N_AUTH_PASSWORD=...    # ← Generiere sicheres Passwort!

# Hostname
WEBHOOK_URL=http://localhost:5678  # Für Produktion anpassen
```

**Sichere Passwörter generieren:**
```bash
openssl rand -base64 32
```

---

## 🔄 Workflow-Synchronisation

### Zwischen zwei Macs synchronisieren

**Mac 1 (Original):**
```bash
# Workflows exportieren
cd ~/n8n
./assets/scripts/backup-workflows.sh

# Zu Git pushen
cd ~/n8n-workflows
cp ~/n8n/backups/workflows/workflows_*.json .
git add .
git commit -m "Workflow backup $(date +%Y%m%d)"
git push
```

**Mac 2 (Neu):**
```bash
# Von Git pullen
cd ~/n8n-workflows
git pull

# Workflows importieren
docker cp workflows_*.json threema_n8n:/tmp/
docker exec threema_n8n n8n import:workflow --input=/tmp/workflows_*.json
```

---

## 🐛 Troubleshooting

### Container startet nicht

```bash
# Logs prüfen
docker logs threema_n8n

# Container neu erstellen
docker-compose down
docker-compose up -d
```

### Port bereits belegt

```bash
# Port-Nutzung prüfen
lsof -i :5678

# Ports in docker-compose.yml ändern
# Von: "5678:5678"
# Zu:  "5679:5678"
```

### Datenbank-Verbindungsfehler

```bash
# PostgreSQL Health-Check
docker exec threema_postgres pg_isready -U n8n_user

# Passwort in .env prüfen
grep POSTGRES_PASSWORD ~/n8n/.env
```

### Weitere Hilfe

- 📖 [Troubleshooting-Guide](docs/setup/NEUE_INSTALLATION.md#troubleshooting)
- 💬 [n8n Community](https://community.n8n.io)
- 🐛 [GitHub Issues](https://github.com/[DEIN-USERNAME]/n8n-setup/issues)

---

## 📦 Backup & Disaster Recovery

### Automatisches Backup einrichten

```bash
# Backup-Skript ausführbar machen
chmod +x ~/n8n/assets/scripts/backup-workflows.sh

# Cron-Job einrichten (täglich um 2 Uhr)
crontab -e

# Folgende Zeile einfügen:
0 2 * * * /Users/[USERNAME]/n8n/assets/scripts/backup-workflows.sh >> /Users/[USERNAME]/n8n/logs/backup.log 2>&1
```

### Manuelles Backup

```bash
# Workflows
cd ~/n8n
docker exec threema_n8n n8n export:workflow --all --output=/tmp/workflows.json
docker cp threema_n8n:/tmp/workflows.json ./backups/workflows/

# Datenbank
docker exec threema_postgres pg_dump -U n8n_user threema_db > ./backups/database/db_$(date +%Y%m%d).sql

# Konfiguration
cp docker-compose.yml .env ./backups/config/
```

### Disaster Recovery

Siehe: [Workflow Migration Guide](docs/setup/WORKFLOW_MIGRATION.md#methode-3-vollständige-datenbank-migration)

---

## 🤝 Contributing

Beiträge sind willkommen! Bitte:

1. Fork das Repository
2. Erstelle einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Commit deine Änderungen (`git commit -m 'Add AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

---

## 📝 Lizenz

Dieses Projekt ist unter der [MIT Lizenz](LICENSE) lizenziert.

---

## 🙏 Credits

- **n8n.io** - Die fantastische Workflow-Automatisierungs-Plattform
- **OrbStack** - Moderne Docker-Alternative für macOS
- **PostgreSQL** - Robuste Open-Source Datenbank
- **Redis** - In-Memory Datenstruktur-Server

---

## 📞 Support

- **Dokumentation:** Siehe [`docs/`](docs/) Ordner
- **Issues:** [GitHub Issues](https://github.com/[DEIN-USERNAME]/n8n-setup/issues)
- **n8n Community:** https://community.n8n.io
- **OrbStack Docs:** https://docs.orbstack.dev

---

## 🗺️ Roadmap

- [ ] GitHub Actions für automatische Backups
- [ ] Kubernetes Deployment
- [ ] Docker Swarm Support
- [ ] Monitoring mit Grafana
- [ ] Auto-Update Skript
- [ ] Multi-Umgebung Support (Dev/Staging/Prod)

---

## ⭐ Projekt-Status

**Status:** ✅ Produktionsbereit

- **Version:** 1.0
- **n8n Version:** 1.116.2
- **Letzte Aktualisierung:** 25. Oktober 2025
- **Getestet auf:** macOS Sonoma 14.x, Apple Silicon M3

---

**Made with ❤️ for the n8n Community**

---

## 📚 Weiterführende Links

- [n8n Documentation](https://docs.n8n.io)
- [OrbStack](https://orbstack.dev)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)

---

⭐ **Wenn dir dieses Projekt gefällt, gib ihm einen Star!** ⭐

