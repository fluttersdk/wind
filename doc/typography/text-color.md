# Text Color

Utilities for controlling the text color of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Opacity Modifier](#opacity-modifier)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<!-- TODO: [EXAMPLE_NEEDED] path="typography/text_color_basic" action="CREATE" -->
<!-- Description: Show various text colors like error (red), success (green), and info (blue) -->
<x-preview path="typography/text_color_basic" size="md" source="example/lib/pages/typography/text_color_basic.dart"></x-preview>

```dart
// Basic text colors
WText('Error', className: 'text-red-500')
WText('Success', className: 'text-green-600')
WText('Info', className: 'text-blue-500')
```

## Basic Usage

Control the text color of an element using the `text-{color}-{shade}` utilities.

```dart
WDiv(
  className: 'p-4 bg-white rounded-lg shadow-sm',
  children: [
    WText('The quick brown fox', className: 'text-slate-900 font-bold text-xl'),
    WText('Jumps over the lazy dog', className: 'text-slate-500'),
  ],
)
```

## Quick Reference

Wind includes the standard Tailwind color palette. Here are some examples:

| Class | Value | Description |
|:------|:------|:------------|
| `text-slate-500` | #64748b | Slate text color |
| `text-gray-500` | #6b7280 | Gray text color |
| `text-red-500` | #ef4444 | Red text color |
| `text-blue-600` | #2563eb | Blue text color |
| `text-white` | #ffffff | White text |
| `text-black` | #000000 | Black text |
| `text-transparent` | transparent | Transparent text |

## Opacity Modifier

Control the opacity of the text color using the color opacity modifier. Add a forward slash and the opacity percentage value to any color utility.

<!-- TODO: [EXAMPLE_NEEDED] path="typography/text_color_opacity" action="CREATE" -->
<!-- Description: Show a stack of text with decreasing opacity (100%, 75%, 50%, 25%) using blue-500 -->
<x-preview path="typography/text_color_opacity" size="md" source="example/lib/pages/typography/text_color_opacity.dart"></x-preview>

```dart
WDiv(
  className: 'flex flex-col gap-2',
  children: [
    WText('Text opacity 100%', className: 'text-blue-500'),
    WText('Text opacity 75%', className: 'text-blue-500/75'),
    WText('Text opacity 50%', className: 'text-blue-500/50'),
    WText('Text opacity 25%', className: 'text-blue-500/25'),
  ],
)
```

## Responsive Design

Apply different text colors at specific breakpoints using standard responsive prefixes.

```dart
WText(
  'Responsive Text Color',
  className: 'text-blue-500 md:text-green-500 lg:text-red-500',
)
```

## Dark Mode

Use the `dark:` prefix to apply specific text colors when dark mode is active.

```dart
WDiv(
  className: 'bg-white dark:bg-slate-900 p-6',
  child: WText(
    'Dark Mode Support',
    className: 'text-slate-900 dark:text-white',
  ),
)
```

## Arbitrary Values

If you need a specific color that isn't in your theme, use square brackets to generate a property on the fly using a hex code.

```dart
WText(
  'Custom Hex Color',
  className: 'text-[#50d71e]',
)
```

## Customizing Theme

To add your own colors, modify the `colors` property in `WindThemeData`.

```dart
WindThemeData(
  colors: {
    // Add custom color map
    'brand': {
      '500': Color(0xFF1E40AF),
    },
    // Extend existing map
    ...WindThemeData.defaultColors,
    'tahiti': {
      '100': Color(0xFFcffafe),
      '900': Color(0xFF164e63),
    },
  },
)
```

Then use them in your classes:

```dart
WText('My Brand Color', className: 'text-brand-500')
WText('Tahiti Color', className: 'text-tahiti-900')
```

## Related Documentation

- [Background Color](../styling/background-color.md)
- [Text Decoration Color](text-decoration-color.md)
