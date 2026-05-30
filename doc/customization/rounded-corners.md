# Customizing Rounded Corners

Manage corner radii through `WindTheme`: pre-defined sizes, arbitrary values, and runtime customization.

- [Default Rounded Sizes](#default-rounded-sizes)
- [Arbitrary Rounded Values](#arbitrary-rounded-values)
- [Managing Rounded Sizes](#managing-rounded-sizes)
- [Practical Examples](#practical-examples)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setRoundedSize('custom', 1.25);
double size = WindTheme.getRoundedSize('xl'); // 0.75
```

<a name="default-rounded-sizes"></a>
## Default Rounded Sizes

`WindTheme` ships pre-defined rounded sizes. Each value is in rem units; the calculated px values below assume the default pixel factor (4.0) and rem factor (4.0).

| Key | Value (rem) | Calculated px | Description |
|:---|:---|:---|:---|
| `none` | `0` | `0px` | No rounding |
| `default` | `0.25` | `4px` | Default rounding |
| `sm` | `0.125` | `2px` | Small rounding |
| `md` | `0.375` | `6px` | Medium rounding |
| `lg` | `0.5` | `8px` | Large rounding |
| `xl` | `0.75` | `12px` | Extra large rounding |
| `2xl` | `1` | `16px` | Very large rounding |
| `3xl` | `1.5` | `24px` | Extra extra large |
| `full` | `9999` | Infinite | Fully rounded corners |

The px values are calculated as:

```text
{px} = {rem} * {pixel factor (4.0)} * {rem factor (4.0)}
```

For example, `rounded-lg` results in **0.5 × 4 × 4 = 8px**.

<a name="arbitrary-rounded-values"></a>
## Arbitrary Rounded Values

For radii outside the scale, use the `rounded-[value]` syntax, where value is the desired radius in px.

- `rounded-[7]` applies a radius of **7px**.
- `rounded-[20]` applies a radius of **20px**.

<a name="managing-rounded-sizes"></a>
## Managing Rounded Sizes

`WindTheme` provides methods to check, retrieve, customize, and remove rounded sizes at runtime.

```dart
// Check whether a rounded size exists
bool exists = WindTheme.hasRoundedSize('lg');
print(exists); // Output: true
```

```dart
// Retrieve a rounded size value (in rem)
double size = WindTheme.getRoundedSize('xl');
print(size); // Output: 0.75
```

```dart
// Add a new size
WindTheme.setRoundedSize('4xl', 2);

// Update an existing size
WindTheme.setRoundedSize('lg', 0.6);
```

```dart
// Remove a rounded size
WindTheme.removeRoundedSize('sm');
```

<a name="practical-examples"></a>
## Practical Examples

### Pre-defined Sizes

```dart
WContainer(
  className: 'rounded-xl bg-gray-100 dark:bg-gray-800',
  child: WText('Pre-defined rounded corners'),
);
```

This applies a corner radius of **12px** (0.75 × 4 × 4).

### Arbitrary Values

```dart
WContainer(
  className: 'rounded-[15] bg-gray-200 dark:bg-gray-700',
  child: WText('Arbitrary rounded corners'),
);
```

This applies a corner radius of **15px**.

### Custom Sizes

```dart
// Add a custom size
WindTheme.setRoundedSize('custom', 1.25); // Adds 'rounded-custom'

// Use the custom size
WContainer(
  className: 'rounded-custom bg-gray-300 dark:bg-gray-600',
  child: WText('Custom rounded corners'),
);

// Remove the custom size
WindTheme.removeRoundedSize('custom');
```

<a name="related-documentation"></a>
## Related Documentation
- [Border Radius](../borders/border-radius.md) — apply radii with `rounded-*`
- [Pixel Factor](./pixel-factor.md) — how the rem factor scales sizes
- [Shadows](./shadows.md) — customize shadow sizes
