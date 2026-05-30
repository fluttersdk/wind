# Customizing Shadows

Manage shadow sizes through `WindTheme`: pre-defined keys, arbitrary values, and runtime customization.

- [Default Shadow Sizes](#default-shadow-sizes)
- [Arbitrary Shadow Values](#arbitrary-shadow-values)
- [Managing Shadows](#managing-shadows)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setShadowSize('custom', 10);
double size = WindTheme.getShadowSize('xl'); // 12
```

<a name="default-shadow-sizes"></a>
## Default Shadow Sizes

`WindTheme` includes default shadow sizes mapped to descriptive keys. Each value is an elevation in px.

| Key | Value (px) | Description |
|:---|:---|:---|
| `none` | `0` | No shadow |
| `sm` | `1` | Small shadow |
| `default` | `2` | Default shadow size |
| `md` | `4` | Medium shadow |
| `lg` | `8` | Large shadow |
| `xl` | `12` | Extra large shadow |
| `2xl` | `16` | Very large shadow |
| `3xl` | `24` | Extra extra large shadow |
| `inner` | `1` | Inner shadow effect |

For example:

- `shadow-sm` applies a shadow with an elevation of **1px**.
- `shadow-lg` applies a shadow with an elevation of **8px**.

<a name="arbitrary-shadow-values"></a>
## Arbitrary Shadow Values

For sizes outside the scale, use the `shadow-[value]` syntax, where value is the desired elevation in px.

- `shadow-[8]` applies a shadow with an elevation of **8px**.
- `shadow-[20]` applies a shadow with an elevation of **20px**.

<a name="managing-shadows"></a>
## Managing Shadows

`WindTheme` provides methods to check, retrieve, customize, and remove shadow sizes at runtime.

```dart
// Check whether a shadow size exists
bool exists = WindTheme.hasShadowSize('lg');
print(exists); // Output: true
```

```dart
// Retrieve a shadow size value
double size = WindTheme.getShadowSize('xl');
print(size); // Output: 12
```

```dart
// Add a custom shadow size
WindTheme.setShadowSize('custom', 10);

// Update an existing shadow size
WindTheme.setShadowSize('lg', 6);
```

```dart
// Remove a shadow size
WindTheme.removeShadowSize('sm');
```

<a name="related-documentation"></a>
## Related Documentation
- [Shadow Utilities](../effects/shadow.md) — apply shadows with `shadow-*`
- [Rounded Corners](./rounded-corners.md) — customize corner radii
- [Colors](./colors.md) — the palette behind surface styling
