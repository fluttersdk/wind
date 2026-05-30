# Border Radius

Round widget corners with predefined size keys or arbitrary pixel values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="borders/border_radius" size="md" source="example/lib/pages/borders/border_radius.dart"></x-preview>

```dart
WContainer(
  className: 'border-2 border-red-500 rounded-lg p-4',
  child: WText('Rounded Border', className: 'text-blue-500'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Use the `rounded-` prefix followed by a size key to clip a widget's corners:

```dart
WContainer(
  className: 'bg-blue-500 rounded-md p-4',
  child: WText('Medium radius', className: 'text-white'),
)

WContainer(
  className: 'bg-indigo-600 rounded-full p-4',
  child: WText('Pill shape', className: 'text-white'),
)
```

**Note:** `rounded-*` applies actual clipping via `ClipRRect`, so child content is physically clipped to the border radius.

<a name="quick-reference"></a>
## Quick Reference

### Syntax

```text
rounded-[size]
```

Size keys resolve through the REM factor. The default pixel factor is `4` and the REM factor is `pixelFactor * 4 = 16`:

| Class | REM value | Default px | Description |
|:------|:----------|:-----------|:------------|
| `rounded-none` | 0 | 0px | No rounding |
| `rounded` | 0.25 | 4px | Default rounding |
| `rounded-sm` | 0.125 | 2px | Small |
| `rounded-md` | 0.375 | 6px | Medium |
| `rounded-lg` | 0.5 | 8px | Large |
| `rounded-xl` | 0.75 | 12px | Extra large |
| `rounded-2xl` | 1.0 | 16px | 2x extra large |
| `rounded-3xl` | 1.5 | 24px | 3x extra large |
| `rounded-full` | — | 9999px | Fully rounded (pill/circle) |

<a name="arbitrary-values"></a>
## Arbitrary Values

Set any pixel radius with bracket notation. The value is used directly as pixels:

```text
rounded-[[value]]
```

```dart
WContainer(
  className: 'border-2 border-red-500 rounded-[6] p-4',
  child: WText('Custom Rounded Border', className: 'text-blue-500'),
)

WContainer(
  className: 'bg-green-400 rounded-[20] p-4',
  child: WText('20px radius', className: 'text-white'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Apply different radius values at different breakpoints:

```dart
WContainer(
  className: 'rounded-sm md:rounded-lg lg:rounded-2xl p-4 bg-blue-100',
  child: WText('Breakpoint radius'),
)
```

<a name="customizing-theme"></a>
## Customizing Theme

Override any radius key or add new ones with `WindTheme.setRoundedSize`:

```dart
// Set rounded-lg to a custom REM value
WindTheme.setRoundedSize('lg', 0.75);
// new px = 0.75 * remFactor (default 16) = 12px

// Add a brand-specific key
WindTheme.setRoundedSize('card', 0.625);
// rounded-card = 0.625 * 16 = 10px
WContainer(className: 'rounded-card bg-white p-4', ...)
```

See [Customizing Rounded Corners](../customization/rounded-corners.md) for details.

<a name="related-documentation"></a>
## Related Documentation

- [Border Width](border-width.md) — control border thickness.
- [Border Color](border-color.md) — apply color to borders.
- [Customizing Rounded Corners](../customization/rounded-corners.md) — override the default radius scale.
- [Pixel Factor](../customization/pixel-factor.md) — how the pixel and REM factors affect sizing.
