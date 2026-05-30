# Pixel Factor Customization

The pixel factor emulates the CSS rem unit, providing a single multiplier that scales all size-related values across your application.

- [What is Pixel Factor](#what-is-pixel-factor)
- [How Pixel Factor Works](#how-pixel-factor-works)
- [Managing Pixel Factor](#managing-pixel-factor)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setPixelFactor(6.0);
double factor = WindTheme.getPixelFactor(); // 6.0
double rem = WindTheme.getRemFactor(); // pixelFactor * 4 = 24.0
```

<a name="what-is-pixel-factor"></a>
## What is Pixel Factor

Like the CSS rem unit, the pixel factor acts as a base unit multiplier. Size values (font sizes, spacing, padding) are calculated relative to this factor, enabling consistent scaling across resolutions.

**Default value:** the pixel factor is `4.0`.

<a name="how-pixel-factor-works"></a>
## How Pixel Factor Works

The rem factor is derived by multiplying the pixel factor by 4 (`getRemFactor` returns `pixelFactor * 4`). This relationship gives a predictable scaling system.

### Example Calculation

With the default pixel factor of `4.0`:

```text
1 rem = 4.0 * 4 = 16.0
```

A `2xl` font size with a multiplier of `1.5` therefore calculates to:

```text
1.5 (font size) * 4.0 (pixel factor) * 4 = 24.0
```

<a name="managing-pixel-factor"></a>
## Managing Pixel Factor

`WindTheme` exposes methods to read and set the pixel factor and to compute the derived rem factor.

```dart
// Retrieve the current pixel factor
double currentFactor = WindTheme.getPixelFactor();
print('Current pixel factor: $currentFactor'); // Output: 4.0 (default)
```

```dart
// Retrieve the derived rem factor (pixelFactor * 4)
double rem = WindTheme.getRemFactor();
print('Current rem factor: $rem'); // Output: 16.0 (default)
```

```dart
// Set a custom pixel factor
WindTheme.setPixelFactor(6.0);
print(WindTheme.getPixelFactor()); // Output: 6.0
```

Setting a new pixel factor scales all size-related values proportionally.

<a name="related-documentation"></a>
## Related Documentation
- [Font Size](./font-size.md) — sizes scale by the rem factor
- [Rounded Corners](./rounded-corners.md) — radii scale by the rem factor
- [Spacing: Padding](../spacing/padding.md) — padding values scale by the rem factor
