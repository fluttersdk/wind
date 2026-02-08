# Wind Documentation Structure

This document outlines the organization, naming conventions, and category hierarchy for the Wind framework documentation.

- [Directory Structure](#directory-structure)
- [File Naming Conventions](#file-naming-conventions)
- [Category Descriptions](#category-descriptions)
- [General Markdown Patterns](#general-markdown-patterns)

<a name="directory-structure"></a>
## Directory Structure

Documentation files are organized into categories within the `doc/` directory:

```
doc/
├── getting-started/     # Installation, quick start
├── core-concepts/       # WindContext, WindParser, theming
├── layout/              # Flexbox, grid, spacing, sizing
├── typography/          # Font size, weight, colors, alignment
├── styling/             # Backgrounds, gradients, shadows
├── borders/             # Border width, radius, ring
├── interactivity/       # Cursor, pointer events
├── widgets/             # W-prefixed widgets (w-div.md, w-text.md)
├── utilities/           # Opacity, visibility, overflow
└── mcp/                 # MCP integration
```

<a name="file-naming-conventions"></a>
## File Naming Conventions

To maintain consistency, follow these naming patterns:

| Type | Pattern | Examples |
|------|---------|----------|
| **Utility** | `{feature}.md` (kebab-case) | `font-size.md`, `ring.md` |
| **Widget** | `w-{name}.md` (kebab-case) | `w-div.md`, `w-text.md`, `w-button.md` |
| **Concept** | `{concept}.md` (kebab-case) | `wind-context.md`, `theming.md` |

<a name="category-descriptions"></a>
## Category Descriptions

| Category | Purpose | Examples |
|----------|---------|----------|
| `getting-started` | Installation and first steps | `quick-start.md` |
| `core-concepts` | Framework internals and architecture | `wind-parser.md`, `wind-context.md` |
| `layout` | Positioning, sizing, and spacing | `flexbox.md`, `grid.md`, `padding.md` |
| `typography` | Text styling and formatting | `font-size.md`, `font-weight.md` |
| `styling` | Visual effects and decorations | `backgrounds.md`, `shadows.md` |
| `borders` | Edge styling and rings | `borders.md`, `ring.md` |
| `interactivity` | User interaction and events | `cursor.md`, `pointer-events.md` |
| `widgets` | W-prefixed core components | `w-div.md`, `w-text.md` |
| `utilities` | Miscellaneous utility classes | `opacity.md`, `overflow.md` |
| `mcp` | MCP server integration and usage | `mcp-server.md` |

<a name="general-markdown-patterns"></a>
## General Markdown Patterns

Follow these formatting rules for all documentation files:

- **H1 Title:** Use an H1 for the main title, matching the filename in Title Case.
- **Description:** Include a 1-2 sentence description immediately after the H1.
- **Headers:** Use H2 for major sections and H3 for subsections.
- **Reference Data:** Use tables to display utility classes and their Flutter equivalents.
- **Callouts:**
    - Use `> **Note:**` for helpful tips.
    - Use `> **Warning:**` for critical pitfalls.
- **Code Blocks:** Always specify the language (e.g., ` ```dart `).

This structure ensures that both users and automated tools can easily navigate and understand the Wind framework documentation.
