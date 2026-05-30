# Customizing Font Weight

Manage font weights through `WindTheme`: pre-defined keys mapped to Flutter `FontWeight` values, customizable at runtime.

- [Default Font Weights](#default-font-weights)
- [Managing Font Weights](#managing-font-weights)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setFontWeight('ultrabold', FontWeight.w800);
FontWeight weight = WindTheme.getFontWeight('medium'); // FontWeight.w500
```

<a name="default-font-weights"></a>
## Default Font Weights

`WindTheme` ships pre-defined font weights mapped to intuitive keys. Each key corresponds to a Flutter `FontWeight` value.

| Key | FontWeight | Description |
|:---|:---|:---|
| `thin` | `w100` | Thinnest weight |
| `extralight` | `w200` | Extra light weight |
| `light` | `w300` | Light weight |
| `normal` | `w400` | Regular weight |
| `medium` | `w500` | Medium weight |
| `semibold` | `w600` | Semi-bold weight |
| `bold` | `w700` | Bold weight |
| `extrabold` | `w800` | Extra bold weight |
| `black` | `w900` | Heaviest weight |

For example:

- `font-thin` applies the thinnest weight (`w100`).
- `font-bold` applies a bold weight (`w700`).

<a name="managing-font-weights"></a>
## Managing Font Weights

`WindTheme` provides methods to check, retrieve, customize, and remove font weights at runtime.

```dart
// Check whether a font weight exists
bool exists = WindTheme.hasFontWeight('bold');
print(exists); // Output: true
```

```dart
// Retrieve a font weight value
FontWeight weight = WindTheme.getFontWeight('medium');
print(weight); // Output: FontWeight.w500
```

```dart
// Add a custom font weight
WindTheme.setFontWeight('ultrabold', FontWeight.w800);

// Update an existing font weight
WindTheme.setFontWeight('bold', FontWeight.w600);
```

```dart
// Remove a font weight
WindTheme.removeFontWeight('extralight');
```

<a name="related-documentation"></a>
## Related Documentation
- [Font Weight Utilities](../typography/font-weight.md) — apply weights with `font-*`
- [Font Family](./font-family.md) — customize the body and display fonts
- [Font Size](./font-size.md) — customize the typographic scale
