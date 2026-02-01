# Font Size

Utilities for controlling the font size of an element.

<x-preview path="typography/font_size" size="md" source="example/lib/pages/typography/font_size.dart"></x-preview>

## Basic Usage

Control font size using `text-{size}` utilities:

```dart
WText('Extra small text', className: 'text-xs')   // 12px
WText('Small text', className: 'text-sm')          // 14px
WText('Base text', className: 'text-base')         // 16px
WText('Large text', className: 'text-lg')          // 18px
WText('Extra large', className: 'text-xl')         // 20px
WText('2XL text', className: 'text-2xl')           // 24px
WText('3XL text', className: 'text-3xl')           // 30px
```

## All Font Sizes

| Class | Size |
| :--- | :--- |
| `text-xs` | 12px (0.75rem) |
| `text-sm` | 14px (0.875rem) |
| `text-base` | 16px (1rem) |
| `text-lg` | 18px (1.125rem) |
| `text-xl` | 20px (1.25rem) |
| `text-2xl` | 24px (1.5rem) |
| `text-3xl` | 30px (1.875rem) |
| `text-4xl` | 36px (2.25rem) |
| `text-5xl` | 48px (3rem) |
| `text-6xl` | 60px (3.75rem) |
| `text-7xl` | 72px (4.5rem) |
| `text-8xl` | 96px (6rem) |
| `text-9xl` | 128px (8rem) |

## Arbitrary Values

For custom font sizes, use the bracket notation:

```dart
WText('Custom size', className: 'text-[20px]')
WText('Rem size', className: 'text-[1.5rem]')
```

## Combined with Line Height

Set both font size and line height in one class:

```dart
WText('Size with line height', className: 'text-lg/relaxed')
WText('Custom line height', className: 'text-xl/[28px]')
```

## Customizing Theme

Override or extend font sizes in `WindThemeData`:

```dart
WindThemeData(
  fontSizes: {
    'xs': 10.0,       // override
    'mega': 100.0,    // custom
  }
)
```

Usage: `text-mega`

## Related Documentation

- [Font Weight](./font-weight.md) - Font weight utilities
- [Line Height](./line-height.md) - Line height utilities
