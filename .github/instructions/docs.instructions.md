---
applyTo: doc/**
---
# Documentation conventions (`doc/`)

The `doc/` directory is the user-facing markdown reference, organized by topic (`widgets/`, `layout/`, `styling/`, `getting-started/`, `theming/`, etc.). It is paired with `example/lib/pages/` via `<x-preview>` tags.

## File shape (every doc file)

```markdown
# WFoo

One-line description of what the widget / concept does.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Props](#props)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="widgets/w_foo_basic" size="md" source="example/lib/pages/widgets/w_foo_basic.dart"></x-preview>

```dart
WFoo(
  className: 'p-4 bg-blue-500 dark:bg-blue-700 rounded-lg',
  child: WText('Hello'),
)
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes. |
| `child` | `Widget?` | `null` | Single child. XOR with `children`. |
| `onTap` | `VoidCallback?` | `null` | **Required** for interactive variants. |

<a name="related-documentation"></a>
## Related Documentation

- [WAnchor](../widgets/w-anchor.md) — auto-wraps when className contains state prefixes.
```

## Heading hierarchy

- `#` (single) — page title (widget or concept name). Exactly one per file.
- `##` — main sections (Basic Usage, Props, Styling Examples, Related Documentation, etc.).
- `###` — subsections within a section.
- Never skip levels.

## Section anchors

Place `<a name="section-name"></a>` immediately BEFORE every `##` heading. ToC links use the same slug. Slugs are kebab-case.

## x-preview tags

```html
<x-preview path="category/file_name" size="md" source="example/lib/pages/category/file_name.dart"></x-preview>
```

- `path` matches `example/lib/pages/{path}.dart` WITHOUT the extension. Underscores in the file name carry over.
- `source` is the FULL path from the repo root.
- `size`: `sm` (compact), `md` (standard), `lg` (full-width).
- Every x-preview MUST point to a real `example/lib/pages/` file. If you add an x-preview, add or extend the example page in the same change.

## Props table format

```markdown
| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes. |
| `child` | `Widget?` | `null` | Single child. XOR with `children`. |
| `onTap` | `VoidCallback?` | **Required** | Callback when widget is tapped. |
```

- Left-align columns (`:-----`).
- Backtick every code identifier in `Prop`, `Type`, and `Default`.
- Required props show `**Required**` in the Default column.

## Constructor section

After Props, show the full constructor signature:

```markdown
## Constructor

```dart
WFoo({
  Key? key,
  String? className,
  Widget? child,
  List<Widget>? children,
  VoidCallback? onTap,
})
```
```

## Code examples

- Language: always `dart`.
- Short, realistic, copy-pasteable (no Lorem ipsum).
- Every color token carries `dark:` pair: `bg-white dark:bg-gray-800`.

## Preservation rule

When editing an existing doc file, do NOT restructure sections that haven't changed. Preserve the existing format. New sections match the style of adjacent sections in the same file.

## What never goes in `doc/`

- API reference dumps — that's dartdoc's job.
- CHANGELOG entries — that's `CHANGELOG.md`.
- Marketing copy — that's `README.md`.
- Internal architecture deep-dives — that's `CLAUDE.md` and `.claude/rules/`.
