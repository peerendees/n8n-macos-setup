#!/bin/bash
# =====================================
# n8n Workflow Backup Script
# =====================================
# Exportiert automatisch alle n8n Workflows
# Für Cron-Job geeignet
# =====================================

set -e  # Exit bei Fehler

# =====================================
# KONFIGURATION
# =====================================

# n8n-Verzeichnis (anpassen falls nötig)
N8N_DIR="${N8N_DIR:-$HOME/n8n}"

# Container-Name (anpassen falls nötig)
CONTAINER_NAME="threema_n8n"

# Backup-Verzeichnis
BACKUP_DIR="${N8N_DIR}/backups/workflows"

# Externe Backup-Location (optional, z.B. externes Volume)
EXTERNAL_BACKUP="${EXTERNAL_BACKUP:-/Volumes/iQ_BERENT/1_Projekte/n8n/backups/workflows}"

# Anzahl Backups die behalten werden sollen
KEEP_BACKUPS=30

# =====================================
# FARBEN FÜR OUTPUT
# =====================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# =====================================
# FUNKTIONEN
# =====================================

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker ist nicht installiert oder nicht im PATH"
        exit 1
    fi
}

check_container() {
    if ! docker ps | grep -q "$CONTAINER_NAME"; then
        log_error "Container '$CONTAINER_NAME' läuft nicht"
        exit 1
    fi
}

create_backup_dir() {
    mkdir -p "$BACKUP_DIR"
    if [ -n "$EXTERNAL_BACKUP" ]; then
        mkdir -p "$EXTERNAL_BACKUP" 2>/dev/null || log_warn "Externes Backup-Verzeichnis nicht verfügbar"
    fi
}

# =====================================
# BACKUP-PROZESS
# =====================================

log_info "Starte n8n Workflow Backup..."
log_info "Datum: $(date '+%Y-%m-%d %H:%M:%S')"

# Checks
check_docker
check_container
create_backup_dir

# Dateiname mit Timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="workflows_${TIMESTAMP}.json"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

# Export aus n8n
log_info "Exportiere Workflows..."
if docker exec "$CONTAINER_NAME" n8n export:workflow --all --output="/tmp/${BACKUP_FILE}" 2>&1 | tee /tmp/n8n-backup.log; then
    log_info "Export erfolgreich"
else
    log_error "Export fehlgeschlagen"
    cat /tmp/n8n-backup.log
    exit 1
fi

# Datei aus Container kopieren
log_info "Kopiere Backup aus Container..."
if docker cp "${CONTAINER_NAME}:/tmp/${BACKUP_FILE}" "$BACKUP_PATH"; then
    log_info "Backup gespeichert: $BACKUP_PATH"
else
    log_error "Kopieren fehlgeschlagen"
    exit 1
fi

# Temporäre Datei im Container löschen
docker exec "$CONTAINER_NAME" rm "/tmp/${BACKUP_FILE}" 2>/dev/null || true

# Backup-Größe prüfen
BACKUP_SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
WORKFLOW_COUNT=$(docker exec "$CONTAINER_NAME" n8n list:workflow 2>/dev/null | grep -c "^-" || echo "?")

log_info "Backup-Größe: $BACKUP_SIZE"
log_info "Anzahl Workflows: $WORKFLOW_COUNT"

# Auf externes Volume kopieren (falls verfügbar)
if [ -n "$EXTERNAL_BACKUP" ] && [ -d "$(dirname "$EXTERNAL_BACKUP")" ]; then
    log_info "Kopiere auf externes Volume..."
    if cp "$BACKUP_PATH" "$EXTERNAL_BACKUP/"; then
        log_info "Externes Backup erstellt"
    else
        log_warn "Externes Backup fehlgeschlagen (nicht kritisch)"
    fi
fi

# Alte Backups löschen (behalte nur die letzten N)
log_info "Räume alte Backups auf (behalte $KEEP_BACKUPS)..."
OLD_BACKUPS=$(ls -t "$BACKUP_DIR"/workflows_*.json 2>/dev/null | tail -n +$((KEEP_BACKUPS + 1)))
if [ -n "$OLD_BACKUPS" ]; then
    echo "$OLD_BACKUPS" | while read -r file; do
        log_info "Lösche altes Backup: $(basename "$file")"
        rm "$file"
    done
else
    log_info "Keine alten Backups zum Löschen"
fi

# Externes Backup aufräumen
if [ -n "$EXTERNAL_BACKUP" ] && [ -d "$EXTERNAL_BACKUP" ]; then
    OLD_EXTERNAL=$(ls -t "$EXTERNAL_BACKUP"/workflows_*.json 2>/dev/null | tail -n +$((KEEP_BACKUPS + 1)))
    if [ -n "$OLD_EXTERNAL" ]; then
        echo "$OLD_EXTERNAL" | while read -r file; do
            rm "$file" 2>/dev/null || true
        done
    fi
fi

# =====================================
# ZUSÄTZLICH: CREDENTIALS LISTE
# =====================================

CRED_LIST="${BACKUP_DIR}/credentials_list_${TIMESTAMP}.txt"
log_info "Erstelle Credentials-Liste (ohne Werte)..."
docker exec "$CONTAINER_NAME" n8n list:credentials > "$CRED_LIST" 2>/dev/null || log_warn "Credentials-Liste konnte nicht erstellt werden"

# =====================================
# FERTIG
# =====================================

log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_info "✓ Backup erfolgreich abgeschlossen!"
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_info "Backup-Datei: $BACKUP_FILE"
log_info "Speicherort: $BACKUP_DIR"
log_info "Größe: $BACKUP_SIZE"
log_info "Workflows: $WORKFLOW_COUNT"

# Optional: Benachrichtigung senden (Webhook, E-Mail, etc.)
# curl -X POST "https://your-webhook-url.com" -d "Backup completed: $BACKUP_FILE"

exit 0

# =====================================
# VERWENDUNG
# =====================================
#
# 1. Manuell ausführen:
#    ./backup-workflows.sh
#
# 2. Cron-Job einrichten:
#    crontab -e
#    # Täglich um 2 Uhr morgens
#    0 2 * * * /Users/[USERNAME]/n8n/assets/scripts/backup-workflows.sh >> /Users/[USERNAME]/n8n/logs/backup.log 2>&1
#
# 3. Externes Backup-Verzeichnis setzen:
#    EXTERNAL_BACKUP="/Volumes/USB-Stick/n8n-backups" ./backup-workflows.sh
#
# 4. Anzahl behaltener Backups ändern:
#    KEEP_BACKUPS=60 ./backup-workflows.sh
#
# =====================================

