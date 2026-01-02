---
description: Wind UI Framework development workflow - post-code-change updates for tests, documentation, and metadata
---

# Wind UI Framework Development Workflow

You MUST follow this workflow after completing any code changes to the `fluttersdk_wind` framework. This ensures consistency across tests, documentation, and project metadata.

---

## Step 1: Static Analysis & Formatting

After completing your code changes, run static analysis and fix all issues:

// turbo
```bash
cd /Users/anilcan/StudioProjects/fluttersdk_wind_v1 && flutter analyze
```

Fix all errors and warnings before proceeding. Apply automatic fixes if available:

// turbo
```bash
cd /Users/anilcan/StudioProjects/fluttersdk_wind_v1 && dart fix --apply
```

Format all code:

// turbo
```bash
cd /Users/anilcan/StudioProjects/fluttersdk_wind_v1 && dart format .
```

---

## Step 2: Test Updates

### 2.1 Identify Related Test Files

Use this mapping to find the correct test file:

| Change Location | Test File Path |
|-----------------|----------------|
| `lib/src/parser/parsers/{name}.dart` | `test/parser/parsers/{name}_test.dart` |
| `lib/src/widgets/{name}.dart` | `test/widgets/{name}_test.dart` |
| `lib/src/theme/{name}.dart` | `test/theme/{name}_test.dart` |
| `lib/src/state/{name}.dart` | `test/state/{name}_test.dart` |
| `lib/src/parser/wind_style.dart` | `test/parser/wind_style_test.dart` |
| `lib/src/parser/wind_parser.dart` | `test/parser/wind_parser_test.dart` |

### 2.2 Run Related Tests

// turbo
```bash
cd /Users/anilcan/StudioProjects/fluttersdk_wind_v1 && flutter test test/{folder}/{file}_test.dart
```

### 2.3 Write New Tests

If you added a new feature or no tests exist for your changes, create them:

**For new parsers** - Create `test/parser/parsers/{parser_name}_test.dart`:
- Test `canParse()` returns true for valid classes
- Test `canParse()` returns false for invalid classes
- Test `parse()` produces correct WindStyle properties
- Include edge cases and arbitrary value tests

**For new widgets** - Create `test/widgets/{widget_name}_test.dart`:
- Test widget renders correctly
- Test className parsing applies expected styles
- Test state prefixes (hover:, focus:, disabled:) if applicable
- Test props behave as documented

### 2.4 Run All Tests

// turbo
```bash
cd /Users/anilcan/StudioProjects/fluttersdk_wind_v1 && flutter test
```

All tests MUST pass before proceeding.

---

## Step 3: Documentation Updates

### 3.1 Identify Documentation to Update

| Change Type | Documentation File(s) |
|-------------|----------------------|
| New widget | Create `docs/widgets/w-{widget-name}.md` |
| New utility class | Update relevant `docs/{category}/` file |
| Widget prop change | Update `docs/widgets/w-{widget-name}.md` |
| Parser change | Update relevant `docs/{category}/` file |
| Theme change | Update `docs/core-concepts/theming.md` |
| State change | Update `docs/core-concepts/state-management.md` |
| Responsive change | Update `docs/core-concepts/responsive-design.md` |

### 3.2 Documentation Categories

```
docs/
├── getting-started/     # Installation, configuration
├── core-concepts/       # Theming, state, responsive, dark mode
├── widgets/             # All widget documentation
├── layout/              # Flexbox, grid, sizing, spacing
├── typography/          # Text, fonts
├── backgrounds/         # Colors, gradients
├── borders/             # Borders, rounded corners
├── effects/             # Shadows, rings, opacity
└── helpers/             # Programmatic helpers
```

### 3.3 New Widget Documentation Template

When creating documentation for a new widget, use this structure:

```markdown
# W{WidgetName}

Brief description of what the widget does and when to use it.

## Basic Usage

\`\`\`dart
W{WidgetName}(
  className: "example-classes",
  child: ...,
)
\`\`\`

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| className | String? | null | Wind utility classes |
| child | Widget? | null | Child widget |

## Supported Utility Classes

List which utility class categories work with this widget.

## Examples

### Example Title
\`\`\`dart
// Practical example with comments
\`\`\`

## Related
- [RelatedWidget](./w-related.md)
```

---

## Step 4: README.md Update

File: `/Users/anilcan/StudioProjects/fluttersdk_wind_v1/README.md`

Update the README when:

