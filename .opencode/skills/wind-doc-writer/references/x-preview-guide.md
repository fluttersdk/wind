# X-Preview Guide

- [Introduction](#introduction)
- [Component Syntax](#component-syntax)
- [Path Naming Convention](#path-naming-convention)
- [Source File Path Convention](#source-file-path-convention)
- [The Preview + Code Block Pattern](#preview-code-block-pattern)
- [TODO Comment System](#todo-comment-system)
- [Size Guidelines](#size-guidelines)
- [Decision Rules](#decision-rules)

<a name="introduction"></a>
## Introduction

Today, I'll show you how to use the `x-preview` component and the associated TODO system. This is crucial for keeping our documentation and example app in perfect sync. If you're adding a new utility or changing how an existing one looks, this guide is for you.

<a name="component-syntax"></a>
## Component Syntax

The `x-preview` component is a custom HTML tag we use in our markdown files to render live Flutter examples.

Let's look at the syntax:

```html
<x-preview path="{route_path}" size="{size}" source="{file_path}"></x-preview>
```

| Attribute | Required | Description | Example |
|:----------|:---------|:------------|:--------|
| `path` | Yes | Route identifier (no extension) | `effects/ring_basic` |
| `size` | Yes | Preview size: `sm`, `md`, `lg`, `xl` | `md` |
| `source` | Yes | Relative path from project root | `example/lib/pages/effects/ring_basic.dart` |

<a name="path-naming-convention"></a>
## Path Naming Convention

Consistency is key here. We use a structured format for the `path` attribute.

```
path = "{category}/{feature}_{variation}"
```

- **category**: Matches the doc folder (effects, layout, typography, widgets, etc.)
- **feature**: The utility or widget name in snake_case
- **variation**: Optional descriptor (basic, colors, sizes, states)

| Path | Description |
|:-----|:------------|
| `effects/ring_basic` | Basic ring examples |
| `effects/ring_colors` | Ring color variations |
| `layout/flex_basic` | Basic flexbox |
| `layout/flex_justify` | Justify content examples |
| `typography/font_size` | Font size scale |
| `widgets/w_div` | WDiv widget showcase |

<a name="source-file-path-convention"></a>
## Source File Path Convention

The `source` attribute must point to the actual Dart file in the example app.

```
source = "example/lib/pages/{category}/{feature}_{variation}.dart"
```

- Always starts with `example/lib/pages/`
- Uses snake_case for filenames
- Matches the `path` attribute with a `.dart` extension

<a name="preview-code-block-pattern"></a>
## The Preview + Code Block Pattern

> [!IMPORTANT]
> Every `x-preview` MUST be immediately followed by a ```dart code block showing the `className` usage.

This ensures users can see the code and the result side-by-side.

```markdown
<x-preview path="effects/ring_basic" size="md" source="example/lib/pages/effects/ring_basic.dart"></x-preview>

```dart
WDiv(className: "ring ring-blue-500 p-4")
WDiv(className: "ring-2 ring-blue-500 p-4")
WDiv(className: "ring-4 ring-blue-500 p-4")
```
```

<a name="todo-comment-system"></a>
## TODO Comment System

This is the most critical part. When you add a NEW preview or modify existing code snippets, you MUST add a specialized TODO comment. This triggers the automation that generates or updates the example pages.

**Format:**
```markdown
<!-- TODO: [EXAMPLE_NEEDED] path="{path}" action="{action}" -->
<x-preview path="{path}" size="md" source="{source}"></x-preview>

```dart
{code snippets}
```
```

### Action Types

| Action | When to Use |
|:-------|:------------|
| `CREATE` | New example page needed (doesn't exist) |
| `UPDATE` | Existing example needs modification |
| `VERIFY` | Uncertain if example matches snippet |

### Examples

**New Example:**
```markdown
<!-- TODO: [EXAMPLE_NEEDED] path="effects/shadow_colored" action="CREATE" -->
<!-- Description: Show colored shadow examples with shadow-red-500, shadow-blue-500 variants -->
<x-preview path="effects/shadow_colored" size="md" source="example/lib/pages/effects/shadow_colored.dart"></x-preview>

```dart
WDiv(className: "shadow-lg shadow-red-500/50 p-4")
WDiv(className: "shadow-lg shadow-blue-500/50 p-4")
```
```

**Updated Example:**
```markdown
<!-- TODO: [EXAMPLE_NEEDED] path="layout/flex_basic" action="UPDATE" -->
<!-- Description: Add flex-wrap examples to existing page -->
<x-preview path="layout/flex_basic" size="md" source="example/lib/pages/layout/flex_basic.dart"></x-preview>

```dart
WDiv(className: "flex flex-wrap gap-4")
```
```

<a name="size-guidelines"></a>
## Size Guidelines

Choose the right size to make the documentation look clean.

| Size | Use Case | Dimensions |
|:-----|:---------|:-----------|
| `sm` | Simple, single element demos | Small preview |
| `md` | Standard examples (most common) | Medium preview |
| `lg` | Complex layouts, multiple elements | Large preview |
| `xl` | Full page demos, grids | Extra large preview |

<a name="decision-rules"></a>
## Decision Rules

### When to add TODO:
- ✅ Creating new `x-preview` that doesn't exist in example app.
- ✅ Changing code snippets under an existing `x-preview`.
- ✅ Adding a new variation to an existing feature.

### When NOT to add TODO:
- ❌ `x-preview` already exists AND snippets match exactly.
- ❌ Only changing documentation text (not the code snippets).
