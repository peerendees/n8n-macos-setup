#!/bin/bash
# =====================================
# n8n Setup Script für neuen Mac
# =====================================
# Automatisiert die Installation von n8n
# mit OrbStack und Docker
# =====================================

set -e  # Exit bei Fehler

# =====================================
# KONFIGURATION
# =====================================

N8N_DIR="$HOME/n8n"
REPO_URL="${REPO_URL:-https://github.com/USERNAME/n8n-setup.git}"  # ← ANPASSEN!

# =====================================
# FARBEN
# =====================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# =====================================
# FUNKTIONEN
# =====================================

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

log_info() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

prompt_yn() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Bitte y oder n eingeben.";;
        esac
    done
}

check_arch() {
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        log_info "Apple Silicon (M1/M2/M3) erkannt"
        export ARCH_TYPE="arm64"
    elif [[ "$ARCH" == "x86_64" ]]; then
        log_info "Intel Mac erkannt"
        export ARCH_TYPE="amd64"
    else
        log_error "Unbekannte Architektur: $ARCH"
        exit 1
    fi
}

# =====================================
# HAUPTPROZESS
# =====================================

print_header "n8n Setup für neuen Mac"

echo "Dieser Assistent hilft dir bei der Installation von:"
echo "  • Xcode Command Line Tools"
echo "  • Homebrew (optional)"
echo "  • Git"
echo "  • OrbStack (Docker-Alternative)"
echo "  • n8n mit PostgreSQL und Redis"
echo ""

if ! prompt_yn "Möchtest du fortfahren?"; then
    log_info "Setup abgebrochen"
    exit 0
fi

# =====================================
# 1. SYSTEM-CHECKS
# =====================================

print_header "1. System-Checks"

check_arch

# macOS Version prüfen
MACOS_VERSION=$(sw_vers -productVersion)
log_info "macOS Version: $MACOS_VERSION"

# =====================================
# 2. XCODE COMMAND LINE TOOLS
# =====================================

print_header "2. Xcode Command Line Tools"

if xcode-select -p &> /dev/null; then
    log_info "Xcode Command Line Tools bereits installiert"
else
    log_warn "Xcode Command Line Tools nicht gefunden"
    echo "Installiere Command Line Tools..."
    xcode-select --install
    echo ""
    echo "⚠️  Bitte warte bis die Installation abgeschlossen ist,"
    echo "    dann drücke ENTER um fortzufahren..."
    read -r
fi

# =====================================
# 3. HOMEBREW
# =====================================

print_header "3. Homebrew"

if command -v brew &> /dev/null; then
    log_info "Homebrew bereits installiert: $(brew --version | head -n1)"
else
    if prompt_yn "Möchtest du Homebrew installieren? (Empfohlen)"; then
        echo "Installiere Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Homebrew zum PATH hinzufügen
        if [[ "$ARCH_TYPE" == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        log_info "Homebrew installiert"
    else
        log_warn "Homebrew übersprungen"
    fi
fi

# =====================================
# 4. GIT
# =====================================

print_header "4. Git"

if command -v git &> /dev/null; then
    log_info "Git bereits installiert: $(git --version)"
else
    if command -v brew &> /dev/null; then
        echo "Installiere Git via Homebrew..."
        brew install git
        log_info "Git installiert"
    else
        log_error "Git nicht gefunden und Homebrew nicht verfügbar"
        echo "Bitte installiere Git manuell: https://git-scm.com/download/mac"
        exit 1
    fi
fi

# =====================================
# 5. ORBSTACK
# =====================================

print_header "5. OrbStack"

if command -v orb &> /dev/null; then
    log_info "OrbStack bereits installiert: $(orb --version 2>/dev/null || echo 'version unknown')"
else
    echo "Möchtest du OrbStack installieren?"
    echo "  1) Via Homebrew (empfohlen)"
    echo "  2) Manueller Download"
    echo "  3) Überspringen"
    read -p "Wähle (1-3): " choice
    
    case $choice in
        1)
            if command -v brew &> /dev/null; then
                echo "Installiere OrbStack via Homebrew..."
                brew install --cask orbstack
                log_info "OrbStack installiert"
            else
                log_error "Homebrew nicht verfügbar"
                exit 1
            fi
            ;;
        2)
            echo "Lade OrbStack herunter..."
            if [[ "$ARCH_TYPE" == "arm64" ]]; then
                ORBSTACK_URL="https://orbstack.dev/download/stable/latest/arm64"
            else
                ORBSTACK_URL="https://orbstack.dev/download/stable/latest/amd64"
            fi
            
            curl -L "$ORBSTACK_URL" -o ~/Downloads/OrbStack.dmg
            echo ""
            echo "⚠️  OrbStack.dmg wurde nach ~/Downloads heruntergeladen"
            echo "    Bitte:"
            echo "    1. Öffne ~/Downloads/OrbStack.dmg"
            echo "    2. Ziehe OrbStack.app in Programme"
            echo "    3. Starte OrbStack.app"
            echo "    4. Drücke ENTER um fortzufahren..."
            read -r
            ;;
        3)
            log_warn "OrbStack übersprungen - du musst es manuell installieren!"
            exit 1
            ;;
        *)
            log_error "Ungültige Auswahl"
            exit 1
            ;;
    esac
