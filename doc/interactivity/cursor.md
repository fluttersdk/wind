# Cursor

Utilities for controlling the mouse cursor shown when the pointer is over an element on web and desktop targets.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How It Works](#how-it-works)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

`cursor-*` maps a Tailwind cursor name to the matching native cursor and applies it through a `MouseRegion`. A plain `WDiv` can show a pointer cursor without being wrapped in `WAnchor` or a manual `MouseRegion`.

<x-preview path="interactivity/cursor_basic" size="md" source="example/lib/pages/interactivity/cursor_basic.dart"></x-preview>

```dart
// A clickable-feeling row without WAnchor
WDiv(
  className: 'cursor-pointer px-4 py-3 rounded-lg bg-blue-500 dark:bg-blue-600',
  child: WText('Click me', className: 'text-white'),
)
```

The cursor is a hover affordance only; it changes how the pointer looks, not how taps are handled. Wire taps through `WAnchor` / `WButton` as usual.

<a name="quick-reference"></a>
## Quick Reference

| Class | Flutter cursor |
|:------|:---------------|
| `cursor-auto` / `cursor-default` | `SystemMouseCursors.basic` |
| `cursor-pointer` | `SystemMouseCursors.click` |
| `cursor-wait` | `SystemMouseCursors.wait` |
| `cursor-progress` | `SystemMouseCursors.progress` |
| `cursor-text` | `SystemMouseCursors.text` |
| `cursor-vertical-text` | `SystemMouseCursors.verticalText` |
| `cursor-move` | `SystemMouseCursors.move` |
| `cursor-help` | `SystemMouseCursors.help` |
| `cursor-not-allowed` | `SystemMouseCursors.forbidden` |
| `cursor-none` | `SystemMouseCursors.none` |
| `cursor-context-menu` | `SystemMouseCursors.contextMenu` |
| `cursor-cell` | `SystemMouseCursors.cell` |
| `cursor-crosshair` | `SystemMouseCursors.precise` |
| `cursor-alias` | `SystemMouseCursors.alias` |
| `cursor-copy` | `SystemMouseCursors.copy` |
| `cursor-no-drop` | `SystemMouseCursors.noDrop` |
| `cursor-grab` | `SystemMouseCursors.grab` |
| `cursor-grabbing` | `SystemMouseCursors.grabbing` |
| `cursor-all-scroll` | `SystemMouseCursors.allScroll` |
| `cursor-col-resize` | `SystemMouseCursors.resizeColumn` |
| `cursor-row-resize` | `SystemMouseCursors.resizeRow` |
| `cursor-n-resize` / `cursor-e-resize` / `cursor-s-resize` / `cursor-w-resize` | `resizeUp` / `resizeRight` / `resizeDown` / `resizeLeft` |
| `cursor-ne-resize` / `cursor-nw-resize` / `cursor-se-resize` / `cursor-sw-resize` | `resizeUpRight` / `resizeUpLeft` / `resizeDownRight` / `resizeDownLeft` |
| `cursor-ew-resize` / `cursor-ns-resize` | `resizeLeftRight` / `resizeUpDown` |
| `cursor-nesw-resize` / `cursor-nwse-resize` | `resizeUpRightDownLeft` / `resizeUpLeftDownRight` |
| `cursor-zoom-in` / `cursor-zoom-out` | `zoomIn` / `zoomOut` |

Flutter has no "auto" cursor, so `cursor-auto` resolves to the same basic arrow as `cursor-default`.

<a name="how-it-works"></a>
## How It Works

`WDiv` wraps its content in a `MouseRegion` when a `cursor-*` token is present. When the `WDiv` also carries `hover:` / `focus:` / `active:` classes it is already wrapped in `WAnchor` (whose `MouseRegion` uses `click` only when the anchor has gesture callbacks, otherwise `basic`); the `cursor-*` `MouseRegion` sits deeper in the tree, so its cursor wins for the area it covers regardless of the anchor's default. Last token wins: `cursor-pointer cursor-text` resolves to text.

Cursors are a no-op on touch platforms (there is no pointer to style); the token is simply inert there.

<a name="responsive-design"></a>
## Responsive Design

Combine `cursor-*` with breakpoint prefixes to change the affordance per viewport.

```dart
WDiv(className: 'cursor-default md:cursor-pointer')
```

<a name="dark-mode"></a>
## Dark Mode

The cursor itself is theme-independent, but pair the surrounding color tokens with their `dark:` peers as usual.

```dart
WDiv(className: 'cursor-pointer bg-white dark:bg-gray-800')
```

<a name="related-documentation"></a>
## Related Documentation

- [WAnchor](../widgets/w-anchor.md) — exposes a `mouseCursor` constructor prop for fully imperative control.
- [Transitions](./transition.md) — smooth state changes on hover.
