# Background Color

Utilities for controlling an element's background color.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Opacity Modifier](#opacity-modifier)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<!-- TODO: [EXAMPLE_NEEDED] path="styling/background_color_basic" action="CREATE" -->
<!-- Description: Show a grid of boxes with different background colors (solid, white, black, transparent) -->
<x-preview path="styling/background_color_basic" size="md" source="example/lib/pages/styling/background_color_basic.dart"></x-preview>

```dart
// Solid color
WDiv(className: 'bg-blue-500 h-12 w-12 rounded')

// With opacity
WDiv(className: 'bg-blue-500/50 h-12 w-12 rounded')

// White and Black
WDiv(className: 'bg-white h-12 w-12 rounded')
WDiv(className: 'bg-black h-12 w-12 rounded')
```

<a name="basic-usage"></a>
## Basic Usage

Use `bg-{color}-{shade}` to set the background color of an element. Wind includes a comprehensive palette of colors (slate, gray, red, blue, etc.) with shades from 50 to 950.

```dart
WDiv(
  className: 'bg-blue-500 p-4 rounded-lg',
  child: WText('Blue Background', className: 'text-white'),
)
```

You can also use standalone colors like `bg-white`, `bg-black`, and `bg-transparent`.

```dart
WDiv(className: 'bg-white shadow-md p-6')
WDiv(className: 'bg-transparent border border-gray-300')
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description |
|:------|:------------|
| `bg-{color}-{shade}` | Sets background color (e.g., `bg-red-500`, `bg-slate-900`). |
| `bg-white` | Sets background to white. |
| `bg-black` | Sets background to black. |
| `bg-transparent` | Sets background to transparent. |
| `bg-current` | Sets background to the current text color. |

<a name="opacity-modifier"></a>
## Opacity Modifier

Control the opacity of a background color using the slash modifier `/{opacity}`. The value ranges from 0 to 100.

<!-- TODO: [EXAMPLE_NEEDED] path="styling/background_color_opacity" action="CREATE" -->
<!-- Description: Show the same color with different opacity levels side by side -->
<x-preview path="styling/background_color_opacity" size="md" source="example/lib/pages/styling/background_color_opacity.dart"></x-preview>

```dart
WDiv(className: 'bg-blue-500/100') // 100% (Default)
WDiv(className: 'bg-blue-500/75')  // 75%
WDiv(className: 'bg-blue-500/50')  // 50%
WDiv(className: 'bg-blue-500/25')  // 25%
```

<a name="responsive-design"></a>
## Responsive Design

Change the background color at specific breakpoints using standard responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`).

```dart
// Red on mobile, Blue on medium screens and up
WDiv(className: 'bg-red-500 md:bg-blue-500 h-32 w-full')
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply a different background color when dark mode is active.

```dart
WDiv(
  className: 'bg-white dark:bg-slate-900 p-6 rounded-lg',
  child: WText('Adaptive Background', className: 'text-gray-900 dark:text-white'),
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If you need a specific color not in your theme, use square bracket notation `bg-[#RRGGBB]`.

```dart
WDiv(className: 'bg-[#1da1f2] text-white p-4') // Twitter Blue
WDiv(className: 'bg-[#ff0000]') // Bright Red
```

<a name="customizing-theme"></a>
## Customizing Theme

To add your own colors, modify the `colors` map in `WindThemeData`.

```dart
WindThemeData(
  colors: {
    // Add a custom brand color
    'brand': {
      '500': Color(0xFF1DA1F2),
      '600': Color(0xFF1A91DA),
    },
    // Extend existing palette
    'gray': {
      ...WindThemeData.defaultColors['gray']!,
      '1000': Color(0xFF0F0F0F),
    },
  },
)
```

Now you can use `bg-brand-500` or `bg-gray-1000`.

<a name="related-documentation"></a>
## Related Documentation

- [Background Gradient](./background-gradient.md)
- [Background Image](./background-image.md)
- [Text Color](./text-color.md)
- [Border Color](./border-color.md)
