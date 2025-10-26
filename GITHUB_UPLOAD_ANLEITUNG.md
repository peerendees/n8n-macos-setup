# GitHub Upload - Schritt-für-Schritt Anleitung

**Repository-Name:** `n8n-macos-setup`
**Status:** ✅ Bereit für Upload

---

## 📋 Voraussetzungen

- ✅ Git Repository ist erstellt (lokal)
- ✅ Alle Dateien sind committet
- ✅ GitHub-Account vorhanden
- ✅ GitHub-Anmeldung im Browser

---

## 🚀 Schritt 1: GitHub-Repository anlegen

### 1.1 Auf GitHub.com anmelden

1. Öffne: https://github.com
2. Melde dich an

### 1.2 Neues Repository erstellen

1. Klicke oben rechts auf **"+"** → **"New repository"**

2. **Repository-Einstellungen:**
   - **Repository name:** `n8n-macos-setup`
   - **Description:** `Complete n8n setup & documentation for macOS with OrbStack - Installation, Docker config, automation scripts`
   - **Visibility:** `Public` (oder `Private` falls gewünscht)
   - **⚠️ WICHTIG:** 
     - ❌ **KEIN** "Initialize this repository with a README"
     - ❌ **KEIN** ".gitignore hinzufügen"
     - ❌ **KEINE** License auswählen
     - (Wir haben bereits alle Dateien lokal!)

3. Klicke auf **"Create repository"**

---

## 🔗 Schritt 2: GitHub zeigt Anweisungen

Nach dem Erstellen zeigt GitHub einen leeren Screen mit Anweisungen.

**Notiere dir die Repository-URL:**
```
https://github.com/[DEIN-USERNAME]/n8n-macos-setup.git
```

---

## 💻 Schritt 3: Lokales Repository mit GitHub verbinden

Öffne Terminal und führe aus:

```bash
# 1. Zum Repository-Verzeichnis wechseln
cd /Volumes/iQ_BERENT/1_Projekte/n8n

# 2. GitHub als Remote hinzufügen
# ERSETZE [DEIN-USERNAME] mit deinem GitHub-Username!
git remote add origin https://github.com/[DEIN-USERNAME]/n8n-macos-setup.git

# 3. Verifizieren
git remote -v
```

**Erwartete Ausgabe:**
```
origin  https://github.com/[USERNAME]/n8n-macos-setup.git (fetch)
origin  https://github.com/[USERNAME]/n8n-macos-setup.git (push)
```

---

## 📤 Schritt 4: Repository hochladen

```bash
# Zum main Branch umbenennen (falls nötig)
git branch -M main

# Hochladen
git push -u origin main
```

**Beim ersten Push wirst du nach Authentifizierung gefragt:**

### Option A: Personal Access Token (Empfohlen)

Falls du noch keinen Token hast:
1. GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **Generate new token (classic)**
3. Scopes auswählen: `repo` (vollständig)
4. Token generieren & kopieren
5. Als Passwort beim Push verwenden

### Option B: SSH-Key

Falls du SSH verwendest:
```bash
# SSH-Remote statt HTTPS
git remote set-url origin git@github.com:[USERNAME]/n8n-macos-setup.git
git push -u origin main
```

---

## ✅ Schritt 5: Verifizieren

1. Öffne: `https://github.com/[DEIN-USERNAME]/n8n-macos-setup`
2. Prüfe ob alle Dateien da sind:
   - ✅ README.md wird angezeigt
   - ✅ docs/ Ordner
   - ✅ config-templates/
   - ✅ assets/scripts/
   - ✅ LICENSE

---

## 🎨 Schritt 6: Repository optimieren

### 6.1 About-Sektion bearbeiten

Auf der Repository-Seite, rechts oben:
1. Klicke auf **"⚙️ About"** (Zahnrad-Symbol)
2. Füge hinzu:
   - **Description:** `Complete n8n setup & documentation for macOS with OrbStack`
   - **Website:** (falls vorhanden)
   - **Topics:** 
     - `n8n`
     - `docker`
     - `automation`
     - `macos`
     - `orbstack`
     - `workflow-automation`
     - `postgresql`
     - `redis`
3. **Save changes**

### 6.2 Repository-Einstellungen

**Settings → General:**
- ✅ Issues aktivieren
- ✅ Wiki aktivieren (optional)
- ✅ Discussions aktivieren (optional)

---

## 🔗 Schritt 7: README anpassen (Platzhalter ersetzen)

### 7.1 GitHub-Username in README ersetzen

```bash
cd /Volumes/iQ_BERENT/1_Projekte/n8n

# Öffne README.md
nano README.md
# oder
open -e README.md
```

