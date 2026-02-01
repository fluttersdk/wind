# Wind Usage Skill — Setup Guide

A guide for setting up and configuring this skill so that Claude Code (Opus 4.5) can work most effectively with the Wind UI framework in any Flutter project.

## Requirements

- [Claude Code CLI](https://code.claude.com) installed
- Flutter project using the Wind package (`fluttersdk_wind` dependency)

## Installation

### Method 1: Project-Level (Shared with team)

Copy the skill into your project's `.claude/skills/` directory. Anyone who clones the repo benefits from the skill.

```bash
# From your project root
mkdir -p .claude/skills/wind-ui/references

# Copy skill files
cp /path/to/wind-ui/SKILL.md .claude/skills/wind-ui/SKILL.md
cp /path/to/wind-ui/references/utilities.md .claude/skills/wind-ui/references/utilities.md
cp /path/to/wind-ui/references/theme.md .claude/skills/wind-ui/references/theme.md
```

Or from the `.skill` package:

```bash
# .skill file is a zip archive
unzip wind-ui.skill -d .claude/skills/
```

> **Note:** Do not add `.claude/skills/` to `.gitignore` — you want your team to benefit from the skill too.

### Method 2: Personal (Available across all your projects)

Place the skill in `~/.claude/skills/` to make it automatically active in all your projects that use Wind.

```bash
mkdir -p ~/.claude/skills/wind-ui/references
cp /path/to/wind-ui/SKILL.md ~/.claude/skills/wind-ui/SKILL.md
cp /path/to/wind-ui/references/*.md ~/.claude/skills/wind-ui/references/
```

## CLAUDE.md Configuration

The skill works on its own, but adding Wind-specific instructions to your project's `CLAUDE.md` improves effectiveness.

### CLAUDE.md File Hierarchy

| Location | File | Shared with |
|----------|------|-------------|
| Project (team) | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team via git |
| Project rules | `./.claude/rules/*.md` | Team via git |
| Personal (global) | `~/.claude/CLAUDE.md` | Just you |
| Project (personal) | `./CLAUDE.local.md` | Just you (gitignored) |

All memory files are automatically loaded when Claude Code launches. Higher levels take precedence.

### Recommended CLAUDE.md Content

Add the following to your project's `CLAUDE.md`:

```markdown
# Project Name

This project uses the FlutterSDK Wind UI framework.

## Commands

| Command | Description |
|---------|-------------|
| `flutter test` | Run all tests |
| `flutter run -d macos` | Run on macOS |
| `dart analyze` | Static analysis |

## Wind Usage Rules

- All UI widgets use Wind W-prefixed widgets (WDiv, WText, WButton, etc.)
- Styling is always done via `className` string parameter, never inline Flutter styling
- Use `flex`, `grid`, `wrap` display modes for layout
- Responsive design is mobile-first: `sm:`, `md:`, `lg:`, `xl:`, `2xl:` prefixes
- Dark mode: use `dark:` prefix
- Interaction states: `hover:`, `focus:`, `disabled:` prefixes
- Spacing scale: N * 4px (p-4 = 16px, gap-2 = 8px)
- Arbitrary values: bracket syntax `w-[200px]`, `text-[#FF0000]`
```

### Path-Specific Rules (Optional)

Define Wind-specific rules scoped to Dart files in `.claude/rules/`:

```bash
mkdir -p .claude/rules
```

`.claude/rules/wind-widgets.md`:

```markdown
---
paths:
  - "lib/**/*.dart"
---

# Wind Widget Rules

- Use WDiv for containers/layout, WText for text, WButton for buttons
- Form elements: WFormInput (with validator), WFormSelect, WFormCheckbox
- Debug WPopover when troubleshooting WSelect dropdowns (WSelect uses WPopover internally)
- Always support the className parameter when creating new widgets
- Last class wins: later classes override earlier ones for the same property
```

## How It Works

Once installed, Claude Code automatically:

1. **Always loads metadata** — The skill's `description` field is included in context every session. Claude recognizes when a request involves Wind widgets or className utilities.

2. **Loads SKILL.md when relevant** — Widget table, state/prefix reference, common patterns, and key rules (~140 lines).

3. **Loads reference files on demand** — `utilities.md` (complete utility class list) and `theme.md` (color, spacing, typography scales) are only pulled into context when a specific class name or theme value is needed.

This **progressive disclosure** approach keeps the context window efficient.

## Usage

### Automatic (Recommended)

Simply ask for anything Wind-related — Claude recognizes the skill and uses it automatically:

```
> Build a responsive card grid with WDiv, with dark mode support
> Rewrite this form using WFormInput and WFormSelect
> Add a hover-effect button to this page
```

### Manual

Invoke directly with the slash command:

```
> /wind-ui create a responsive sidebar layout
```

## Verification

To check that the skill loaded correctly:

```
> What skills are available?
```

`wind-ui` should appear in the output. If it doesn't:

1. Check the file path: does `.claude/skills/wind-ui/SKILL.md` exist?
2. Is the YAML frontmatter valid? (`name` and `description` between `---` markers)
3. Run `/context` to check if the skill character budget has been exceeded

## Directory Structure

```
your-flutter-project/
├── .claude/
│   ├── CLAUDE.md              # (optional) Project instructions
│   ├── rules/
│   │   └── wind-widgets.md    # (optional) Widget rules scoped to lib/**/*.dart
│   └── skills/
│       └── wind-ui/
│           ├── SKILL.md       # Main skill file (~140 lines)
│           └── references/
│               ├── utilities.md   # All utility classes (~200 lines)
│               └── theme.md       # Theme scales (~100 lines)
├── CLAUDE.md                  # (optional) Project root instructions
└── lib/
    └── ...                    # Your Flutter source code
```