fi

# OrbStack starten
if ! pgrep -x "OrbStack" > /dev/null; then
    echo "Starte OrbStack..."
    open -a OrbStack
    sleep 5
fi

# Docker CLI verfügbar machen
if [ ! -d "$HOME/.orbstack/bin" ]; then
    log_warn "Warte auf OrbStack-Initialisierung..."
    echo "Bitte folge dem OrbStack-Setup-Assistenten,"
    echo "dann drücke ENTER um fortzufahren..."
    read -r
fi

# PATH aktualisieren
if ! echo "$PATH" | grep -q ".orbstack/bin"; then
    echo 'export PATH="$HOME/.orbstack/bin:$PATH"' >> ~/.zshrc
    export PATH="$HOME/.orbstack/bin:$PATH"
fi

# Docker verifizieren
if command -v docker &> /dev/null; then
    log_info "Docker CLI verfügbar: $(docker --version)"
else
    log_error "Docker CLI nicht verfügbar"
    echo "Bitte prüfe die OrbStack-Installation"
    exit 1
fi

# =====================================
# 6. n8n VERZEICHNIS ERSTELLEN
# =====================================

print_header "6. n8n Verzeichnis"

if [ -d "$N8N_DIR" ]; then
    log_warn "Verzeichnis $N8N_DIR existiert bereits"
    if ! prompt_yn "Möchtest du es verwenden?"; then
        log_error "Setup abgebrochen"
        exit 1
    fi
else
    echo "Erstelle $N8N_DIR..."
    mkdir -p "$N8N_DIR"
    log_info "Verzeichnis erstellt"
fi

# =====================================
# 7. KONFIGURATIONSDATEIEN
# =====================================

print_header "7. Konfigurationsdateien"

cd "$N8N_DIR"

echo "Wie möchtest du die Konfiguration einrichten?"
echo "  1) Von GitHub-Repository klonen"
echo "  2) Von externem Volume/USB kopieren"
echo "  3) Manuell später einrichten"
read -p "Wähle (1-3): " config_choice

