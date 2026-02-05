# Shadow

Utilities for controlling the box shadow of an element.

<x-preview path="effects/shadow" size="md" source="example/lib/pages/effects/shadow.dart"></x-preview>

## Shadow Sizes

Control shadow intensity with preset sizes:

```dart
WDiv(className: 'shadow-sm bg-white rounded-lg')   // Subtle
WDiv(className: 'shadow bg-white rounded-lg')      // Default
WDiv(className: 'shadow-md bg-white rounded-lg')   // Medium
WDiv(className: 'shadow-lg bg-white rounded-lg')   // Large
WDiv(className: 'shadow-xl bg-white rounded-lg')   // Extra large
WDiv(className: 'shadow-2xl bg-white rounded-lg')  // Dramatic
```

| Class | Description |
| :--- | :--- |
| `shadow-sm` | Subtle shadow (blur: 2) |
| `shadow` | Default shadow (blur: 3) |
| `shadow-md` | Medium shadow (blur: 6) |
| `shadow-lg` | Large shadow (blur: 15) |
| `shadow-xl` | Extra large shadow (blur: 25) |
| `shadow-2xl` | Dramatic shadow (blur: 50) |
| `shadow-none` | Removes shadow |

## Shadow Colors

Colorize shadows using theme colors:

```dart
WDiv(className: 'shadow-xl shadow-blue-500')   // Blue shadow
WDiv(className: 'shadow-xl shadow-red-500')    // Red shadow
WDiv(className: 'shadow-xl shadow-green-500')  // Green shadow
```

### Arbitrary Colors

Use custom hex colors with bracket notation:

```dart
WDiv(className: 'shadow-xl shadow-[#1da1f2]')  // Twitter blue
WDiv(className: 'shadow-xl shadow-[#FF5733]')  // Custom hex
```

## Shadow Opacity

Control shadow color opacity with the `/` modifier:

```dart
WDiv(className: 'shadow-xl shadow-red-500')      // 100%
WDiv(className: 'shadow-xl shadow-red-500/75')   // 75%
WDiv(className: 'shadow-xl shadow-red-500/50')   // 50%
WDiv(className: 'shadow-xl shadow-red-500/25')   // 25%
```

## All Classes

| Class | Description |
| :--- | :--- |
| `shadow-sm` | Subtle shadow |
| `shadow` | Default shadow |
| `shadow-md` | Medium shadow |
| `shadow-lg` | Large shadow |
| `shadow-xl` | Extra large shadow |
| `shadow-2xl` | Dramatic shadow |
| `shadow-none` | Remove shadow |
| `shadow-{color}-{shade}` | Colored shadow |
| `shadow-[#hex]` | Arbitrary color |
| `shadow-{color}/opacity` | Opacity modifier |

## Customizing Theme

Add custom shadow presets in `WindThemeData`:

```dart
WindThemeData(
  shadows: {
    'custom': [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    'deep': [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  },
)
```

Usage: `shadow-custom`, `shadow-deep`

## Related Documentation

- [Ring](../borders/ring.md) - Focus ring utilities
- [Opacity](./opacity.md) - Opacity utilities
