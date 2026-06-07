# Border Width, Color, & Radius

Utilities for controlling border width, color, style, and border radius.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="borders/borders_preview" size="md" source="example/lib/pages/borders/borders_preview.dart"></x-preview>

```dart
// Basic border (1px solid gray-200 by default)
WDiv(className: 'border')

// Thicker border with color
WDiv(className: 'border-2 border-blue-500')

// Rounded corners
WDiv(className: 'border rounded-lg p-4')

// Specific side border
WDiv(className: 'border-b-2 border-red-500')
```

<a name="quick-reference"></a>
## Quick Reference

### Border Width

| Class | CSS Equivalent | Description |
|:--- |:--- |:--- |
| `border-0` | `border-width: 0px` | No border |
| `border` | `border-width: 1px` | 1px border |
| `border-2` | `border-width: 2px` | 2px border |
| `border-4` | `border-width: 4px` | 4px border |
| `border-8` | `border-width: 8px` | 8px border |

### Border Style

| Class | CSS Equivalent | Description |
|:--- |:--- |:--- |
| `border-solid` | `border-style: solid` | Solid border (default) |
| `border-none` | `border-style: none` | No border |

### Border Radius

| Class | Value | Description |
|:--- |:--- |:--- |
| `rounded-none` | `0px` | No rounding |
| `rounded-sm` | `2px` | Small radius |
| `rounded` | `4px` | Default radius |
| `rounded-md` | `6px` | Medium radius |
| `rounded-lg` | `8px` | Large radius |
| `rounded-xl` | `12px` | Extra large radius |
| `rounded-2xl` | `16px` | 2x Extra large |
| `rounded-3xl` | `24px` | 3x Extra large |
| `rounded-full` | `9999px` | Fully rounded (pill/circle) |

<a name="variants"></a>
## Variants

### Individual Sides

Control border width for specific sides using `-t`, `-r`, `-b`, and `-l` suffixes.

```dart
// Top border only
WDiv(className: 'border-t-4 border-indigo-500')

// Right and Left borders
WDiv(className: 'border-r border-l border-gray-300')
```

### Corner Radius

Control radius for specific corners or sides.

```dart
// Top corners only
WDiv(className: 'rounded-t-lg bg-white')

// Top-left corner only
WDiv(className: 'rounded-tl-md bg-blue-100')
```

| Class | Sides/Corner |
|:--- |:--- |
| `rounded-t-*` | Top-left & Top-right |
| `rounded-r-*` | Top-right & Bottom-right |
| `rounded-b-*` | Bottom-left & Bottom-right |
| `rounded-l-*` | Top-left & Bottom-left |
| `rounded-tl-*` | Top-left only |
| `rounded-tr-*` | Top-right only |
| `rounded-br-*` | Bottom-right only |
| `rounded-bl-*` | Bottom-left only |

### Color Opacity

You can control the opacity of border colors using the color opacity modifier.

```dart
// 50% opacity red border
WDiv(className: 'border-2 border-red-500/50')
```

<a name="responsive-design"></a>
## Responsive Design

Prefix any border utility with a breakpoint variant to apply it at specific screen sizes.

```dart
// No border on mobile, 2px border on tablet+
WDiv(className: 'border-0 md:border-2')

// Square on mobile, rounded on desktop
WDiv(className: 'rounded-none lg:rounded-xl')
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to style borders differently in dark mode.

```dart
WDiv(
  className: 'border border-gray-200 dark:border-gray-700'
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If you need a value that doesn't fit the theme, use square bracket notation.

```dart
// Specific pixel width
WDiv(className: 'border-[3px]')

// Specific hex color
WDiv(className: 'border-[#1da1f2]')

// Specific radius
WDiv(className: 'rounded-[10px]')
```

<a name="customizing-theme"></a>
## Customizing Theme

Customize standard values in `WindThemeData`.

```dart
WindThemeData(
  // Custom border widths
  borderWidths: {
    'DEFAULT': 1.0,
    '3': 3.0, // adds border-3
    'thin': 0.5, // adds border-thin
  },
  
  // Custom border radius
  borderRadius: {
    'DEFAULT': 4.0,
    'xl': 12.0,
    'mega': 32.0, // adds rounded-mega
  },
  
  // Custom colors
  colors: {
    'brand': Colors.indigo, // adds border-brand
  },
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Ring Utilities](ring.md) - Focus rings and outlines
