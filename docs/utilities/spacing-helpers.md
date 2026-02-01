# Spacing Helpers

Programmatic access to theme spacing values.

## wSpacing Function

Get consistent spacing values based on the theme's base spacing unit:

```dart
// Get spacing (multiplier × baseSpacingUnit)
double p4 = wSpacing(context, 4);    // 16.0 (4 × 4.0)
double p2 = wSpacing(context, 2);    // 8.0  (2 × 4.0)
double half = wSpacing(context, 0.5); // 2.0  (0.5 × 4.0)
```

## Context Extension

Use the shortcut extension:

```dart
double space = context.wSpacingExt(4); // 16.0
```

## Usage Example

```dart
Container(
  padding: EdgeInsets.all(wSpacing(context, 4)),
  margin: EdgeInsets.symmetric(
    horizontal: wSpacing(context, 2),
    vertical: wSpacing(context, 1),
  ),
  child: Text('Consistent spacing'),
)
```

## Function Reference

| Function | Description |
| :--- | :--- |
| `wSpacing(context, multiplier)` | Returns spacing value |
| `context.wSpacingExt(multiplier)` | Extension shortcut |

## Theme Configuration

The base spacing unit defaults to 4.0 and can be customized:

```dart
WindThemeData(
  baseSpacingUnit: 4.0, // Default
)
```

## Related

- [Color Helpers](./color-helpers.md)
- [Typography Helpers](./typography-helpers.md)