**Ersetze überall:**
- `[DEIN-USERNAME]` → dein tatsächlicher GitHub-Username
- `[USERNAME]` → dein tatsächlicher GitHub-Username

**In folgenden Zeilen:**
- Zeile ~20: Link zu n8n-workflows
- Zeile ~32: Link zu n8n-workflows
- Zeile ~50: git clone URL
- Zeile ~195: Support Issues Link
- Zeile ~230: n8n-workflows Link

### 7.2 Auch in setup-new-mac.sh anpassen

```bash
# Öffne Setup-Skript
nano assets/scripts/setup-new-mac.sh
```

**Zeile 15:**
```bash
REPO_URL="${REPO_URL:-https://github.com/[DEIN-USERNAME]/n8n-macos-setup.git}"
```

Ersetze `[DEIN-USERNAME]` mit deinem GitHub-Username.

### 7.3 Committen & pushen

```bash
git add README.md assets/scripts/setup-new-mac.sh
git commit -m "docs: Replace GitHub username placeholders"
git push
```

---

## 🔄 Schritt 8: n8n-workflows Repository verlinken

### 8.1 In n8n-workflows Repository

Falls noch nicht geschehen:
```bash
cd ~/n8n-workflows

# README.md erstellen/bearbeiten
nano README.md
```

Füge hinzu:
```markdown
# n8n Workflows

Produktive n8n-Workflows und Custom Nodes.

## 🔗 Setup & Installation

Für die Installation von n8n siehe:
**[n8n-macos-setup Repository](https://github.com/[USERNAME]/n8n-macos-setup)**

## 📦 Repository-Zweck

Dieses Repository enthält:
- Workflow-Definitionen (.json)
- Custom Nodes
- Workflow-Backups
- Workflow-Dokumentation

Für Infrastructure & Setup siehe n8n-macos-setup.
```

```bash
git add README.md
git commit -m "docs: Link to n8n-macos-setup repository"
git push
```

---

## 📊 Schritt 9: Finale Checks

### Checkliste

- [ ] Repository ist öffentlich zugänglich (oder privat, je nach Wunsch)
- [ ] README.md wird korrekt angezeigt
- [ ] Alle Platzhalter `[USERNAME]` ersetzt
- [ ] Topics/Tags hinzugefügt
- [ ] LICENSE ist sichtbar
- [ ] n8n-workflows ist verlinkt
- [ ] Setup-Skript funktioniert (URLs korrekt)

### Test

Teste ob jemand anderer das Repository verwenden könnte:
```bash
# In neuem Terminal-Fenster
cd /tmp
git clone https://github.com/[DEIN-USERNAME]/n8n-macos-setup.git
cd n8n-macos-setup
ls -la
cat README.md
```

---

## 🎉 Fertig!

Dein Repository ist jetzt online unter:
```
https://github.com/[DEIN-USERNAME]/n8n-macos-setup
```

### Nächste Schritte

1. **Teilen:**
   - In n8n Community posten
   - Auf Social Media teilen
   - Bei Kollegen bekannt machen

2. **Pflegen:**
   - Bei Updates: committen & pushen
   - Issues beantworten
   - Pull Requests reviewen

3. **Erweitern:**
   - Weitere Dokumentation
   - Screenshots/GIFs hinzufügen
   - Mehr Beispiele

---

## 🔧 Hilfreiche Git-Befehle

```bash
# Status prüfen
git status

# Änderungen anzeigen
git diff

# Änderungen committen
git add .
git commit -m "deine Nachricht"

# Hochladen
git push

# Herunterladen (Updates von GitHub)
git pull

# Remote-URL anzeigen
git remote -v

# Remote-URL ändern
git remote set-url origin [NEUE-URL]

# Letzten Commit rückgängig (lokal)
git reset --soft HEAD~1

# Branch anzeigen
git branch

# Log anzeigen
git log --oneline
```

---

## ⚠️ Troubleshooting

### "Permission denied" beim Push

**Lösung:**
- Personal Access Token verwenden
- Oder SSH-Key einrichten

### "remote origin already exists"

**Lösung:**
```bash
git remote remove origin
git remote add origin [URL]
```

### ".DS_Store" oder andere ungewollte Dateien

**Lösung:**
```bash
# Aus Git entfernen
git rm --cached .DS_Store
git commit -m "Remove .DS_Store"

# .gitignore prüfen
cat .gitignore
```

### Username/Password wird ständig gefragt

**Lösung:**
```bash
# Credentials cachen (macOS)
git config --global credential.helper osxkeychain
```

---

## 📚 Weiterführende Links

- [GitHub Docs - Creating a repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
- [GitHub Docs - About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)
- [GitHub Docs - Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

---

**Viel Erfolg beim Upload! 🚀**

