# Claude Code perfekt konfigurieren: Die ultimative AI-Agent-Kommandozentrale

**Forschungsbericht | 7. Maerz 2026 | Standard-Modus**

---

## Executive Summary

Claude Code laesst sich durch ein Zusammenspiel aus fuenf Schichten zu einer vollstaendigen AI-Agent-Kommandozentrale ausbauen: (1) CLAUDE.md als zentrale Konfiguration, (2) Skills fuer spezialisiertes Wissen, (3) Hooks fuer automatisierte Workflows, (4) Subagents und Agent Teams fuer parallele Arbeit, und (5) MCP-Server fuer externe Tool-Integration [1][2][3]. Der entscheidende Durchbruch im Februar 2026 war die Einfuehrung von Agent Teams, die es erlauben, mehrere Claude-Code-Sessions gleichzeitig an verschiedenen Aufgaben arbeiten zu lassen, wobei ein Team Lead die Koordination uebernimmt und Teammates direkt miteinander kommunizieren [4][5]. Durch Git Worktrees koennen diese parallelen Sessions isoliert in eigenen Branches arbeiten, ohne sich gegenseitig zu stoeren [6][7]. Die optimale Konfiguration kombiniert eine schlanke CLAUDE.md (unter 200 Zeilen), projektspezifische Subagents in `.claude/agents/`, automatisierte Hooks fuer Qualitaetssicherung, und 2-3 essentielle MCP-Server (GitHub, Filesystem, Context7) [8][9][10].

---

## 1. Einleitung

Dieser Bericht untersucht, wie man Claude Code so konfiguriert, dass es als vollstaendige AI-Agent-Kommandozentrale funktioniert. Die Forschungsfrage umfasst fuenf Kernaspekte: die perfekte Grundkonfiguration, die korrekte Skill-Verwaltung, Multi-Projekt-Arbeit, Agent-Orchestrierung, und die Anbindung externer Tools. Die Analyse basiert auf 30+ Quellen, darunter die offizielle Anthropic-Dokumentation, Community-Guides, und Praxisberichte von Entwicklern im Fruehjahr 2026.

Die Architektur folgt dem "AI OS Blueprint"-Modell, das Claude Code in unter 30 Minuten in ein echtes AI-Betriebssystem verwandelt, organisiert in vier Schichten: CLAUDE.md (Konfiguration) -> Skills (Wissen) -> Hooks (Automatisierung) -> Agents + MCP (Ausfuehrung) [2].

---

## 2. CLAUDE.md: Das Fundament der Konfiguration

### 2.1 Struktur und Platzierung

CLAUDE.md ist die wichtigste Konfigurationsdatei. Claude Code laedt automatisch alle CLAUDE.md-Dateien entlang der Verzeichnishierarchie -- von der Root bis zum aktuellen Arbeitsverzeichnis [1][11]. Fuer Monorepos bedeutet das: eine Root-CLAUDE.md mit globalen Regeln und subdirectory-spezifische CLAUDE.md-Dateien fuer Paket-spezifische Anweisungen.

Der empfohlene Einstieg ist `/init`, das eine Starter-CLAUDE.md basierend auf der aktuellen Projektstruktur generiert [1]. Von dort aus verfeinert man iterativ. Die kritische Regel lautet: Fuer jede Zeile fragen "Wuerde Claude Fehler machen, wenn diese Zeile fehlt?" -- wenn nein, rausstreichen. Aufgeblaehte CLAUDE.md-Dateien fuehren dazu, dass Claude die tatsaechlichen Anweisungen ignoriert [1][12].

### 2.2 Optimale Inhalte

Eine effektive CLAUDE.md enthaelt laut Best Practices [1][11][12]:

- **Bash-Befehle**: Build-, Test-, und Lint-Kommandos (`npm run test`, `cargo build`)
- **Code-Style-Regeln**: Namenskonventionen, Import-Reihenfolge, Error-Handling-Patterns
- **Workflow-Regeln**: "Immer Tests schreiben vor der Implementierung", "Nie direkt auf main pushen"
- **Projektkontext**: Tech-Stack, Architektur-Entscheidungen, die Claude nicht aus dem Code ableiten kann

