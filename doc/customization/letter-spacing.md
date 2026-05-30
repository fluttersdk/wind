# Customizing Letter Spacing

Manage character spacing through `WindTheme`: pre-defined keys, arbitrary values, and runtime customization.

- [Default Letter Spacings](#default-letter-spacings)
- [Arbitrary Letter Spacings](#arbitrary-letter-spacings)
- [Managing Letter Spacings](#managing-letter-spacings)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setLetterSpacing('extra-wide', 0.15);
double spacing = WindTheme.getLetterSpacing('wide'); // 0.025
```

<a name="default-letter-spacings"></a>
## Default Letter Spacings

`WindTheme` defines several pre-defined letter spacings mapped to descriptive keys. Values are in em units.

| Key | Value (em) | Description |
|:---|:---|:---|
| `tighter` | `-0.05` | Very tight spacing |
| `tight` | `-0.025` | Tight spacing |
| `normal` | `0` | Default spacing |
| `wide` | `0.025` | Wide spacing |
| `wider` | `0.05` | Very wide spacing |
| `widest` | `0.1` | Extremely wide spacing |

For example:

- `tracking-tight` applies a letter spacing of **-0.025em**.
- `tracking-wide` applies a letter spacing of **0.025em**.

<a name="arbitrary-letter-spacings"></a>
## Arbitrary Letter Spacings

For values outside the scale, use the `tracking-[value]` syntax, where value is the desired spacing in em units.

- `tracking-[0.1]` applies a letter spacing of **0.1em**.
- `tracking-[0.3]` applies a letter spacing of **0.3em**.

<a name="managing-letter-spacings"></a>
## Managing Letter Spacings

`WindTheme` provides methods to check, retrieve, add, and remove letter spacings at runtime.

```dart
// Check whether a letter spacing exists
bool exists = WindTheme.hasLetterSpacing('normal');
print(exists); // Output: true
```

```dart
// Retrieve a letter spacing value
double spacing = WindTheme.getLetterSpacing('wide');
print(spacing); // Output: 0.025
```

```dart
// Add a custom letter spacing
WindTheme.setLetterSpacing('extra-wide', 0.15);

// Update an existing letter spacing
WindTheme.setLetterSpacing('wide', 0.03);
```

```dart
// Remove a letter spacing
WindTheme.removeLetterSpacing('extra-wide');
```

<a name="related-documentation"></a>
## Related Documentation
- [Letter Spacing Utilities](../typography/letter-spacing.md) — apply spacing with `tracking-*`
- [Line Height](./line-height.md) — customize line height keys
- [Font Size](./font-size.md) — customize the typographic scale
