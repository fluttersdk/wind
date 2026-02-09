# Z-Index

Utilities for controlling the stack order of an element.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="layout/z_index_basic" size="md" source="example/lib/pages/layout/z_index_basic.dart"></x-preview>

```dart
// Standard values
WDiv(className: 'z-0')
WDiv(className: 'z-50')

// Arbitrary values
WDiv(className: 'z-[100]')
WDiv(className: 'z-[-1]')
```

<a name="basic-usage"></a>
## Basic Usage

Use `z-{index}` to set the stack order of an element. This utility is primarily used with `Stack` widgets to determine which element appears on top.

```dart
Stack(
  children: [
    WDiv(className: 'z-0 bg-blue-500 w-20 h-20'),
    WDiv(className: 'z-10 bg-red-500 w-20 h-20 ml-10 mt-10'),
    WDiv(className: 'z-20 bg-green-500 w-20 h-20 ml-20 mt-20'),
  ],
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Value | Description |
|:------|:------|:------------|
| `z-0` | 0 | Stack level 0 |
| `z-10` | 10 | Stack level 10 |
| `z-20` | 20 | Stack level 20 |
| `z-30` | 30 | Stack level 30 |
| `z-40` | 40 | Stack level 40 |
| `z-50` | 50 | Stack level 50 |
| `z-auto` | `null` | Resets stack level (default) |

<a name="variants"></a>
## Variants

### Hover & Focus

Control the stack order on interaction. This is useful for "pop-out" effects where an item should rise above others when hovered.

<x-preview path="layout/z_index_hover" size="md" source="example/lib/pages/layout/z_index_hover.dart"></x-preview>

```dart
WDiv(className: 'z-0 hover:z-50 bg-white shadow-sm hover:shadow-xl')
```

<a name="responsive-design"></a>
## Responsive Design

Apply different z-indices at specific breakpoints using the `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
// z-0 on mobile, z-50 on medium screens and up
WDiv(className: 'z-0 md:z-50')
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply specific z-indices when the application is in dark mode.

```dart
WDiv(className: 'z-10 dark:z-20')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use square brackets `[]` to apply custom z-index values that aren't part of the theme. This supports both positive and negative integers.

```dart
// Custom positive value
WDiv(className: 'z-[100]')

// Custom negative value
WDiv(className: 'z-[-5]')
```

<a name="customizing-theme"></a>
## Customizing Theme

To extend or override the default z-index scale, modify the `zIndices` property in `WindThemeData`.

```dart
WindThemeData(
  zIndices: {
    // Override defaults
    '0': 0,
    '50': 50,
    
    // Add custom values
    '100': 100,
    'modal': 9999,
    'popover': 5000,
  },
)
```

Usage with custom theme:

```dart
WDiv(className: 'z-modal')   // Applies z-index: 9999
WDiv(className: 'z-popover') // Applies z-index: 5000
```

<a name="related-documentation"></a>
## Related Documentation

- [Position](/doc/layout/position.md)
- [Display](/doc/layout/display.md)
- [WindTheme](/doc/core-concepts/theming.md)