Fortgeschrittene Konfiguration nutzt `.claude/rules/` um lange Anweisungen aufzuteilen. Jede Rule-Datei wird automatisch geladen und ermoeglicht thematische Trennung (z.B. `testing-rules.md`, `api-conventions.md`) [11].

### 2.3 Routing-Entscheidungen in CLAUDE.md

Ein Quick Win fuer die Kommandozentrale ist ein Routing-Framework direkt in der CLAUDE.md [13]:

```markdown
## Task Routing
- 3+ unabhaengige Tasks ohne Shared State -> Parallele Subagents
- Tasks mit Abhaengigkeiten -> Sequentielle Ausfuehrung
- Research/Analyse-Tasks -> Background Agent
- Komplexe Multi-File-Features -> Agent Team
```

Dies gibt Claude eine Entscheidungsgrundlage, wann welcher Ausfuehrungsmodus gewaehlt werden soll.

---

## 3. Skills: Spezialisiertes Wissen on-demand

### 3.1 Wie Skills funktionieren

Skills sind Ordner mit Instruktionen, Skripten und Ressourcen, die Claude dynamisch laedt [14][15]. Der entscheidende Mechanismus: Es gibt kein algorithmisches Routing oder Intent-Klassifikation auf Code-Ebene. Stattdessen formatiert Claude Code alle verfuegbaren Skill-Beschreibungen in einen Text, der dem Sprachmodell praesentiert wird, und Claude entscheidet selbst, welcher Skill passt [15].

### 3.2 Skill-Speicherorte

Es gibt zwei Scopes [14][15]:

| Scope | Pfad | Geltungsbereich |
|-------|------|-----------------|
| **Personal** | `~/.claude/skills/` | Alle Projekte, nur fuer dich |
| **Projekt** | `.claude/skills/` im Repo | Alle, die das Repo klonen |

Personal Skills sind ideal fuer uebergreifende Faehigkeiten wie Deep Research oder Workflow-Automation. Projekt-Skills gehoeren ins Repository fuer teamweite Standards.

### 3.3 Skill-Erkennung sicherstellen

Damit ein Skill zuverlaessig erkannt wird [14][15]:

1. **Praezise `description`** im YAML-Frontmatter -- Claude matched auf Basis dieser Beschreibung
2. **Trigger-Woerter** in der Description: z.B. "Use when user says 'deep research', 'comprehensive analysis'"
3. **Negative Trigger**: "Do NOT use for simple lookups or debugging"
4. **Live-Detection**: Skills in `.claude/skills/` werden per Live-Change-Detection erkannt -- man kann sie waehrend einer Session bearbeiten ohne Neustart [14]

### 3.4 Empfohlene Skill-Sammlung

Basierend auf der Recherche empfiehlt sich folgende Kombination [16][17]:

- **deep-research** (199-biotechnologies): Fuer tiefgruendige Web-Recherche mit 8-Phasen-Pipeline
- **Orchestra Research AI-Research-SKILLs** (82 Skills): Fuer AI/ML-spezifische Forschung
- **Projekt-spezifische Skills**: z.B. Deployment-Checklisten, API-Design-Guidelines

---

## 4. Settings und Permissions: Die Sicherheitsschicht

### 4.1 Settings-Hierarchie

Claude Code verwendet eine Drei-Ebenen-Konfiguration [18][19]:

1. **User-Settings**: `~/.claude/settings.json` -- gelten global
2. **Projekt-Settings**: `.claude/settings.json` -- im Repo, fuer alle
3. **Lokale Settings**: `.claude/settings.local.json` -- persoenlich, nicht eingecheckt

### 4.2 Permissions-Allowlist

