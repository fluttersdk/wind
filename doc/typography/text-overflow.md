# Text Overflow

Utilities for controlling how text overflows its container.

<x-preview path="typography/text_overflow" size="md" source="example/lib/pages/typography/text_overflow.dart"></x-preview>

## Truncate

Truncate text with an ellipsis when it overflows:

```dart
WDiv(
  className: 'w-48 overflow-hidden',
  child: WText(
    'This is a very long text that will be truncated',
    className: 'truncate',
  ),
)
```

## Line Clamp

Clamp text to a specific number of lines:

```dart
WText(
  'This is a long paragraph that will be clamped to 2 lines...',
  className: 'line-clamp-2',
)
```

| Class | Lines |
| :--- | :--- |
| `line-clamp-1` | 1 line |
| `line-clamp-2` | 2 lines |
| `line-clamp-3` | 3 lines |
| `line-clamp-4` | 4 lines |
| `line-clamp-5` | 5 lines |
| `line-clamp-6` | 6 lines |
| `line-clamp-none` | Disable clamp |

## Text Overflow Style

Control how overflowing text is displayed:

```dart
WText('Long text...', className: 'text-ellipsis')
WText('Long text...', className: 'text-clip')
```

| Class | Description |
| :--- | :--- |
| `truncate` | Single line with ellipsis |
| `text-ellipsis` | Ellipsis overflow |
| `text-clip` | Clip overflow |

## Whitespace

Control text wrapping behavior:

```dart
// Prevent text from wrapping
WText('This will not wrap', className: 'whitespace-nowrap')

// Normal wrapping (default)
WText('This will wrap normally', className: 'whitespace-normal')

// Wrap control
WText('Balanced wrapping', className: 'text-balance')
WText('No wrap', className: 'text-nowrap')
WText('Normal wrap', className: 'text-wrap')
```

| Class | Description |
| :--- | :--- |
| `whitespace-normal` | Normal wrapping |
| `whitespace-nowrap` | Prevent wrapping |
| `text-wrap` | Normal wrapping |
| `text-nowrap` | Prevent wrapping |
| `text-balance` | Balanced line breaks |

## Related Documentation

- [Text Align](./text-align.md) - Text alignment utilities
