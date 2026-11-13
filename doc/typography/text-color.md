# Text Color

Utilities for controlling the text colour of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Opacity Modifier](#opacity-modifier)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_color_basic" size="md" source="example/lib/pages/typography/text_color_basic.dart"></x-preview>

```dart
// Basic text colors
WText('Error', className: 'text-red-500')
WText('Success', className: 'text-green-600')
WText('Info', className: 'text-blue-500')
```

<a name="basic-usage"></a>
## Basic Usage

Control the text colour of an element using the `text-{color}-{shade}` utilities.

```dart
WDiv(
  className: 'p-4 bg-white rounded-lg shadow-sm',
  children: [
    WText('The quick brown fox', className: 'text-slate-900 font-bold text-xl'),
    WText('Jumps over the lazy dog', className: 'text-slate-500'),
  ],
)
```

<a name="quick-reference"></a>
## Quick Reference

Wind includes the standard Tailwind colour palette. Here are some examples:

| Class | Value | Description |
|:------|:------|:------------|
| `text-slate-500` | #64748b | Slate text colour |
| `text-gray-500` | #6b7280 | Gray text colour |
| `text-red-500` | #ef4444 | Red text colour |
| `text-blue-600` | #2563eb | Blue text colour |
| `text-white` | #ffffff | White text |
| `text-black` | #000000 | Black text |
| `text-transparent` | transparent | Transparent text |

<a name="opacity-modifier"></a>
## Opacity Modifier

Control the opacity of the text colour using the colour opacity modifier. Add a forward slash and the opacity percentage value to any colour utility.

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

<a name="responsive-design"></a>
## Responsive Design

Apply different text colours at specific breakpoints using standard responsive prefixes.

```dart
WText(
  'Responsive Text Color',
  className: 'text-blue-500 md:text-green-500 lg:text-red-500',
)
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply specific text colours when dark mode is active.

```dart
WDiv(
  className: 'bg-white dark:bg-slate-900 p-6',
  child: WText(
    'Dark Mode Support',
    className: 'text-slate-900 dark:text-white',
  ),
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If you need a specific colour that isn't in your theme, use square brackets to generate a property on the fly using a hex code.

```dart
WText(
  'Custom Hex Color',
  className: 'text-[#50d71e]',
)
```

Three, four, six and eight hex digits are accepted, matching [`hexToColor`](../utilities/color-helpers.md#hex-colors). The four- and eight-digit forms carry alpha and it leads, because Flutter packs `AARRGGBB` where CSS writes `RRGGBBAA`. The same lengths apply to `decoration-[#...]`.

```dart
WText('Half-faded', className: 'text-[#8050d71e]')
WText('Underlined', className: 'underline decoration-[#80ff0000]')
```

<a name="customizing-theme"></a>
## Customizing Theme

To add your own colours, modify the `colors` property in `WindThemeData`.

```dart
WindThemeData(
  colors: {
    // Add custom color maps
    'brand': MaterialColor(0xFF1E40AF, {500: Color(0xFF1E40AF)}),
    'tahiti': MaterialColor(0xFF164E63, {100: Color(0xFFCFFAFE), 900: Color(0xFF164E63)}),
  },
)
```

The map merges with the default palette by name, so the built-in colours stay available. A name that matches a built-in palette (`blue`, say) replaces that whole palette, not shade by shade: list every shade you still use, or `text-blue-600` stops resolving.

Then use them in your classes:

```dart
WText('My Brand Color', className: 'text-brand-500')
WText('Tahiti Color', className: 'text-tahiti-900')
```

<a name="related-documentation"></a>
## Related Documentation

- [Background Colour](../styling/background-color.md)
- [Text Decoration](./text-decoration.md#decoration-color)