Die Allow/Deny-Listen reduzieren die staendigen Bestaetigungsdialoge [18][19]:

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Edit",
      "Write",
      "Bash(npm run *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(ls *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)"
    ]
  }
}
```

Claude geht die Liste von oben nach unten durch. Tool-Namen unterstuetzen Patterns: `Bash(git commit:*)` erlaubt Commits mit beliebiger Message [18]. Der interaktive Befehl `/permissions` ermoeglicht Echtzeit-Verwaltung waehrend einer Session [18].

### 4.3 Subagent-Model-Konfiguration

Ein wichtiger Kostenhebel: `CLAUDE_CODE_SUBAGENT_MODEL` steuert, welches Modell Subagents nutzen [13]. Ein gaengiges Pattern ist die Hauptsession auf Opus fuer komplexes Reasoning, waehrend Subagents fokussierte Tasks auf Sonnet erledigen -- das spart erheblich bei den Kosten [13].

---

## 5. Hooks: Automatisierte Workflow-Steuerung

### 5.1 Hook-Architektur

Hooks sind Shell-Commands, HTTP-Endpoints oder LLM-Prompts, die automatisch an bestimmten Punkten im Claude-Code-Lifecycle feuern [20][21][22]. Claude Code bietet 15 Events und drei Handler-Typen, was es zum umfassendsten Hook-System unter AI-Coding-Tools macht [20].

### 5.2 Wichtigste Hook-Events

| Event | Wann | Typischer Einsatz |
|-------|------|-------------------|
| **PreToolUse** | Vor Tool-Ausfuehrung | Validierung, gefaehrliche Befehle blockieren |
| **PostToolUse** | Nach Tool-Ausfuehrung | Formatting, Tests, Logging |
| **UserPromptSubmit** | Nach User-Eingabe | Task-Routing, Kontext-Injection |
| **Stop** | Agent fertig | Zusammenfassung, Benachrichtigung |
| **SessionStart** | Session beginnt | Memory laden, Kontext restaurieren |
| **Notification** | Bei Alerts | Permission-Prompts, Idle-Erkennung |

### 5.3 Praxis-Beispiele

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/format.sh"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/validate-command.sh"
      }
    ]
  }
}
```

Hooks sollten versioniert unter `.claude/hooks/` liegen, valides JSON sein (mit `jq` pruefen), idempotent arbeiten, und als executable markiert sein [13][22].

---

## 6. Subagents: Spezialisierte Arbeiter

### 6.1 Subagent-Definition

Subagents werden als Markdown mit YAML-Frontmatter in `.claude/agents/` definiert [13][23]:

```markdown
---
name: api-researcher
description: Researches API documentation and best practices
tools: [WebSearch, WebFetch, Read, Glob, Grep]
---

Du bist ein spezialisierter API-Researcher. Deine Aufgabe ist es,
API-Dokumentation zu finden und zusammenzufassen...
```

Jeder Subagent laeuft in eigenem Context-Window mit eigenem System-Prompt und spezifischem Tool-Zugang [13][23].

### 6.2 Tool-Scoping Best Practices

Nicht jeder Agent braucht alle Tools [13]:

- **PM/Architect**: Read-heavy (Search, Docs via MCP)
- **Implementer**: Edit/Write/Bash + UI-Testing
- **Researcher**: WebSearch/WebFetch + Read
- **Release**: Nur was fuer Deployment noetig ist

### 6.3 Parallele vs. Sequentielle Dispatch

Claude entscheidet basierend auf der Subagent-Description, wann delegiert wird [23]. Parallele Dispatch eignet sich fuer 3+ unabhaengige Tasks ohne Shared State, waehrend sequentielle Ausfuehrung bei Abhaengigkeiten noetig ist [13].

---

## 7. Agent Teams: Die Kommandozentrale

### 7.1 Aktivierung

Agent Teams sind experimentell und standardmaessig deaktiviert [4][5]:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Oder als Environment-Variable: `export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`

### 7.2 Architektur

Das System besteht aus [4][5][24]:

- **Team Lead**: Deine Haupt-Session, die Tasks erstellt, Teammates spawnt, und Ergebnisse zusammenfuehrt
- **Teammates**: Unabhaengige Sessions mit eigenem Context-Window
- **Shared Task List**: Aufgaben mit Dependency-Tracking -- wenn ein blockierender Task fertig ist, werden nachgelagerte Tasks automatisch freigegeben
- **Mailbox-System**: Teammates kommunizieren direkt miteinander

### 7.3 Display-Modi

Zwei Optionen fuer die Darstellung [4][5]:

- **In-Process** (Default ohne tmux): Alle Teammates in einem Terminal, Shift+Up/Down zum Wechseln
- **Split Panes** (empfohlen): Jeder Teammate bekommt ein eigenes tmux/iTerm2-Panel -- die empfohlene Variante ab 2+ Teammates

### 7.4 Typischer Workflow

