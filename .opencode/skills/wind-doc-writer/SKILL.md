---
name: wind-doc-writer
description: Write and update documentation for the Wind Flutter framework. Use when creating new documentation files, updating existing docs, adding utility/widget documentation, or modifying code examples in doc/ folder. Triggers on "document this utility", "write docs for", "add documentation", "update the docs", or any Wind framework documentation task. REQUIRES loading anilcan-doc-writer skill for writing style.
---

# Wind Documentation Writer

Write documentation for Wind framework following TailwindCSS patterns and existing project conventions.

## Prerequisites

**MANDATORY**: Load `anilcan-doc-writer` skill for writing style and voice. This skill handles structure and Wind-specific patterns; `anilcan-doc-writer` handles tone and language.

## Source Code First (CRITICAL)

**ALWAYS base documentation on actual source code in `lib/src/`.**

Before writing ANY documentation:

1. **Read the implementation** - Find and read the relevant source file:
   - Widgets → `lib/src/widgets/`
   - Parsers → `lib/src/parser/parsers/`
   - Theme → `lib/src/theme/`
   - Core → `lib/src/core/`

2. **Extract from code** - Document what the code ACTUALLY does:
   - Supported className values from parser regex/switch cases
   - Widget props from constructor parameters
   - Default values from code, not assumptions
   - Edge cases from conditional logic

3. **Verify examples work** - Code snippets must match implementation behavior

| Task | Source Location |
|:-----|:----------------|
| Utility classes (padding, colors, ring) | `lib/src/parser/parsers/{feature}_parser.dart` |
| Widget documentation | `lib/src/widgets/w_{name}.dart` |
| Theme defaults | `lib/src/theme/defaults/` |
| State prefixes | `lib/src/parser/wind_parser.dart` |

**NEVER assume or guess utility values. READ THE SOURCE.**

## Quick Decision Tree

```
What are you documenting?
│
├─► Utility class (padding, colors, ring, etc.)
│   └─► Use references/utility-template.md
│
├─► Widget (WDiv, WText, WButton, etc.)
│   └─► Use references/widget-template.md
│
├─► New category or structural change
│   └─► Consult references/doc-structure.md
│
└─► Adding/modifying code examples
    └─► MUST follow references/x-preview-guide.md TODO rules
```

## Workflow

### Step 1: Determine Documentation Type

| Type | File Location | Template |
|:-----|:--------------|:---------|
| Utility | `doc/{category}/{feature}.md` | `references/utility-template.md` |
| Widget | `doc/widgets/w-{name}.md` | `references/widget-template.md` |
| Concept | `doc/core-concepts/{concept}.md` | No template (follow existing) |

### Step 2: Check Existing Documentation

Before writing, verify:
1. Does the file already exist? → Update, don't recreate
2. Are there similar docs in the category? → Match their structure
3. What example pages exist? → Check `example/lib/pages/{category}/`

### Step 3: Write Documentation

Follow the appropriate template. Key rules:

**Section Order (Utilities):**
1. H1 Title + Description
2. Table of Contents (MANDATORY)
3. x-preview + code block
4. Basic Usage
5. Quick Reference table
6. Variants
7. Responsive Design
8. Dark Mode
9. Arbitrary Values
10. Customizing Theme
11. Related Documentation

**Section Order (Widgets):**
1. H1 Title + Description
2. Table of Contents (MANDATORY)
3. x-preview + code block
4. Basic Usage
5. Constructor
6. Props table
7. Layout Modes
8. Event Handling
9. State Variants
10. Styling Examples
11. All Supported Classes
12. Customizing Theme
13. Related Documentation

### Step 4: Handle x-preview Components

**CRITICAL**: Read `references/x-preview-guide.md` for complete rules.

**x-preview Syntax:**
```html
<x-preview path="{category}/{feature}_{variation}" size="md" source="example/lib/pages/{category}/{feature}_{variation}.dart"></x-preview>
```

**MANDATORY TODO Pattern:**

When adding NEW x-preview or MODIFYING code snippets:

```markdown
<!-- TODO: [EXAMPLE_NEEDED] path="{path}" action="{action}" -->
<!-- Description: {what the example should demonstrate} -->
<x-preview path="{path}" size="md" source="{source}"></x-preview>

```dart
{code snippets showing className usage}
```
```

| Action | When |
|:-------|:-----|
| `CREATE` | New example page needed |
| `UPDATE` | Existing example needs changes |
| `VERIFY` | Uncertain if example matches |

**DO NOT add TODO when:**
- x-preview exists AND code snippets match exactly
- Only changing text, not code

## Reference Files

| File | Purpose | When to Read |
|:-----|:--------|:-------------|
| `references/doc-structure.md` | File organization, categories, naming | New docs, structural questions |
| `references/utility-template.md` | Template for utility classes | Documenting any CSS utility |
| `references/widget-template.md` | Template for W-prefixed widgets | Documenting any widget |
| `references/x-preview-guide.md` | Preview syntax, TODO rules | ANY doc with code examples |

## Code Block Rules

- Always use ```dart language tag
- Show realistic className usage
- Include child widgets when relevant
- Add inline comments for complex examples

```dart
// Good: Clear, realistic example
WDiv(
  className: 'flex gap-4 p-6 bg-white rounded-lg shadow-md',
  children: [
    WText('Title', className: 'text-xl font-bold'),
    WText('Description', className: 'text-gray-600'),
  ],
)
```

## Table Formats

**Quick Reference (Utilities):**
```markdown
| Class | Value | Description |
|:------|:------|:------------|
| `p-0` | 0px | No padding |
| `p-1` | 4px | Extra small padding |
```

**Props (Widgets):**
```markdown
| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes |
| `child` | `Widget?` | `null` | Child widget |
```

## Quality Checklist

Before completing documentation:

- [ ] Follows correct template structure
- [ ] All x-preview components have matching code blocks
- [ ] TODO comments added for new/modified examples
- [ ] Tables are properly formatted with `:---` alignment
- [ ] Code blocks specify `dart` language
- [ ] Related Documentation links are valid
- [ ] Customizing Theme section shows correct WindThemeData property
