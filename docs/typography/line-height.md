# Line Height

Utilities for controlling the leading (line height) of an element.

<x-preview path="typography/line_height" size="md" source="example/lib/pages/typography/line_height.dart"></x-preview>

## Basic Usage

Control line height using `leading-{value}` utilities:

```dart
WText('Tight leading', className: 'leading-tight')
WText('Normal leading', className: 'leading-normal')
WText('Relaxed leading', className: 'leading-relaxed')
WText('Loose leading', className: 'leading-loose')
```

## All Line Height Values

| Class | Line Height |
| :--- | :--- |
| `leading-none` | 1 |
| `leading-tight` | 1.25 |
| `leading-snug` | 1.375 |
| `leading-normal` | 1.5 |
| `leading-relaxed` | 1.625 |
| `leading-loose` | 2 |
| `leading-3` | 0.75rem |
| `leading-4` | 1rem |
| `leading-5` | 1.25rem |
| `leading-6` | 1.5rem |
| `leading-7` | 1.75rem |
| `leading-8` | 2rem |
| `leading-9` | 2.25rem |
| `leading-10` | 2.5rem |

## Arbitrary Values

For custom line height, use the bracket notation:

```dart
WText('Custom', className: 'leading-[24px]')
WText('Multiplier', className: 'leading-[1.8]')
```

## Combined with Font Size

Set both font size and line height together:

```dart
WText('Combined', className: 'text-lg/relaxed')
WText('Custom height', className: 'text-xl/[28px]')
```

## Customizing Theme

Override or extend leading values in `WindThemeData`:

```dart
WindThemeData(
  leading: {
    'none': 1.0,
    'tight': 1.25,
    'relaxed': 1.625,
    'double': 2.0,
    'triple': 3.0,  // custom
  }
)
```

Usage: `leading-triple`

## Related Documentation

- [Letter Spacing](./letter-spacing.md) - Letter spacing utilities
- [Font Size](./font-size.md) - Font size utilities