case $config_choice in
    1)
        if [ -n "$REPO_URL" ] && [ "$REPO_URL" != "https://github.com/USERNAME/n8n-setup.git" ]; then
            echo "Klone Repository..."
            git clone "$REPO_URL" temp
            cp -r temp/config-templates/* "$N8N_DIR/"
            rm -rf temp
            log_info "Konfiguration von GitHub kopiert"
        else
            log_error "Repository-URL nicht konfiguriert!"
            echo "Bitte setze REPO_URL in diesem Skript"
            exit 1
        fi
        ;;
    2)
        read -p "Pfad zum Backup-Verzeichnis: " backup_path
        if [ -d "$backup_path" ]; then
            cp "$backup_path"/docker-compose.yml.template "$N8N_DIR/docker-compose.yml"
            cp "$backup_path"/env.template "$N8N_DIR/.env"
            log_info "Konfiguration kopiert"
        else
            log_error "Verzeichnis nicht gefunden: $backup_path"
            exit 1
        fi
        ;;
    3)
        log_warn "Konfiguration übersprungen"
        echo ""
        echo "⚠️  Bitte erstelle manuell:"
        echo "    • $N8N_DIR/docker-compose.yml"
        echo "    • $N8N_DIR/.env"
        echo ""
        echo "Templates findest du im Repository unter config-templates/"
        exit 0
        ;;
esac

# =====================================
# 8. .ENV BEARBEITEN
# =====================================

print_header "8. Umgebungsvariablen"

if [ -f "$N8N_DIR/.env" ]; then
    echo "Die .env Datei muss bearbeitet werden!"
    echo ""
    echo "⚠️  WICHTIG: Ersetze folgende Platzhalter:"
    echo "    • POSTGRES_PASSWORD"
    echo "    • REDIS_PASSWORD"
    echo "    • N8N_AUTH_USER"
    echo "    • N8N_AUTH_PASSWORD"
    echo ""
    echo "Sichere Passwörter generieren mit:"
    echo "    openssl rand -base64 32"
    echo ""
    
    if prompt_yn "Möchtest du die .env jetzt bearbeiten?"; then
        ${EDITOR:-nano} "$N8N_DIR/.env"
        log_info ".env bearbeitet"
    else
        log_warn ".env-Bearbeitung übersprungen"
        echo "⚠️  Bitte bearbeite $N8N_DIR/.env bevor du n8n startest!"
    fi
else
    log_error ".env Datei nicht gefunden"
    exit 1
fi

# =====================================
# 9. n8n STARTEN
# =====================================

print_header "9. n8n starten"

if prompt_yn "Möchtest du n8n jetzt starten?"; then
    echo "Starte Container..."
    cd "$N8N_DIR"
    docker-compose up -d
    
    echo ""
    echo "Warte auf Container-Start (30 Sekunden)..."
    sleep 30
    
    # Status prüfen
    docker-compose ps
    
    echo ""
    log_info "n8n sollte jetzt verfügbar sein!"
    echo ""
    echo "🌐 Öffne: http://localhost:5678"
    echo "👤 Login mit den Credentials aus .env"
    echo ""
    
    if prompt_yn "Browser jetzt öffnen?"; then
        open http://localhost:5678
    fi
else
    log_info "n8n-Start übersprungen"
    echo ""
    echo "Später starten mit:"
    echo "    cd $N8N_DIR"
    echo "    docker-compose up -d"
fi

# =====================================
# FERTIG
# =====================================

print_header "Setup abgeschlossen!"

echo "✓ OrbStack installiert"
echo "✓ Docker verfügbar"
echo "✓ n8n konfiguriert in: $N8N_DIR"
echo ""
echo "📚 Nächste Schritte:"
echo "  1. Workflows importieren (siehe WORKFLOW_MIGRATION.md)"
echo "  2. Custom Nodes installieren (falls vorhanden)"
echo "  3. Credentials konfigurieren"
echo "  4. Backup-Skript einrichten"
echo ""
echo "📖 Dokumentation: $N8N_DIR/docs/"
echo ""

log_info "Setup erfolgreich abgeschlossen!"

exit 0

# =====================================
# VERWENDUNG
# =====================================
#
# 1. Repository-URL anpassen (Zeile 15)
# 2. Ausführbar machen:
#    chmod +x setup-new-mac.sh
# 3. Ausführen:
#    ./setup-new-mac.sh
#
# ODER: Direkt von GitHub:
#    curl -fsSL https://raw.githubusercontent.com/[USER]/n8n-setup/main/assets/scripts/setup-new-mac.sh | bash
#
# =====================================


