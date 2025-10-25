# Docker Desktop Migration Plan

## Aktueller Status (Stand: 25.10.2025)

### Was läuft aktuell:
- Docker Desktop 4.43.1 (Update auf 4.48.0 verfügbar)
- Docker Engine 28.3.0
- n8n 1.116.2 in Docker (Port 5678)
- PostgreSQL 15 (Port 5432)
- Redis 7 (Port 6379)

### Ziel:
- Docker Desktop entfernen (spart Speicherplatz)
- Durch leichtgewichtige Alternative ersetzen (OrbStack oder Colima)
- Alle Befehle weiterhin über Terminal/Chat nutzen
- n8n-Setup beibehalten

### Nächste Schritte:
1. Aktuelle Container stoppen und Daten sichern
2. Docker Desktop deinstallieren
3. OrbStack oder Colima installieren
4. n8n-Container wieder starten
5. Testen

### Wichtige Pfade:
- n8n Setup: `/Users/kunkel/n8n/`
- Docker Compose: `/Users/kunkel/n8n/docker-compose.yml`
- Umgebungsvariablen: `/Users/kunkel/n8n/.env`

### Im Chat fortfahren:
"Ich möchte jetzt Docker Desktop durch OrbStack/Colima ersetzen"

