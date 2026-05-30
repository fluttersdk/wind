# Customizing Line Height

Manage line heights through `WindTheme`: pre-defined keys, arbitrary values, and runtime customization.

- [Default Line Heights](#default-line-heights)
- [Arbitrary Line Heights](#arbitrary-line-heights)
- [Managing Line Heights](#managing-line-heights)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setLineHeight('custom', 1.2);
double height = WindTheme.getLineHeight('tight'); // 1.25
```

<a name="default-line-heights"></a>
## Default Line Heights

`WindTheme` includes several pre-defined line heights mapped to intuitive keys. Values are multipliers applied to the font size.

| Key | Value | Description |
|:---|:---|:---|
| `3` | `0.75` | Compact line height |
| `4` | `1` | Standard compact |
| `5` | `1.25` | Slightly expanded |
| `6` | `1.5` | Comfortable |
| `7` | `1.75` | Spacious |
| `8` | `2` | Very spacious |
| `9` | `2.25` | Extra spacious |
| `10` | `2.5` | Maximum spaciousness |
| `none` | `1` | No additional spacing |
| `tight` | `1.25` | Tight spacing |
| `snug` | `1.375` | Snug spacing |
| `normal` | `1.5` | Normal spacing |
| `relaxed` | `1.625` | Relaxed spacing |
| `loose` | `2` | Loose spacing |

For example:

- `leading-3` applies a line height of **0.75**.
- `leading-8` applies a line height of **2**.

<a name="arbitrary-line-heights"></a>
## Arbitrary Line Heights

For values outside the scale, use the `leading-[value]` syntax, where value is the desired multiplier.

- `leading-[1.2]` applies a line height of **1.2**.
- `leading-[2.8]` applies a line height of **2.8**.

<a name="managing-line-heights"></a>
## Managing Line Heights

`WindTheme` provides methods to check, retrieve, add, and remove line heights at runtime.

```dart
// Check whether a line height exists
bool exists = WindTheme.hasLineHeight('normal');
print(exists); // Output: true
```

```dart
// Retrieve a line height value
double height = WindTheme.getLineHeight('tight');
print(height); // Output: 1.25
```

```dart
// Add a custom line height
WindTheme.setLineHeight('custom', 1.2);

// Update an existing line height
WindTheme.setLineHeight('snug', 1.4);
```

```dart
// Remove a line height
WindTheme.removeLineHeight('custom');
```

<a name="related-documentation"></a>
## Related Documentation
- [Line Height Utilities](../typography/line-height.md) — apply heights with `leading-*`
- [Letter Spacing](./letter-spacing.md) — customize character spacing
- [Font Size](./font-size.md) — customize the typographic scale
