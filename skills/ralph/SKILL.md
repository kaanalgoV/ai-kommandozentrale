---
name: "ralph"
description: "Start a Ralph Loop with auto-generated PRD. Creates a structured PROMPT.md, then runs the iterative Ralph loop in the current session. Use /ralph <task description> to start."
argument-hint: "TASK_DESCRIPTION [--max-iterations N] [--completion-promise TEXT]"
---

# Ralph - PRD-Driven Ralph Loop

Start a Ralph Loop with an automatically generated PRD (Product Requirements Document) file.

## What This Does

1. Takes your task description
2. Creates a structured `PROMPT.md` PRD file in the project root
3. Starts the Ralph Loop using that PRD as the prompt
4. Everything runs in a single window - no worktrees needed

## Execution Steps

### Step 1: Parse Arguments

Extract from `$ARGUMENTS`:
- **Task description**: Everything that is not a flag
- **--max-iterations N**: Optional iteration limit (default: 20)
- **--completion-promise TEXT**: Optional completion signal (default: "TASK COMPLETE")

If no arguments provided, ask the user what they want to build.

### Step 2: Generate PROMPT.md PRD

Create a `PROMPT.md` file in the current project root with this structure:

```markdown
# PRD: [Task Title]

## Objective
[Clear, concise goal derived from the task description]

## Requirements
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]
(derive 3-7 concrete requirements from the task description)

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
(derive testable criteria that map to requirements)

## Constraints
- Work within the existing codebase and architecture
- Follow project conventions (see CLAUDE.md)
- All changes must have tests

## Current Iteration Context
This file is used by a Ralph Loop. Each iteration:
1. Read this PRD
2. Check current state of implementation
3. Work on the next uncompleted acceptance criterion
4. Run tests to verify
5. Mark completed criteria with [x]

When ALL acceptance criteria are checked [x] and tests pass, output:
<promise>TASK COMPLETE</promise>
```

Write this file using the Write tool. Derive the content intelligently from the user's task description - don't just copy it verbatim, expand it into proper requirements.

### Step 3: Start Ralph Loop

Run the Ralph Loop setup script via Bash:

```bash
bash ~/.claude/plugins/cache/claude-plugins-official/ralph-loop/*/scripts/setup-ralph-loop.sh "$(cat PROMPT.md)" --max-iterations 20 --completion-promise "TASK COMPLETE"
```

If the user provided custom `--max-iterations` or `--completion-promise`, use those values instead of the defaults.

### Step 4: Begin Working

After the loop is set up:
1. Read the PROMPT.md
2. Analyze the current project state
3. Start working on the first uncompleted acceptance criterion
4. The Ralph Loop stop hook will handle iteration

## Important Rules

- ALWAYS create PROMPT.md before starting the loop
- Default to --max-iterations 20 and --completion-promise "TASK COMPLETE" if not specified
- The PRD should be specific and actionable, not vague
- Each iteration should make measurable progress
- Mark acceptance criteria as done ([x]) as you complete them
- Only output `<promise>TASK COMPLETE</promise>` when ALL criteria are genuinely met
