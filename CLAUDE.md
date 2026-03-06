# AI-Kommandozentrale

## Sprache
Antworte immer auf Deutsch. Technische Begriffe und Code bleiben auf Englisch.

## Task Routing
- 3+ unabhaengige Tasks ohne Shared State -> Parallele Subagents dispatchen
- Tasks mit Abhaengigkeiten -> Sequentielle Ausfuehrung
- Research/Analyse-Tasks -> Background Agent oder Deep Research Skill
- Komplexe Multi-File-Features -> Agent Team starten
- Einfache Einzelaufgaben -> Direkt ausfuehren

## Code Style
- TypeScript/JavaScript: ESM imports, strict mode, keine any-Types
- Rust: clippy-clean, cargo fmt, idiomatic error handling mit Result<T, E>
- Python: Type hints, f-strings, pathlib statt os.path
- Alle Sprachen: Beschreibende Variablennamen, keine Abkuerzungen

## Workflow
- Immer zuerst lesen und verstehen, dann aendern
- Tests vor Implementierung schreiben (TDD wenn moeglich)
- Nie direkt auf main pushen -- Feature-Branches nutzen
- Commits: Konventionelle Commits (feat:, fix:, refactor:, docs:, test:)
- Bei Unsicherheit: Plan Mode nutzen, dann phasenweise umsetzen

## Git
- Branch-Naming: feat/<name>, fix/<name>, refactor/<name>
- Commit Messages auf Englisch, kurz und praegnant
- PR-Beschreibungen mit Summary und Test Plan

## Qualitaet
- Kein Code ohne Tests deployen
- Security: OWASP Top 10 beachten, keine Secrets in Code
- Performance: Lazy Loading, keine unnoetige N+1 Queries
- Error Handling: Graceful degradation, keine swallowed errors

## Skills
- Fuer Web-Recherche: deep-research Skill nutzen
- Fuer AI/ML-Research: Orchestra Research Skills nutzen
- Fuer kreative Ideenfindung: brainstorming-research-ideas
- Fuer Code Reviews: code-review Skill

## Subagent-Modell
- Hauptsession: Opus (komplexes Reasoning)
- Subagents: Sonnet (fokussierte Tasks, kosteneffizient)
