# System-Versionen Übersicht

**Zweck:** Tracking der installierten Software-Versionen auf allen Macs für Update-Management
**Letzte Aktualisierung:** 25. Oktober 2025

---

## 📊 Übersicht

Diese Datei dokumentiert die aktuellen Software-Versionen auf allen Macs, um:
- ✅ Ausstehende Updates zu identifizieren
- ✅ Kompatibilität zwischen Macs sicherzustellen
- ✅ Versions-Diskrepanzen zu erkennen
- ✅ Migrations-Planung zu unterstützen

---

## 💻 MacBook Air M3 (Primär)

### System
| Software | Version | Installationsdatum | Letzte Aktualisierung |
|----------|---------|-------------------|----------------------|
| **macOS** | 14.x Sonoma | - | 2025-10-25 |
| **Chip** | Apple M3 | - | - |
| **RAM** | ? GB | - | - |

### Container-Umgebung
| Software | Version | Installationsdatum | Letzte Aktualisierung |
|----------|---------|-------------------|----------------------|
| **OrbStack** | 2.0.4 | 2025-10-25 | 2025-10-25 |
| **Docker Engine** | 28.3.3 | 2025-10-25 | 2025-10-25 |
| **Docker Compose** | v2.39.2 | 2025-10-25 | 2025-10-25 |

### n8n Stack
| Software | Version | Image/Package | Letzte Aktualisierung |
|----------|---------|---------------|----------------------|
| **n8n** | 1.116.2 | n8nio/n8n:latest | 2025-10-25 |
| **PostgreSQL** | 15 | postgres:15-alpine | 2025-10-25 |
| **Redis** | 7 | redis:7-alpine | 2025-10-25 |
| **pgAdmin** | latest | dpage/pgadmin4:latest | 2025-10-25 |

### Entwicklungstools
| Software | Version | Installationsdatum | Letzte Aktualisierung |
|----------|---------|-------------------|----------------------|
| **Git** | ? | ? | ? |
| **Homebrew** | ? | ? | ? |
| **Node.js** | ? | ? | ? |
| **npm** | ? | ? | ? |

### Wichtige Pfade
- **n8n Verzeichnis:** `/Users/kunkel/n8n/`
- **Workflows:** `/Users/kunkel/n8n-workflows/`
- **Backups:** `/Volumes/iQ_BERENT/1_Projekte/n8n/backups/`

---

## 💻 MacBook Air M2 (Sekundär)

### System
| Software | Version | Installationsdatum | Letzte Aktualisierung |
|----------|---------|-------------------|----------------------|
| **macOS** | - | - | - |
| **Chip** | Apple M2 | - | - |
| **RAM** | ? GB | - | - |

### Container-Umgebung
| Software | Version | Installationsdatum | Letzte Aktualisierung |
|----------|---------|-------------------|----------------------|
| **OrbStack** | - | - | - |
| **Docker Engine** | - | - | - |
| **Docker Compose** | - | - | - |

### n8n Stack
| Software | Version | Image/Package | Letzte Aktualisierung |
|----------|---------|---------------|----------------------|
| **n8n** | - | n8nio/n8n:? | - |
| **PostgreSQL** | - | postgres:?-alpine | - |
| **Redis** | - | redis:?-alpine | - |
| **pgAdmin** | - | dpage/pgadmin4:? | - |

### Entwicklungstools
| Software | Version | Installationsdatum | Letzte Aktualisierung |
|----------|---------|-------------------|----------------------|
| **Git** | - | - | - |
| **Homebrew** | - | - | - |
| **Node.js** | - | - | - |
| **npm** | - | - | - |

### Wichtige Pfade
- **n8n Verzeichnis:** -
- **Workflows:** -
- **Backups:** -

---

## 🔄 Update-Status

### Verfügbare Updates (zu prüfen)

