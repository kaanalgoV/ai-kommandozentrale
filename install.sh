#!/bin/bash
set -euo pipefail

# AI-Kommandozentrale Installer
# Installiert die komplette Claude Code Konfiguration

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== AI-Kommandozentrale Installation ==="
echo ""

# 1. CLAUDE.md (global)
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "[OK] CLAUDE.md installiert"
else
  echo "[SKIP] CLAUDE.md existiert bereits"
fi

# 2. Agents
if [ -d "$SCRIPT_DIR/agents" ]; then
  mkdir -p "$CLAUDE_DIR/agents"
  cp -rn "$SCRIPT_DIR/agents/"* "$CLAUDE_DIR/agents/" 2>/dev/null || true
  echo "[OK] Agents kopiert"
fi

# 3. Helpers
if [ -d "$SCRIPT_DIR/helpers" ]; then
  mkdir -p "$CLAUDE_DIR/helpers"
  cp -rn "$SCRIPT_DIR/helpers/"* "$CLAUDE_DIR/helpers/" 2>/dev/null || true
  echo "[OK] Helpers kopiert"
fi

# 4. Settings Template
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
  echo ""
  echo "[INFO] Kein settings.json gefunden."
  echo "       Kopiere settings.template.json nach ~/.claude/settings.json"
  echo "       und passe MCP-Server/API-Keys an."
  cp "$SCRIPT_DIR/settings.template.json" "$CLAUDE_DIR/settings.json"
  echo "[OK] settings.json aus Template erstellt"
else
  echo "[SKIP] settings.json existiert bereits"
  echo "       Vergleiche mit settings.template.json fuer neue Features"
fi

# 5. Skills installieren
echo ""
echo "=== Skills Installation ==="
echo ""

# Deep Research Skill
if [ ! -d "$CLAUDE_DIR/skills/deep-research" ]; then
  echo "Installiere Deep Research Skill..."
  cd /tmp
  git clone --depth 1 https://github.com/199-biotechnologies/claude-deep-research-skill.git 2>/dev/null || true
  if [ -d "/tmp/claude-deep-research-skill" ]; then
    mkdir -p "$CLAUDE_DIR/skills"
    cp -r /tmp/claude-deep-research-skill "$CLAUDE_DIR/skills/deep-research"
    rm -rf /tmp/claude-deep-research-skill
    echo "[OK] Deep Research Skill installiert"
  fi
else
  echo "[SKIP] Deep Research Skill bereits vorhanden"
fi

# Orchestra Research Skills
echo ""
echo "Orchestra Research Skills installieren? (82 AI/ML Skills)"
echo "  Manuell ausfuehren: npx @orchestra-research/ai-research-skills"
echo ""

echo "=== Installation abgeschlossen ==="
echo ""
echo "Naechste Schritte:"
echo "  1. ~/.claude/settings.json pruefen und API-Keys eintragen"
echo "  2. Claude Code starten und /init in deinem Projekt ausfuehren"
echo "  3. Agent Teams testen: claude --worktree feature-test --tmux"
echo ""
