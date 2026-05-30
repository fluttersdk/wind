# Text Color

Apply color to text using predefined palette classes or arbitrary hex values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_color" size="md" source="example/lib/pages/typography/text_color.dart"></x-preview>

```dart
WText('Red text', className: 'text-red-500 dark:text-red-300');
WText('Muted label', className: 'text-gray-500 dark:text-gray-400');
WText('Custom color', className: 'text-[#1DA1F2]');
```

<a name="basic-usage"></a>
## Basic Usage

Apply text color with the `text-` prefix followed by a color name and shade:

```dart
WText(
  'Primary heading',
  className: 'text-gray-900 dark:text-gray-100 font-bold text-2xl',
);
WText(
  'Supporting body text',
  className: 'text-gray-600 dark:text-gray-400 text-base',
);
```

<a name="quick-reference"></a>
## Quick Reference

The full palette is available in every shade from 50 to 900. Use the pattern `text-{color}-{shade}`:

| Pattern | Example class | Description |
|:--------|:-------------|:------------|
| `text-{color}` | `text-blue` | Color at default shade 500. |
| `text-{color}-{shade}` | `text-blue-600` | Color at a specific shade (50–900). |
| `text-[#rrggbb]` | `text-[#1DA1F2]` | Arbitrary hex color. |

Available color names: `slate`, `gray`, `zinc`, `neutral`, `stone`, `red`, `orange`, `amber`, `yellow`, `lime`, `green`, `emerald`, `teal`, `cyan`, `sky`, `blue`, `indigo`, `violet`, `purple`, `fuchsia`, `pink`, `black`, `white`, `primary`, `secondary`.

Available shades: `50`, `100`, `200`, `300`, `400`, `500`, `600`, `700`, `800`, `900`.

<a name="dark-mode"></a>
## Dark Mode

Wind automatically inverts color shades when dark mode is active. Add a `dark:` prefix variant to provide an explicit color for dark contexts:

```dart
WText(
  'Adaptive text',
  className: 'text-gray-900 dark:text-gray-100',
);
WText(
  'Accent label',
  className: 'text-blue-600 dark:text-blue-400',
);
WText(
  'Error message',
  className: 'text-red-600 dark:text-red-400',
);
```

See [Dark Mode](../concepts/dark-mode.md) for how color inversion works.

<a name="arbitrary-values"></a>
## Arbitrary Values

Set any color not in the predefined palette using a hex code in brackets:

```dart
WText('Brand color', className: 'text-[#1DA1F2]');
WText('Custom pink', className: 'text-[#FF00FF]');
```

<a name="related-documentation"></a>
## Related Documentation

- [Text Decoration](text-decoration.md) — underline, overline, and strikethrough.
- [Font Size](font-size.md) — set text size.
- [Font Weight](font-weight.md) — control text thickness.
- [Dark Mode](../concepts/dark-mode.md) — automatic color inversion.
- [Customizing Colors](../customization/colors.md) — add or override palette colors.
- [WText](../widgets/wtext.md) — the primary text widget.
