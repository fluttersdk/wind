# Customizing Font Sizes

Manage the typographic scale through `WindTheme`: pre-defined sizes, arbitrary values, and programmatic customization.

- [Default Font Sizes](#default-font-sizes)
- [Arbitrary Font Sizes](#arbitrary-font-sizes)
- [Managing Font Sizes](#managing-font-sizes)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setFontSize('custom', 1.2);
double size = WindTheme.getFontSize('xl'); // 1.25
```

Font sizes are applied with the `text-*` utility (e.g. `text-xl`); the `font-*` prefix is reserved for [font weight](./font-weight.md).

<a name="default-font-sizes"></a>
## Default Font Sizes

`WindTheme` ships a set of pre-defined font sizes. Sizes are stored in rem units and scaled by the rem factor (pixel factor × 4 = 16 by default).

| Key | Value (rem) | Calculated px (rem factor 16) | Description |
|:---|:---|:---|:---|
| `xs` | `0.75` | `12px` | Extra small |
| `sm` | `0.875` | `14px` | Small |
| `base` | `1` | `16px` | Base size |
| `lg` | `1.125` | `18px` | Large |
| `xl` | `1.25` | `20px` | Extra large |
| `2xl` | `1.5` | `24px` | Very large |
| `3xl` | `1.875` | `30px` | Extra extra large |
| `4xl` | `2.25` | `36px` | Huge |
| `5xl` | `3` | `48px` | Massive |
| `6xl` | `4` | `64px` | Gigantic |

For example:

- `text-xs` applies a font size of **12px**.
- `text-3xl` applies a font size of **30px**.

<a name="arbitrary-font-sizes"></a>
## Arbitrary Font Sizes

For sizes outside the scale, use the `text-[value]` syntax, where value is the desired size in px.

- `text-[8]` applies a font size of **8px**.
- `text-[22]` applies a font size of **22px**.

<a name="managing-font-sizes"></a>
## Managing Font Sizes

`WindTheme` provides methods to check, retrieve, add, and remove font sizes at runtime.

```dart
// Check whether a font size exists
bool exists = WindTheme.hasFontSize('lg');
print(exists); // Output: true
```

```dart
// Retrieve a font size value
double size = WindTheme.getFontSize('xl');
print(size); // Output: 1.25
```

```dart
// Add a custom font size
WindTheme.setFontSize('custom', 1.2);

// Update an existing font size
WindTheme.setFontSize('lg', 1.0);
```

```dart
// Remove a font size
WindTheme.removeFontSize('custom');
```

<a name="related-documentation"></a>
## Related Documentation
- [Font Size Utilities](../typography/font-size.md) — apply the scale with `text-*`
- [Pixel Factor](./pixel-factor.md) — how the rem factor scales sizes
- [Font Family](./font-family.md) — customize the body and display fonts