| Change Type | Section to Update |
|-------------|-------------------|
| New widget | Add to "Core Widgets" with brief example |
| New utility class category | Add to "Supported Utilities" |
| New state prefix | Add to "State" section |
| API changes | Update relevant examples |
| Major version | Update "What's New" section |

**Widget entry format:**
```markdown
### W{WidgetName}
Brief description.
\`\`\`dart
W{WidgetName}(className: "example", child: ...)
\`\`\`
```

---

## Step 5: AI System Prompt Updates

You MUST update these files to keep AI agents in sync with the codebase:

### 5.1 instruction.md

File: `/Users/anilcan/StudioProjects/fluttersdk_wind_v1/instruction.md`

Update when you:
- Add/modify a widget → Update **Widget Reference** section with all props
- Add utility classes → Update **Utility Class Reference** tables
- Add state prefixes → Update **State Prefixes** table
- Discover anti-patterns → Add to **Anti-Patterns** section
- Change parser behavior → Update **Parser System** section

### 5.2 fluttersdk-wind-ui.md

File: `/Users/anilcan/StudioProjects/fluttersdk_wind_v1/fluttersdk-wind-ui.md`

This is the external AI system prompt for projects using Wind. Keep it synchronized with `instruction.md`. It should contain the same Widget Reference and Utility Class Reference content.

---

## Step 6: CHANGELOG.md Update

File: `/Users/anilcan/StudioProjects/fluttersdk_wind_v1/CHANGELOG.md`

Add an entry for your changes using this format:

```markdown
## [x.y.z] - YYYY-MM-DD

### Added
- New feature description

### Changed
- Modification description

### Fixed
- Bug fix description

### Deprecated
- Deprecated feature description

### Removed
- Removed feature description
```

**Versioning rules:**
- **MAJOR (x.0.0)**: Breaking changes that require code updates
- **MINOR (0.x.0)**: New features, backward compatible
- **PATCH (0.0.x)**: Bug fixes, backward compatible

---

## Step 7: pubspec.yaml Update

File: `/Users/anilcan/StudioProjects/fluttersdk_wind_v1/pubspec.yaml`

Update if needed:
- Increment `version` according to semantic versioning
- Add new dependencies if introduced
- Update `description` if scope changed

---

## Step 8: Final Verification

### 8.1 Run Complete Test Suite

// turbo
```bash
cd /Users/anilcan/StudioProjects/fluttersdk_wind_v1 && flutter test && flutter analyze
```

### 8.2 Test in Example App

// turbo
```bash
cd /Users/anilcan/StudioProjects/fluttersdk_wind_v1/example && flutter run -d chrome
```

Verify your changes work correctly in the example app.

### 8.3 Completion Checklist

Before marking your task complete, verify ALL of these:

- [ ] Code changes complete and working
- [ ] `flutter analyze` passes with no errors
- [ ] `dart format .` applied
- [ ] Related tests written/updated
- [ ] `flutter test` all tests pass
- [ ] Documentation updated in `docs/`
- [ ] README.md updated (if applicable)
- [ ] instruction.md updated (for widget/utility/prefix changes)
- [ ] fluttersdk-wind-ui.md synced with instruction.md
- [ ] CHANGELOG.md updated
- [ ] pubspec.yaml version updated (if needed)
- [ ] Example app tested

---

## Quick Reference: Project Structure

```
fluttersdk_wind_v1/
├── lib/src/
│   ├── parser/
│   │   ├── parsers/        # Individual utility parsers
│   │   ├── wind_parser.dart
│   │   └── wind_style.dart
│   ├── widgets/            # WDiv, WText, WButton, etc.
│   ├── theme/              # WindTheme, WindThemeData
│   └── state/              # WAnchor, state management
├── test/                   # Mirror of lib/src structure
├── docs/                   # Documentation (41 files, 9 categories)
├── example/                # Example Flutter app
├── README.md               # Main README
├── CHANGELOG.md            # Version history
├── instruction.md          # AI system prompt (internal)
├── fluttersdk-wind-ui.md   # AI system prompt (external)
└── pubspec.yaml            # Package configuration
```

---

## Important Rules

1. **NEVER skip tests** - All changes must have corresponding tests
2. **NEVER skip documentation** - Undocumented features don't exist
3. **ALWAYS update AI prompts** - Keep instruction.md and fluttersdk-wind-ui.md in sync
4. **ALWAYS run full test suite** - Before marking any task complete
5. **USE className** - Never apply manual Flutter styling, always use utility classes