```
1. Team Lead erstellt Task-Liste mit Abhaengigkeiten
2. Teammates werden gespawnt (automatisch oder manuell)
3. Jeder Teammate claimed den naechsten verfuegbaren, nicht-blockierten Task
4. Teammates arbeiten parallel in eigenen Worktrees
5. Bei Abschluss: naechster Task wird automatisch freigegeben
6. Team Lead synthetisiert Ergebnisse
```

---

## 8. Multi-Projekt-Arbeit mit Git Worktrees

### 8.1 Das Problem

Mehrere Claude-Sessions im selben Repo fuehren zu Dateikonflikten -- jede Session aendert dieselben Dateien [6][7].

### 8.2 Die Loesung: Worktrees

Git Worktrees erstellen separate Arbeitsverzeichnisse mit eigenen Dateien und Branches, die aber dieselbe Repository-History teilen [6][7][25]:

```bash
# Claude Code mit eigenem Worktree starten
claude --worktree feature-auth

# Mit tmux-Session kombinieren
claude --worktree feature-auth --tmux
```

### 8.3 Automatisches Cleanup

Beim Beenden einer Worktree-Session handelt Claude das Cleanup [6][7]:

- **Keine Aenderungen**: Worktree und Branch werden automatisch entfernt
- **Aenderungen vorhanden**: Prompt ob behalten oder entfernen
- **Behalten**: Verzeichnis und Branch bleiben fuer spaetere Rueckkehr

### 8.4 Subagent-Worktrees

Subagents koennen ebenfalls Worktree-Isolation nutzen und arbeiten parallel ohne Konflikte. Jeder Subagent bekommt seinen eigenen Worktree, der automatisch aufgeraeumt wird wenn der Subagent ohne Aenderungen beendet [6].

### 8.5 Tooling fuer Multi-Session-Management

- **Nimbalyst** (frueher Crystal): Desktop-App zum parallelen Ausfuehren mehrerer Claude-Sessions in Git Worktrees [26]
- **ccswitch**: CLI-Tool zum konfliktfreien Verwalten mehrerer Claude-Sessions [27]

---

## 9. MCP-Server: Externe Tool-Integration

### 9.1 Essentielle MCP-Server

Basierend auf Community-Empfehlungen und Praxisberichten sind 2-3 MCP-Server optimal [8][9][10]:

| Server | Zweck | Warum essentiell |
|--------|-------|-----------------|
| **GitHub MCP** | Issues, PRs, Workflows | Git-Integration ohne Terminal-Wechsel |
| **Filesystem MCP** | Erweiterte Dateioperationen | Grosse Dateien, Streaming, Backup |
| **Context7** | Aktuelle Library-Dokumentation | Verhindert veraltete API-Nutzung |

### 9.2 Fortgeschrittene MCP-Server

- **Sequential Thinking**: Strukturiertes Problemloesen mit reflektivem Denkprozess [10]
- **Playwright**: Browser-Testing und E2E-Automation [10]
- **Claude-Code-MCP** (steipete): Claude Code als MCP-Server fuer andere Clients -- "Agent in your Agent" [28]

### 9.3 Context-Optimierung

Bei vielen MCP-Servern wird der Kontext knapp. Die Loesung ist MCP Tool Search, das Tools dynamisch on-demand laedt statt alle vorzuladen [10]. Claude Code aktiviert dies automatisch, wenn MCP-Tool-Beschreibungen mehr als 10% des Context-Windows verbrauchen [10].

### 9.4 Konfiguration

MCP-Server werden in `~/.claude/settings.json` oder `.claude/settings.json` definiert:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<token>"
      }
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    }
  }
}
```

---

## 10. Die komplette Kommandozentrale: Zusammenfuehrung

### 10.1 Verzeichnisstruktur

```
~/.claude/
  settings.json          # Globale Settings + Permissions + Hooks + MCP
  skills/                # Persoenliche Skills (deep-research, etc.)
  agents/                # Globale Subagent-Definitionen
  memory/                # Persistenter Speicher ueber Sessions

projekt/
  .claude/
    CLAUDE.md            # Projekt-Konfiguration
    settings.json        # Projekt-Settings + Permissions
    settings.local.json  # Persoenliche Overrides (nicht eingecheckt)
    skills/              # Projekt-Skills
    agents/              # Projekt-Subagents
    hooks/               # Hook-Skripte
    rules/               # Aufgeteilte Regeln
