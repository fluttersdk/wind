# Background Color

Utilities for controlling an element's background colour.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Opacity Modifier](#opacity-modifier)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

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

Use `bg-{color}-{shade}` to set the background colour of an element. Wind includes a comprehensive palette of colours (slate, gray, red, blue, etc.) with shades from 50 to 950.

```dart
WDiv(
  className: 'bg-blue-500 p-4 rounded-lg',
  child: WText('Blue Background', className: 'text-white'),
)
```

You can also use standalone colours like `bg-white`, `bg-black`, and `bg-transparent`.

```dart
WDiv(className: 'bg-white shadow-md p-6')
WDiv(className: 'bg-transparent border border-gray-300')
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description |
|:------|:------------|
| `bg-{color}-{shade}` | Sets background colour (e.g., `bg-red-500`, `bg-slate-900`). |
| `bg-white` | Sets background to white. |
| `bg-black` | Sets background to black. |
| `bg-transparent` | Sets background to transparent. |

<a name="opacity-modifier"></a>
## Opacity Modifier

Control the opacity of a background colour using the slash modifier `/{opacity}`. The value ranges from 0 to 100.

<x-preview path="styling/background_color_opacity" size="md" source="example/lib/pages/styling/background_color_opacity.dart"></x-preview>

```dart
WDiv(className: 'bg-blue-500/100') // 100% (Default)
WDiv(className: 'bg-blue-500/75')  // 75%
WDiv(className: 'bg-blue-500/50')  // 50%
WDiv(className: 'bg-blue-500/25')  // 25%
```

<a name="responsive-design"></a>
## Responsive Design

Change the background colour at specific breakpoints using standard responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`).

```dart
// Red on mobile, Blue on medium screens and up
WDiv(className: 'bg-red-500 md:bg-blue-500 h-32 w-full')
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply a different background colour when dark mode is active.

```dart
WDiv(
  className: 'bg-white dark:bg-slate-900 p-6 rounded-lg',
  child: WText('Adaptive Background', className: 'text-gray-900 dark:text-white'),
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If you need a specific colour not in your theme, use square bracket notation `bg-[#RRGGBB]`.

```dart
WDiv(className: 'bg-[#1da1f2] text-white p-4') // Twitter Blue
WDiv(className: 'bg-[#ff0000]') // Bright Red
```

Three, four, six and eight hex digits are accepted, matching [`hexToColor`](../utilities/color-helpers.md#hex-colors). The four- and eight-digit forms carry alpha and it leads, because Flutter packs `AARRGGBB` where CSS writes `RRGGBBAA`.

```dart
WDiv(className: 'bg-[#f00]')        // #FF0000, opaque
WDiv(className: 'bg-[#80ff0000]')   // #FF0000 at alpha 0x80
WDiv(className: 'bg-[#8f00]')       // #FF0000 at alpha 0x88
```

> [!NOTE]
> The short forms expand by doubling each digit, so `#8f00` is `#88ff0000` and not `#80ff0000`. The 4-digit form cannot spell every alpha; write the 8-digit one when the exact value matters.

> [!NOTE]
> The opacity modifier is the shorter route to the same result on a theme colour: `bg-red-500/50`. Reach for the alpha hex when the colour itself is not in the theme.

<a name="customizing-theme"></a>
## Customizing Theme

To add your own colours, modify the `colors` map in `WindThemeData`.

```dart
WindThemeData(
  colors: {
    // Add a custom brand color
    'brand': MaterialColor(0xFF1DA1F2, {500: Color(0xFF1DA1F2), 600: Color(0xFF1A91DA)}),
  },
)
```

The map merges with the default palette, so the built-in colours stay available. Now you can use `bg-brand-500` or `bg-brand-600`.

<a name="related-documentation"></a>
## Related Documentation

- [Background Gradient](./background-gradient.md)
- [Background Image](./background-image.md)
- [Text Colour](../typography/text-color.md)
- [Border Width, Colour, & Radius](../borders/borders.md)

<!-- steer probe background-color -->
