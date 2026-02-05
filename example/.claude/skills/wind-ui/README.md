# Wind UI Skill — Setup Guide

Claude Code skill for working with the Wind UI framework in Flutter projects.

## Installation

### Project-Level (shared with team)

```bash
mkdir -p .claude/skills/wind-ui/references
cp /path/to/wind-ui/SKILL.md .claude/skills/wind-ui/
cp /path/to/wind-ui/references/*.md .claude/skills/wind-ui/references/
```

Or symlink to the plugin:
```bash
ln -s ../../plugins/fluttersdk_wind/example/.claude/skills/wind-ui .claude/skills/wind-ui
```

### Personal (all projects)

```bash
mkdir -p ~/.claude/skills/wind-ui/references
cp /path/to/wind-ui/SKILL.md ~/.claude/skills/wind-ui/
cp /path/to/wind-ui/references/*.md ~/.claude/skills/wind-ui/references/
```

## How It Works

1. **Metadata always loaded** — `description` field triggers on Wind widgets/className mentions
2. **SKILL.md on activation** — Widget table, patterns, gotchas (~200 lines)
3. **References on demand** — `utilities.md` and `theme.md` loaded when needed

## CLAUDE.md Integration

Add to your project's `CLAUDE.md`:

```markdown
## Wind UI Rules

- All views use Wind widgets (WDiv, WText, WButton, etc.)
- Styling via `className` strings, never inline Flutter styling
- Dark mode: always `dark:` prefix variants
- Responsive: `sm:/md:/lg:/xl:/2xl:` prefixes (mobile-first)
- Spacing: N * 4px (`p-4` = 16px)
```

## Usage

Automatic (recommended):
```
> Build a responsive card grid with dark mode support
> Add WFormInput with validation to this form
```

Manual:
```
> /wind-ui create a sidebar layout
```

## Verification

```
> What skills are available?
```

`wind-ui` should appear. If not, check:
1. File exists: `.claude/skills/wind-ui/SKILL.md`
2. Valid YAML frontmatter (`name`, `description`)

## Directory Structure

```
.claude/skills/wind-ui/
├── SKILL.md           # Main skill (~200 lines)
├── README.md          # This file
└── references/
    ├── utilities.md   # All utility classes (~260 lines)
    └── theme.md       # Theme scales (~130 lines)
```
