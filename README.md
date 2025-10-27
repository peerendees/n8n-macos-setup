# 🚀 n8n macOS Setup

> Vollständige Setup-Anleitung und Automatisierung für n8n-Installation auf macOS mit OrbStack

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![n8n version](https://img.shields.io/badge/n8n-v1.116.2-blue.svg)](https://n8n.io)
[![Docker](https://img.shields.io/badge/Docker-OrbStack-2496ED?logo=docker)](https://orbstack.dev)

---

## 📖 Überblick

Dieses Repository enthält **Setup & Dokumentation** für n8n auf macOS. Für die **eigentlichen Workflows** siehe: **[n8n-workflows Repository](https://github.com/peerendees/n8n-workflows)** 

### 🎯 Zwei Repositories - Klare Trennung

| Repository | Zweck | Inhalt |
|------------|-------|--------|
| **📦 n8n-macos-setup** (dieses) | Setup & Infrastruktur | Installation, Docker Config, Skripte, Dokumentation |
| **🔧 [n8n-workflows](https://github.com/peerendees/n8n-workflows)** | Workflows & Daten | Workflow-Definitionen, Backups, Custom Nodes |

**Zusammenspiel:**
1. Mit **n8n-macos-setup** → n8n installieren & konfigurieren
2. Mit **n8n-workflows** → Produktive Workflows verwalten & synchronisieren

---

## ⚡ Schnellstart

### Neu Installation auf neuem Mac

```bash
# 1. Dieses Repository klonen
git clone https://github.com/peerendees/n8n-macos-setup.git
cd n8n-macos-setup

# 2. Automatisches Setup
chmod +x assets/scripts/setup-new-mac.sh
./assets/scripts/setup-new-mac.sh

# 3. Workflows-Repository klonen
cd ~
git clone https://github.com/peerendees/n8n-workflows.git

# 4. Fertig! n8n läuft auf http://localhost:5678
```

**Zeitaufwand:** ~30-45 Minuten

---

## 📁 Was ist in diesem Repository?

### ✅ Dieses Repository (n8n-macos-setup)

- **Installationsanleitungen** - Schritt-für-Schritt für neuen Mac
- **Docker-Konfiguration** - PostgreSQL + Redis + n8n
- **Setup-Automatisierung** - Ein-Befehl Installation
- **Backup-Skripte** - Automatische Workflow-Sicherung
- **System-Dokumentation** - Versionen, Troubleshooting
- **Migrations-Guides** - Docker Desktop → OrbStack

### ❌ NICHT in diesem Repository

- ❌ Produktive Workflows (→ siehe **n8n-workflows**)
- ❌ Workflow-Backups (→ siehe **n8n-workflows**)
- ❌ Custom Nodes (→ siehe **n8n-workflows**)
- ❌ Credentials (niemals in Git!)

---

## 📚 Dokumentation

### 🚀 Für Einsteiger

1. **[Neue Installation](docs/setup/NEUE_INSTALLATION.md)**
   - Komplette Schritt-für-Schritt Anleitung
   - OrbStack, Docker, n8n Setup
   - ~30-45 Minuten

2. **[Workflow Migration](docs/setup/WORKFLOW_MIGRATION.md)**
   - Workflows zwischen Macs übertragen
   - 3 verschiedene Methoden
   - Credentials & Custom Nodes

### 🔧 Für Fortgeschrittene

3. **[System-Versionen](docs/SYSTEM_VERSIONEN.md)** ⭐ NEU
   - Versions-Tracking für beide Macs (M3 & M2)
   - Update-Status & verfügbare Updates
   - Kompatibilitäts-Matrix

4. **[Struktur-Dokumentation](00_n8n_STRUKTUR_DOKUMENTATION.md)**
   - Vollständige System-Übersicht
   - Docker-Setup Details
   - Verzeichnisse & Cleanup

5. **[Migrations-Historie](docs/migration/)**
   - Docker Desktop → OrbStack
   - Lessons Learned

---

## 🔄 Workflow zwischen zwei Macs

### Entwicklung auf Mac 1 (M3)

```bash
# 1. Workflows in n8n entwickeln
# 2. Workflows exportieren
cd ~/n8n
./assets/scripts/backup-workflows.sh

# 3. Zu n8n-workflows Repository pushen
cd ~/n8n-workflows
cp ~/n8n/backups/workflows/workflows_*.json .
git add .
git commit -m "Update workflows $(date +%Y%m%d)"
git push
```

### Synchronisation auf Mac 2 (M2)

```bash
# 1. Workflows pullen
cd ~/n8n-workflows
git pull

# 2. In n8n importieren
docker cp workflows_*.json threema_n8n:/tmp/
docker exec threema_n8n n8n import:workflow --input=/tmp/workflows_*.json

# 3. n8n neu laden
open http://localhost:5678
```

---

## 📦 Repository-Struktur

```
n8n-macos-setup/
├── README.md                              # Diese Datei
├── docs/
│   ├── setup/
│   │   ├── NEUE_INSTALLATION.md           # ← Start hier!
│   │   └── WORKFLOW_MIGRATION.md
│   ├── SYSTEM_VERSIONEN.md                # ⭐ Versions-Tracking
│   └── migration/
│
├── config-templates/                      # Docker & .env Templates
│   ├── docker-compose.yml.template
│   ├── env.template
│   └── init.sql
│
├── assets/scripts/                        # Automatisierungs-Skripte
│   ├── backup-workflows.sh                # Auto-Backup
│   └── setup-new-mac.sh                   # Auto-Setup
│
└── backups/                               # Lokale Backups (nicht in Git)
    ├── workflows/
    ├── database/
    └── config/
```

---

## 💻 System-Versionen

Aktueller Status (siehe [SYSTEM_VERSIONEN.md](docs/SYSTEM_VERSIONEN.md)):

| Mac | macOS | OrbStack | n8n | PostgreSQL | Redis | Status |
|-----|-------|----------|-----|------------|-------|--------|
| **M3** | 14.x | 2.0.4 | 1.116.2 | 15 | 7 | ✅ Produktiv |
| **M2** | - | - | - | - | - | ⏳ Ausstehend |

---

## 🔗 Verwandte Repositories

| Repository | Zweck | Link |
|------------|-------|------|
| **n8n-workflows** | Produktive Workflows | [→ Repository](https://github.com/peerendees/n8n-workflows) |
| **n8n-macos-setup** | Setup & Infrastruktur | [→ dieses Repository] |

---

## 🛠️ Features

### ✅ In diesem Repository

- ✅ **Ein-Befehl Setup** für neuen Mac
- ✅ **Automatische Backups** (Cron-Job ready)
- ✅ **Docker Compose** Templates (vollständig kommentiert)
- ✅ **DSGVO-konforme** PostgreSQL-Struktur
- ✅ **Versions-Tracking** für beide Macs
- ✅ **Troubleshooting** Guides
- ✅ **3 Migrations-Methoden** (CLI, Git, Database)

---

## 🐛 Troubleshooting

Siehe [NEUE_INSTALLATION.md - Troubleshooting](docs/setup/NEUE_INSTALLATION.md#troubleshooting)

**Häufige Probleme:**
- Container startet nicht → `docker logs threema_n8n`
- Port belegt → Ports in `docker-compose.yml` ändern
- DB-Fehler → Passwort in `.env` prüfen

---

## 🤝 Zusammenarbeit mit n8n-workflows Repository

### Typischer Workflow

1. **Setup (einmalig):**
   ```bash
   # n8n installieren
   git clone https://github.com/peerendees/n8n-macos-setup.git
   cd n8n-macos-setup
   ./assets/scripts/setup-new-mac.sh
   
   # Workflows klonen
   git clone https://github.com/peerendees/n8n-workflows.git ~/n8n-workflows
   ```

2. **Entwicklung (täglich):**
   ```bash
   # In n8n entwickeln → http://localhost:5678
   
   # Workflows sichern
   ~/n8n/assets/scripts/backup-workflows.sh
   
   # Zu Git pushen
   cd ~/n8n-workflows
   git add . && git commit -m "Update" && git push
   ```

3. **Synchronisation (andere Macs):**
   ```bash
   cd ~/n8n-workflows
   git pull
   # Workflows importieren (siehe Anleitung)
   ```

---

## 📞 Support

- **📖 Dokumentation:** Siehe [`docs/`](docs/) Ordner
- **🐛 Issues:** [GitHub Issues](https://github.com/peerendees/n8n-macos-setup/issues)
- **💬 n8n Community:** https://community.n8n.io
- **📚 OrbStack Docs:** https://docs.orbstack.dev

---

## 📝 Lizenz

MIT License - siehe [LICENSE](LICENSE)

---

## 🙏 Credits

- **n8n.io** - Workflow-Automatisierungs-Plattform
- **OrbStack** - Docker-Alternative für macOS
- **PostgreSQL** - Datenbank
- **Redis** - Cache/Queue

---

## ⭐ Status

**Version:** 1.0  
**n8n Version:** 1.116.2  
**Letzte Aktualisierung:** 25. Oktober 2025  
**Getestet auf:** macOS Sonoma 14.x, Apple Silicon M3

---

⭐ **Wenn dir dieses Repository hilft, gib ihm einen Star!** ⭐

---

**Siehe auch:** [n8n-workflows Repository](https://github.com/peerendees/n8n-workflows) für produktive Workflows
