# n8n Projekt - Zentrale Dokumentation & Backups

**Speicherort:** `/Volumes/iQ_BERENT/1_Projekte/n8n/`
**Erstellt:** 25. Oktober 2025

---

## 📋 Übersicht

Dies ist der **zentrale Speicherort** für alle n8n-bezogenen Dokumentationen, Backups und Ressourcen auf dem externen Volume `iQ_BERENT`.

---

## 📁 Ordnerstruktur

```
/Volumes/iQ_BERENT/1_Projekte/n8n/
│
├── README.md                          ← Diese Datei
├── 00_n8n_STRUKTUR_DOKUMENTATION.md   ← Vollständige Strukturdokumentation
│
├── docs/                              ← Alle Dokumentationen
│   ├── migration/                     ← Migrations-Dokumentation
│   │   ├── DOCKER_MIGRATION_PLAN.md
│   │   └── MIGRATION_SUCCESS.md
│   ├── setup/                         ← Setup-Anleitungen
│   ├── workflows/                     ← Workflow-Dokumentation
│   └── reference/                     ← Referenzmaterial (n8n-docs)
│
├── backups/                           ← Regelmäßige Backups
│   ├── workflows/                     ← Workflow-Exports (JSON)
│   ├── database/                      ← PostgreSQL Dumps
│   └── config/                        ← Konfigurationsdateien
│
└── assets/                            ← Zusätzliche Ressourcen
    ├── scripts/                       ← Hilfs-Skripte
    └── templates/                     ← Workflow-Templates
```

---

## 🎯 Zweck der Ordner

### `docs/`
Alle Dokumentationen zu n8n-Setup, Konfiguration, Workflows und Migrationen.

**Unterordner:**
- `migration/` - Dokumentation von System-Migrationen (z.B. Docker Desktop → OrbStack)
- `setup/` - Installations- und Einrichtungsanleitungen
- `workflows/` - Dokumentation einzelner Workflows und deren Funktionsweise
- `reference/` - Externe Dokumentation und Referenzmaterial

### `backups/`
Regelmäßige Sicherungen aller wichtigen n8n-Daten.

**Unterordner:**
- `workflows/` - JSON-Exports der n8n Workflows (täglich/wöchentlich)
- `database/` - PostgreSQL Datenbank-Dumps
- `config/` - Konfigurationsdateien (docker-compose.yml, env.list)

### `assets/`
Zusätzliche Ressourcen und Tools.

**Unterordner:**
- `scripts/` - Backup-Skripte, Deployment-Tools, Hilfsskripte
- `templates/` - Workflow-Vorlagen und Boilerplates

---

## 🚀 Produktiv-System

**Hauptverzeichnis:** `/Users/kunkel/n8n/`

- **n8n Version:** 1.116.2
- **Docker Engine:** OrbStack 2.0.4 (Docker 28.3.3)
- **Zugriff:** http://localhost:5678

**Container:**
- n8n:latest (Port 5678)
- PostgreSQL 15 (Port 5432)
- Redis 7 (Port 6379)

---

## 📝 Wichtige Dokumente

1. **`00_n8n_STRUKTUR_DOKUMENTATION.md`**
   - Vollständige Übersicht aller n8n-Verzeichnisse
   - Status der einzelnen Installationen
   - Docker-Setup Details
   - Empfehlungen für Aufräumarbeiten

2. **`docs/migration/DOCKER_MIGRATION_PLAN.md`**
   - Plan für Docker Desktop → OrbStack Migration

3. **`docs/migration/MIGRATION_SUCCESS.md`**
   - Erfolgsbestätigung der Migration
   - Details zur durchgeführten Migration

---

## 🔄 Backup-Strategie

### Empfohlene Backup-Frequenz:

**Täglich (automatisiert):**
- Workflow-Exports (JSON)
- PostgreSQL Inkrementelle Backups

**Wöchentlich:**
- Vollständige PostgreSQL Dumps
- Konfigurationsdateien

**Bei Änderungen:**
- docker-compose.yml
- .env (verschlüsselt!)
- Custom Nodes

### Backup-Befehle:

```bash
# Workflows exportieren
cd /Users/kunkel/n8n
docker exec threema_n8n n8n export:workflow --all --output=/backup/workflows_$(date +%Y%m%d).json

# PostgreSQL Dump
docker exec threema_postgres pg_dump -U n8n_user threema_db > /Volumes/iQ_BERENT/1_Projekte/n8n/backups/database/db_$(date +%Y%m%d).sql

# Konfiguration sichern
cp /Users/kunkel/n8n/{docker-compose.yml,env.list} /Volumes/iQ_BERENT/1_Projekte/n8n/backups/config/
```

---

## 📚 Weitere Ressourcen

- [n8n Offizielle Dokumentation](https://docs.n8n.io)
- [OrbStack Dokumentation](https://docs.orbstack.dev)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

## ⚠️ Sicherheitshinweise

- **Keine Passwörter** in diesem Repository ablegen
- **.env Dateien** nur verschlüsselt sichern
- **Backups** regelmäßig auf Integrität prüfen
- **Zugriff** auf externes Volume beschränken

---

## 📞 Support & Troubleshooting

Bei Problemen siehe:
1. `00_n8n_STRUKTUR_DOKUMENTATION.md` - Troubleshooting-Sektion
2. `docs/setup/` - Setup-Anleitungen
3. Docker Logs: `docker logs threema_n8n`

---

**Zuletzt aktualisiert:** 25. Oktober 2025
**Verwaltet von:** iQ Berent
**Dokumentversion:** 1.0

