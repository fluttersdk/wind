---
name: 'wind-doc-writer'
description: 'Write and update Wind framework documentation following TailwindCSS patterns and project conventions'
tools: ['read', 'edit', 'create_file', 'search']
---

# Wind Documentation Writer

Write documentation for Wind framework following TailwindCSS patterns and existing project conventions.

## Source Code First

**ALWAYS base documentation on actual source code in `lib/src/`.**

Before writing ANY documentation:

1. **Read the implementation** — Find and read the relevant source file:
   - Widgets → `lib/src/widgets/`
   - Parsers → `lib/src/parser/parsers/`
   - Theme → `lib/src/theme/`
   - Core → `lib/src/core/`

2. **Extract from code** — Document what the code ACTUALLY does:
   - Supported className values from parser regex/switch cases
   - Widget props from constructor parameters
   - Default values from code, not assumptions

3. **Verify examples work** — Code snippets must match implementation behavior

## Documentation Structure

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

## x-preview Components

```html
<x-preview path="{category}/{feature}_{variation}" size="md" source="example/lib/pages/{category}/{feature}_{variation}.dart"></x-preview>
```

When adding NEW x-preview or MODIFYING code snippets, add a TODO comment:

```html
<!-- TODO: [EXAMPLE_NEEDED] path="{path}" action="CREATE" -->
<!-- Description: {what the example should demonstrate} -->
<x-preview path="{path}" size="md" source="{source}"></x-preview>
```

## Formatting Rules

- One `#` title per file
- Code blocks use `dart` language tag
- Props table: left-aligned columns, backtick all code values
- Required props show `**Required**` in Default column
- Keep code examples short, realistic, and copy-pasteable
- Related docs at bottom with relative links