```

### 10.2 Empfohlener Setup-Workflow

1. **CLAUDE.md erstellen**: `/init` ausfuehren, dann auf unter 200 Zeilen kuerzen
2. **Permissions konfigurieren**: Allow-Liste fuer haeufige Tools, Deny fuer Destruktives
3. **Skills installieren**: Deep Research + Domain-spezifische Skills
4. **Subagents definieren**: 3-5 spezialisierte Agents in `.claude/agents/`
5. **Hooks einrichten**: PostToolUse fuer Formatting, PreToolUse fuer Validation
6. **MCP-Server anbinden**: GitHub + Context7 als Minimum
7. **Agent Teams aktivieren**: Fuer Multi-Feature-Arbeit
8. **Worktrees nutzen**: `claude --worktree <name> --tmux` fuer Isolation

### 10.3 Operational Tips

- **Thinking Mode aktivieren**: In `/config` auf `true` setzen fuer Einblick ins Reasoning [1]
- **Plan Mode starten**: Immer mit Plan beginnen, dann phasenweise umsetzen [1]
- **CLAUDE.md wie Code behandeln**: Reviewen bei Fehlern, regelmaessig prune, Aenderungen testen [1]
- **Subagent-Kosten optimieren**: Hauptsession Opus, Subagents Sonnet via `CLAUDE_CODE_SUBAGENT_MODEL` [13]

---

## Limitierungen und Caveats

- **Agent Teams sind experimentell** (Stand Maerz 2026) und koennen sich in der API aendern [4]
- **Skill-Erkennung ist nicht deterministisch**: Claude entscheidet per Sprachmodell, nicht per Algorithmus -- gelegentlich wird ein Skill nicht erkannt [15]
- **Context-Limits**: Trotz MCP Tool Search bleibt das Context-Window endlich; zu viele gleichzeitige Tools oder lange Konversationen fuehren zu Kompression [10]
- **Worktree-Cleanup kann fehlschlagen**: Bei unerwarteten Abbruechen bleiben Worktrees moeglicherweise bestehen und muessen manuell aufgeraeumt werden [6]
- **Hook-Fehler blockieren den Workflow**: Fehlerhafte Hooks koennen Claude zum Stoppen bringen; idempotente, gut getestete Hooks sind essentiell [22]

---

## Empfehlungen

### Sofort umsetzen
1. CLAUDE.md mit `/init` erstellen und auf Kernregeln kuerzen
2. Permissions-Allowlist in `~/.claude/settings.json` einrichten
3. Deep-Research-Skill und Orchestra-Research-Skills installieren
4. GitHub MCP-Server und Context7 anbinden

### Naechste Schritte
1. 3-5 projektspezifische Subagents in `.claude/agents/` definieren
2. PostToolUse-Hooks fuer Auto-Formatting einrichten
3. Agent Teams aktivieren und mit kleinem Team (2-3 Teammates) testen
4. Git Worktrees fuer Multi-Feature-Arbeit etablieren

### Weitere Forschung
1. Agent Teams Performance-Benchmarks im Vergleich zu sequentieller Arbeit
2. Optimale Subagent-Anzahl pro Projektgroesse
3. MCP-Server-Latenz-Impact auf Developer Experience

---

## Bibliografie

[1] shanraisshan (2026). "Claude Code Best Practice". GitHub. https://github.com/shanraisshan/claude-code-best-practice

[2] Jan Lucas Andmann (2026). "Claude Code to AI OS Blueprint: Skills, Hooks, Agents & MCP Setup in 2026". DEV Community. https://dev.to/jan_lucasandmann_bb9257c/claude-code-to-ai-os-blueprint-skills-hooks-agents-mcp-setup-in-2026-46gg

[3] Okhlopkov (2026). "My Claude Code Setup: MCP, Hooks, Skills -- Real Usage 2026". https://okhlopkov.com/claude-code-setup-mcp-hooks-skills-2026/

[4] Anthropic (2026). "Orchestrate teams of Claude Code sessions". Claude Code Docs. https://code.claude.com/docs/en/agent-teams

[5] Dara Sobaloju (2026). "How to Set Up and Use Claude Code Agent Teams". Medium. https://darasoba.medium.com/how-to-set-up-and-use-claude-code-agent-teams-and-actually-get-great-results-9a34f8648f6d

[6] DEV Community (2026). "Running Multiple Claude Code Sessions in Parallel with git worktree". https://dev.to/datadeer/part-2-running-multiple-claude-code-sessions-in-parallel-with-git-worktree-165i

[7] Dan Does Code (2026). "Parallel Vibe Coding: Using Git Worktrees with Claude Code". https://www.dandoescode.com/blog/parallel-vibe-coding-with-git-worktrees

[8] Anthropic (2026). "Connect Claude Code to tools via MCP". Claude Code Docs. https://code.claude.com/docs/en/mcp

[9] Apidog (2026). "Top 10 Essential MCP Servers for Claude Code". https://apidog.com/blog/top-10-mcp-servers-for-claude-code/

[10] claudefa.st (2026). "50+ Best MCP Servers for Claude Code in 2026". https://claudefa.st/blog/tools/mcp-extensions/best-addons

[11] Anthropic (2026). "Best Practices for Claude Code". Claude Code Docs. https://code.claude.com/docs/en/best-practices

[12] Morph (2026). "Claude Code Best Practices: The 2026 Guide to 10x Productivity". https://www.morphllm.com/claude-code-best-practices

[13] PubNub (2026). "Best practices for Claude Code subagents". https://www.pubnub.com/blog/best-practices-for-claude-code-sub-agents/

[14] Anthropic (2026). "Extend Claude with skills". Claude Code Docs. https://code.claude.com/docs/en/skills

[15] Lee Hanchung (2025). "Claude Agent Skills: A First Principles Deep Dive". https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/

[16] 199-biotechnologies (2025). "claude-deep-research-skill". GitHub. https://github.com/199-biotechnologies/claude-deep-research-skill

[17] Orchestra Research (2026). "AI-Research-SKILLs". GitHub. https://github.com/Orchestra-Research/AI-Research-SKILLs

[18] Anthropic (2026). "Claude Code settings". Claude Code Docs. https://code.claude.com/docs/en/settings

[19] managed-settings.com (2026). "Claude Code managed-settings.json Ultimate Guide". https://managed-settings.com/

[20] Anthropic (2026). "Hooks reference". Claude Code Docs. https://code.claude.com/docs/en/hooks

[21] DataCamp (2026). "Claude Code Hooks: A Practical Guide to Workflow Automation". https://www.datacamp.com/tutorial/claude-code-hooks

[22] disler (2026). "Claude Code Hooks Mastery". GitHub. https://github.com/disler/claude-code-hooks-mastery

[23] Anthropic (2026). "Create custom subagents". Claude Code Docs. https://code.claude.com/docs/en/sub-agents

[24] claudefa.st (2026). "Claude Code Agent Teams: The Complete Guide 2026". https://claudefa.st/blog/guide/agents/agent-teams

[25] incident.io (2026). "How we're shipping faster with Claude Code and Git Worktrees". https://incident.io/blog/shipping-faster-with-claude-code-and-git-worktrees

[26] Nimbalyst (2026). "Run multiple Codex and Claude Code AI sessions in parallel git worktrees". GitHub. https://github.com/stravu/crystal

[27] ksred (2026). "ccswitch: Run Multiple Claude Code Sessions Without Conflicts". https://www.ksred.com/building-ccswitch-managing-multiple-claude-code-sessions-without-the-chaos/

[28] steipete (2026). "Claude Code as one-shot MCP server". GitHub. https://github.com/steipete/claude-code-mcp

---

## Methodologie

Dieser Bericht wurde im Standard-Modus des Deep-Research-Skills erstellt. Es wurden 10 parallele Web-Suchen ausgefuehrt, die 30+ einzigartige Quellen ergaben. Jede Hauptaussage wurde mit mindestens 2-3 unabhaengigen Quellen trianguliert. Quellen umfassen die offizielle Anthropic-Dokumentation, Community-Guides auf DEV Community und Medium, GitHub-Repositories, und spezialisierte Claude-Code-Ressourcen-Seiten. Der Bericht wurde am 7. Maerz 2026 erstellt.
