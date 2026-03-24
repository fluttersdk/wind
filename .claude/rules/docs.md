---
path: "doc/**/*.md"
---

# Documentation Domain

- One `#` title per file — widget name or concept name. One-line description immediately after
- Table of Contents with `[Section Name](#section-name)` links after description
- `<x-preview path="category/file" size="md" source="example/lib/pages/category/file.dart"></x-preview>` for live demos
- Section anchors: `<a name="section-name"></a>` before each `##` heading
- Code blocks always use `dart` language specifier
- Props table format — left-aligned columns, backtick all code:
  ```
  | Prop | Type | Default | Description |
  |:-----|:-----|:--------|:------------|
  | `className` | `String?` | `null` | Wind utility classes. |
  ```
- Required props show `**Required**` in Default column
- Constructor section shows full signature with defaults
- Heading hierarchy: `#` page title → `##` main sections → `###` subsections. Never skip levels
- x-preview `path` matches `example/lib/pages/{path}.dart` without extension
- x-preview `size`: `sm` (compact), `md` (standard), `lg` (full-width)
- Keep code examples short, realistic, and copy-pasteable
- Related docs at bottom: `- [Widget Name](../widgets/widget-name.md)`
- Do NOT restructure sections that haven't changed — preserve existing format exactly
- When adding new sections, match the style of adjacent sections in the same file
