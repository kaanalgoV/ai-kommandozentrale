# Skills Installation

## Orchestra Research AI-Research-SKILLs (82 Skills)

```bash
npx @orchestra-research/ai-research-skills install
```

Installiert 82+ AI/ML-Research-Skills nach `~/.claude/skills/`.

## Deep Research Skill (199-biotechnologies)

```bash
cd /tmp
git clone https://github.com/199-biotechnologies/claude-deep-research-skill.git
cp -r claude-deep-research-skill ~/.claude/skills/deep-research
```

Aufruf: "Use deep research to [Frage]" oder "Deep research in ultradeep mode: [Frage]"

### Modi

| Modus | Phasen | Dauer | Wann nutzen |
|-------|--------|-------|-------------|
| Quick | 3 | 2-5 min | Schnelle Erkundung |
| Standard | 6 | 5-10 min | Default |
| Deep | 8 | 10-20 min | Wichtige Entscheidungen |
| UltraDeep | 8+ | 20-45 min | Umfassende Reports |

## Empfohlene weitere Skills

- [K-Dense-AI/claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills) -- 170+ wissenschaftliche Skills
- [standardhuman/deep-research-skill](https://github.com/standardhuman/deep-research-skill) -- 7-Phasen mit Domain-Overlays