| Mac | Software | Aktuell | Verfügbar | Priorität | Status |
|-----|----------|---------|-----------|-----------|--------|
| M3 | n8n | 1.116.2 | [prüfen](https://github.com/n8n-io/n8n/releases) | - | ✅ Aktuell |
| M3 | OrbStack | 2.0.4 | [prüfen](https://orbstack.dev/download) | - | ✅ Aktuell |
| M2 | n8n | - | - | - | ⏳ Ausstehend |
| M2 | OrbStack | - | - | - | ⏳ Ausstehend |

---

## 📝 Versions-Prüfung

### Befehle zur Versions-Abfrage

**Auf jedem Mac ausführen:**

```bash
# System
sw_vers -productVersion                  # macOS Version
sysctl -n machdep.cpu.brand_string      # CPU Info

# Container-Umgebung
orb --version                           # OrbStack
docker --version                        # Docker Engine
docker-compose --version                # Docker Compose

# n8n Stack
cd ~/n8n
docker exec threema_n8n n8n --version   # n8n Version
docker exec threema_postgres psql --version  # PostgreSQL
docker exec threema_redis redis-cli --version # Redis

# Entwicklungstools
git --version
brew --version
node --version
npm --version
```

### Automatisches Versions-Script

Erstelle `~/n8n/assets/scripts/check-versions.sh`:

```bash
#!/bin/bash
echo "=== System-Versionen ==="
echo "macOS: $(sw_vers -productVersion)"
echo "OrbStack: $(orb --version 2>/dev/null || echo 'nicht installiert')"
echo "Docker: $(docker --version 2>/dev/null || echo 'nicht verfügbar')"
echo ""
echo "=== n8n Stack ==="
docker exec threema_n8n n8n --version 2>/dev/null || echo "n8n nicht erreichbar"
docker exec threema_postgres psql --version 2>/dev/null || echo "PostgreSQL nicht erreichbar"
docker exec threema_redis redis-cli --version 2>/dev/null || echo "Redis nicht erreichbar"
```

---

## 🔔 Update-Strategie

### Wann updaten?

**n8n:**
- ✅ Neue Features benötigt
- ✅ Sicherheits-Updates
- ✅ Bug-Fixes für bekannte Probleme
- ⚠️ Major-Versions: Erst testen, dann produktiv

**OrbStack/Docker:**
- ✅ Sicherheits-Updates
- ⚠️ Nur bei Problemen oder neuen Features

**PostgreSQL/Redis:**
- ⚠️ Nur Minor-Updates (z.B. 15.1 → 15.2)
- ❌ Keine Major-Updates ohne Migrations-Plan

### Update-Prozess

1. **Backup erstellen**
   ```bash
   ~/n8n/assets/scripts/backup-workflows.sh
   docker exec threema_postgres pg_dump -U n8n_user threema_db > ~/n8n/backups/database/pre-update_$(date +%Y%m%d).sql
   ```

2. **Changelog prüfen**
   - n8n: https://github.com/n8n-io/n8n/releases
   - OrbStack: https://orbstack.dev/changelog

3. **Auf M3 testen**
   ```bash
   cd ~/n8n
   docker-compose pull
   docker-compose up -d
   ```

4. **Verifizieren**
   - n8n Web-UI öffnen
   - Test-Workflow ausführen
   - Logs prüfen

5. **Auf M2 replizieren**
   - Gleicher Prozess
   - Gleiche Versionen installieren

6. **Versions-Tracking aktualisieren**
   - Diese Datei aktualisieren
   - Git committen

---

## 📚 Version History

| Datum | Mac | Komponente | Von → Zu | Grund |
|-------|-----|------------|----------|-------|
| 2025-10-25 | M3 | n8n | 1.106.3 → 1.116.2 | Update + Migration zu OrbStack |
| 2025-10-25 | M3 | Docker | Docker Desktop → OrbStack 2.0.4 | Ressourcen sparen |

---

## 🔗 Nützliche Links

- **n8n Releases:** https://github.com/n8n-io/n8n/releases
- **n8n Changelog:** https://docs.n8n.io/release-notes/
- **OrbStack Changelog:** https://orbstack.dev/changelog
- **PostgreSQL Releases:** https://www.postgresql.org/support/versioning/
- **Redis Releases:** https://redis.io/download

---

## ⚠️ Kompatibilitäts-Matrix

| n8n Version | PostgreSQL | Redis | Node.js | Getestet |
|-------------|-----------|-------|---------|----------|
| 1.116.2 | 15 | 7 | 18+ | ✅ M3 |
| 1.106.3 | 15 | 7 | 18+ | ✅ M3 (alt) |

---

**Hinweise:**
- Dieses Dokument sollte nach jedem Update aktualisiert werden
- Vor Major-Updates: Backup erstellen!
- Bei Versions-Diskrepanzen zwischen Macs: Angleichen!

---

**Template Version:** 1.0
**Erstellt:** 25. Oktober 2025
**Nächste Prüfung:** Monatlich oder bei verfügbaren Updates

