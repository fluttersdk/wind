# Border Color

Apply colors to widget borders using predefined theme colors or arbitrary hex values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="borders/border_color" size="md" source="example/lib/pages/borders/border_color.dart"></x-preview>

```dart
WContainer(
  className: 'border-2 border-red-500 p-4',
  child: WText('Red Border', className: 'text-blue-500'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Combine `border-[width]` with `border-[color]-[shade]` to draw a colored border:

```dart
WContainer(
  className: 'border-2 border-blue-500 p-4',
  child: WText('Blue border', className: 'text-blue-500'),
)

WContainer(
  className: 'border-1 border-gray-300 dark:border-gray-600 p-4 rounded-md',
  child: WText('Subtle border', className: 'text-gray-700 dark:text-gray-200'),
)
```

**Note:** Wind applies border colors via `Border.all` inside `BoxDecoration`, resolved through `applyBorderColor`. Both the width class and the color class must be present for the border to render.

<a name="quick-reference"></a>
## Quick Reference

### Syntax

```text
border-[color]-[shade]
border-[color]
```

- `color`: the color name. Omitting the shade defaults to `500`.
- `shade`: `50`, `100`, `200`, `300`, `400`, `500`, `600`, `700`, `800`, or `900`.

### Example Classes

| Class | Color | Shade | Description |
|:------|:------|:------|:------------|
| `border-red-500` | Red | 500 | Red border |
| `border-blue-300` | Blue | 300 | Light blue border |
| `border-gray-200` | Gray | 200 | Subtle border |
| `border-green-700` | Green | 700 | Dark green border |

For the full palette, see [Customizing Colors](../customization/colors.md).

<a name="arbitrary-values"></a>
## Arbitrary Values

Apply any color with a hex code:

```text
border-[#rrggbb]
```

```dart
WContainer(
  className: 'border-2 border-[#1abc9c] p-4',
  child: WText('Custom Color Border', className: 'text-blue-500'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Prefix the border color class with a breakpoint to apply it conditionally:

```dart
WContainer(
  className: 'border-2 border-gray-300 md:border-blue-500 p-4',
  child: WText('Responsive border color'),
)
```

<a name="dark-mode"></a>
## Dark Mode

Pair light border colors with `dark:` variants:

```dart
WContainer(
  className: 'border-1 border-gray-200 dark:border-gray-700 p-4 rounded-md',
  child: WText('Dark-mode border', className: 'text-gray-900 dark:text-white'),
)
```

<a name="customizing-theme"></a>
## Customizing Theme

Border colors use the same color palette as backgrounds. Add custom colors with `WindTheme.addColor`:

```dart
WindTheme.addColor('brand', MaterialColor(0xFF6200EE, {
  500: Color(0xFF6200EE),
}));

WContainer(className: 'border-2 border-brand-500 p-4', child: WText('Brand border'))
```

See [Customizing Colors](../customization/colors.md) for details.

<a name="related-documentation"></a>
## Related Documentation

- [Border Width](border-width.md) — control the thickness of borders.
- [Border Radius](border-radius.md) — round the corners of widgets.
- [Background Color](../backgrounds/background-color.md) — apply background colors.
- [Customizing Colors](../customization/colors.md) — add and override palette colors.
