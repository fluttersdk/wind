# Letter Spacing

Utilities for controlling the tracking (letter spacing) of an element.

<x-preview path="typography/letter_spacing" size="md" source="example/lib/pages/typography/letter_spacing.dart"></x-preview>

## Basic Usage

Control letter spacing using `tracking-{value}` utilities:

```dart
WText('Tighter', className: 'tracking-tighter')
WText('Tight', className: 'tracking-tight')
WText('Normal', className: 'tracking-normal')
WText('Wide', className: 'tracking-wide')
WText('Wider', className: 'tracking-wider')
WText('Widest', className: 'tracking-widest')
```

## All Letter Spacing Values

| Class | Letter Spacing |
| :--- | :--- |
| `tracking-tighter` | -0.05em |
| `tracking-tight` | -0.025em |
| `tracking-normal` | 0em |
| `tracking-wide` | 0.025em |
| `tracking-wider` | 0.05em |
| `tracking-widest` | 0.1em |

## Arbitrary Values

For custom letter spacing, use the bracket notation:

```dart
WText('Custom', className: 'tracking-[0.15em]')
WText('Pixels', className: 'tracking-[2px]')
```

## Customizing Theme

Override or extend tracking values in `WindThemeData`:

```dart
WindThemeData(
  tracking: {
    'tighter': -0.8,
    'tight': -0.4,
    'wide': 0.4,
    'widest': 0.8,
    'super-wide': 1.5,  // custom
  }
)
```

Usage: `tracking-super-wide`

## Related Documentation

- [Line Height](./line-height.md) - Line height utilities
- [Font Size](./font-size.md) - Font size utilities
