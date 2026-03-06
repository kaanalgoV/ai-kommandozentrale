# AI-Kommandozentrale

Claude Code als vollstaendige AI-Agent-Kommandozentrale konfiguriert. Basierend auf einem [Deep Research Report](research/research_report_20260307_claude_code_config.md) mit 28 Quellen.

## Was ist das?

Ein komplettes, teilbares Setup fuer Claude Code mit:

- **CLAUDE.md** -- Globale Konfiguration mit Task-Routing-Framework
- **23 Spezialisierte Agents** -- Von Architecture bis Testing
- **40+ Helper Scripts** -- Hooks, Memory, Session Management, Statusline
- **Settings Template** -- Permissions, Hooks, Agent Teams, MCP, Claude Flow v3
- **Skills Guide** -- Deep Research + Orchestra Research (82 AI/ML Skills)

## Architektur: 5 Schichten

```
Schicht 5: MCP-Server          (GitHub, Context7, Filesystem)
Schicht 4: Agent Teams          (Team Lead + Teammates + Shared Tasks)
Schicht 3: Hooks                (PreToolUse, PostToolUse, SessionStart...)
Schicht 2: Skills               (Deep Research, Orchestra Research, Domain-spezifisch)
Schicht 1: CLAUDE.md + Settings (Konfiguration, Permissions, Routing)
```

## Quick Start

```bash
# 1. Repo klonen
git clone https://github.com/kaanalgoV/ai-kommandozentrale.git
cd ai-kommandozentrale

# 2. Installer ausfuehren
./install.sh

# 3. API-Keys eintragen
vim ~/.claude/settings.json

# 4. Skills installieren
npx @orchestra-research/ai-research-skills
```

## Verzeichnisstruktur

```
ai-kommandozentrale/
  CLAUDE.md                  # Globale Konfiguration (Routing, Style, Workflow)
  settings.template.json     # Settings ohne Secrets (Permissions, Hooks, MCP)
  install.sh                 # One-Click Installer
  agents/                    # 23 spezialisierte Subagent-Definitionen
    analysis/                # Code-Analyse Agent
    architecture/            # Architektur-Entscheidungen
    browser/                 # Browser-Automation
    core/                    # Core Development
    development/             # Feature Development
    devops/                  # CI/CD und Infrastructure
    documentation/           # Doku-Generierung
    github/                  # GitHub-Integration
    optimization/            # Performance-Optimierung
    sparc/                   # SPARC Methodology
    swarm/                   # Multi-Agent Orchestrierung
    testing/                 # Test-Strategie
    ...
  helpers/                   # 40+ Hook- und Utility-Skripte
    hook-handler.cjs         # Zentraler Hook-Router
    auto-memory-hook.mjs     # Persistentes Memory
    statusline.cjs           # Statuszeile
    router.js                # Task-Routing
    session.js               # Session Management
    ...
  skills/
    INSTALL.md               # Installationsanleitung fuer Skills
  research/
    research_report_*.md     # Deep Research Report (Markdown)
    research_report_*.html   # Deep Research Report (McKinsey-Style HTML)
```

## Features im Detail

### Agent Teams (experimentell, Feb 2026)

```bash
# Aktiviert via settings.json:
# "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"

# Starten mit tmux fuer Split Panes:
claude --worktree feature-auth --tmux
```

- **Team Lead**: Erstellt Tasks, spawnt Teammates, synthetisiert Ergebnisse
- **Teammates**: Unabhaengige Sessions, direkte Kommunikation
- **Shared Task List**: Dependency-Tracking mit Auto-Unblock

### Git Worktrees fuer Multi-Projekt

```bash
claude --worktree feature-auth           # Isolierter Worktree
claude --worktree feature-auth --tmux    # Mit eigenem Terminal
```

### Hooks

| Event | Zweck |
|-------|-------|
| PreToolUse | Bash-Befehle validieren |
| PostToolUse | Auto-Formatting nach Edits |
| UserPromptSubmit | Task-Routing |
| SessionStart | Memory laden, Session restore |
| SessionEnd | Session speichern |
| Stop | Memory sync |
| PreCompact | Context-Management |
| SubagentStart | Status-Tracking |

### Skills

| Skill | Aufruf | Zweck |
|-------|--------|-------|
| Deep Research | "Use deep research to..." | Web-Recherche, 8-Phasen-Pipeline |
| Orchestra Research | Automatisch bei AI/ML-Themen | 82 AI/ML-Research Skills |
| Brainstorming | "Hilf mir Ideen zu brainstormen" | Strukturierte Ideenfindung |

### Kosten-Optimierung

```
Hauptsession:  Opus     (komplexes Reasoning)
Subagents:     Sonnet   (fokussierte Tasks)

env: CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6
```

## Quellen

Dieser Setup basiert auf einem Deep Research Report mit 28 verifizierten Quellen:

- [Anthropic Claude Code Docs](https://code.claude.com/docs/)
- [Claude Code Best Practices](https://github.com/shanraisshan/claude-code-best-practice)
- [AI OS Blueprint](https://dev.to/jan_lucasandmann_bb9257c/claude-code-to-ai-os-blueprint-skills-hooks-agents-mcp-setup-in-2026-46gg)

Vollstaendiger Report: [research/research_report_20260307_claude_code_config.md](research/research_report_20260307_claude_code_config.md)

## Lizenz

MIT
