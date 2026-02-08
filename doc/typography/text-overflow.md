# Text Overflow

Utilities for controlling how text behaves when it overflows its container.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Truncate](#truncate)
- [Ellipsis & Clip](#ellipsis--clip)
- [Line Clamp](#line-clamp)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_overflow_basic" size="md" source="example/lib/pages/typography/text_overflow_basic.dart"></x-preview>

```dart
// Basic truncation
WText(
  'Long text that should be truncated...',
  className: 'truncate',
)

// Limit to specific lines
WText(
  'Multi-line text block...',
  className: 'line-clamp-3',
)
```

<a name="basic-usage"></a>
## Basic Usage

Use `truncate` to prevent text from wrapping and truncate overflowing text with an ellipsis (...) if needed. This is the most common way to handle overflow for single-line text.

```dart
WDiv(
  className: 'w-64',
  child: WText(
    'The quick brown fox jumps over the lazy dog.',
    className: 'truncate',
  ),
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Properties | Description |
|:------|:-----------|:------------|
| `truncate` | `maxLines: 1`, `softWrap: false`, `overflow: ellipsis` | Truncate text with an ellipsis on a single line. |
| `text-ellipsis` | `overflow: ellipsis` | Use an ellipsis for overflow. |
| `text-clip` | `overflow: clip` | Clip overflowing text (no ellipsis). |
| `line-clamp-{n}` | `maxLines: n`, `overflow: ellipsis` | Limit text to n lines. |
| `line-clamp-none` | `maxLines: null` | Remove line limits. |

<a name="truncate"></a>
## Truncate

The `truncate` utility is a shorthand that sets three properties at once:
1. Sets `maxLines` to 1
2. Disables `softWrap`
3. Sets `overflow` to `TextOverflow.ellipsis`

<!-- TODO: [EXAMPLE_NEEDED] path="typography/text_overflow_truncate" action="CREATE" -->
<!-- Description: Show a long text string in a constrained container with truncate applied -->
<x-preview path="typography/text_overflow_truncate" size="md" source="example/lib/pages/typography/text_overflow_truncate.dart"></x-preview>

```dart
WText(
  'Long text that will be cut off with an ellipsis if it gets too long',
  className: 'truncate',
)
```

<a name="ellipsis--clip"></a>
## Ellipsis & Clip

Use `text-ellipsis` or `text-clip` to control the visual overflow behavior specifically.

- **text-ellipsis**: Renders an ellipsis (...) when text overflows.
- **text-clip**: Simply cuts off the text at the boundary.

<!-- TODO: [EXAMPLE_NEEDED] path="typography/text_overflow_clip" action="CREATE" -->
<!-- Description: Compare text-ellipsis vs text-clip side by side -->
<x-preview path="typography/text_overflow_clip" size="md" source="example/lib/pages/typography/text_overflow_clip.dart"></x-preview>

```dart
// Ellipsis (default for truncate/line-clamp)
WText('...', className: 'text-ellipsis')

// Clip (hard cut)
WText('...', className: 'text-clip')
```

<a name="line-clamp"></a>
## Line Clamp

Use `line-clamp-{n}` to limit text to a specific number of lines. This automatically sets the overflow style to ellipsis.

Supported values are any integer number (e.g., `line-clamp-2`, `line-clamp-5`) and `line-clamp-none`.

<!-- TODO: [EXAMPLE_NEEDED] path="typography/text_overflow_line_clamp" action="CREATE" -->
<!-- Description: Show multi-line text clamped to 3 lines -->
<x-preview path="typography/text_overflow_line_clamp" size="md" source="example/lib/pages/typography/text_overflow_line_clamp.dart"></x-preview>

```dart
WText(
  'This is a long paragraph that needs to be clamped to a specific number of lines...',
  className: 'line-clamp-3',
)

// Resetting line clamp
WText(
  '...',
  className: 'line-clamp-3 lg:line-clamp-none',
)
```

<a name="responsive-design"></a>
## Responsive Design

Apply different overflow utilities at different breakpoints using standard responsive prefixes.

```dart
// Truncate on mobile, allow wrapping on desktop
WText(
  'Responsive text behavior...',
  className: 'truncate md:whitespace-normal',
)

// 2 lines on mobile, 4 lines on tablet, unlimited on desktop
WText(
  'Responsive line clamping...',
  className: 'line-clamp-2 md:line-clamp-4 lg:line-clamp-none',
)
```

<a name="dark-mode"></a>
## Dark Mode

While overflow utilities don't visually change in dark mode, you can still apply them conditionally using the `dark:` prefix if your design requires different text handling in dark mode.

```dart
WText(
  '...',
  className: 'truncate dark:line-clamp-2',
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

> [!NOTE]
> Arbitrary values (bracket syntax) are not currently supported for `text-` overflow or `line-clamp-` utilities.
>
> `line-clamp-{n}` supports any integer number directly (e.g., `line-clamp-7`), so bracket syntax is generally not needed.

<a name="customizing-theme"></a>
## Customizing Theme

These utilities do not use theme variables. `line-clamp` accepts numeric values directly, and overflow types are static.

<a name="related-documentation"></a>
## Related Documentation

- [Word Break & Whitespace](./whitespace.md)
- [Font Size](./font-size.md)
