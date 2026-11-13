# Shadow

Utilities for controlling the box shadow of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="effects/shadows_basic" size="md" source="example/lib/pages/effects/shadows_basic.dart"></x-preview>

```dart
// Basic examples
WDiv(className: 'shadow')
WDiv(className: 'shadow-lg')
WDiv(className: 'shadow-red-500')
WDiv(className: 'shadow-none')
```

<a name="basic-usage"></a>
## Basic Usage

Use `shadow-{size}` utilities to apply different shadow intensities to an element.

```dart
WDiv(
  className: 'shadow-lg bg-white rounded-lg p-6',
  child: WText('Shadow Example'),
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Properties | Description |
|:------|:-----------|:------------|
| `shadow-sm` | `blur: 2` | Subtle shadow |
| `shadow` | `blur: 3` | Default shadow |
| `shadow-md` | `blur: 6` | Medium shadow |
| `shadow-lg` | `blur: 15` | Large shadow |
| `shadow-xl` | `blur: 25` | Extra large shadow |
| `shadow-2xl` | `blur: 50` | Dramatic shadow |
| `shadow-none` | `none` | Removes shadow |

<a name="variants"></a>
## Variants

### Shadow Colors

Use `shadow-{color}` utilities to change the colour of the shadow. This preserves the original shadow's opacity structure while tinting it with the specified colour.

<x-preview path="effects/shadows_colored" size="md" source="example/lib/pages/effects/shadows_colored.dart"></x-preview>

```dart
// Blue tinted shadow
WDiv(className: 'shadow-lg shadow-blue-500 dark:shadow-blue-400')

// Red tinted shadow
WDiv(className: 'shadow-md shadow-red-500 dark:shadow-red-400')
```

| Class | Description |
|:------|:------------|
| `shadow-{color}` | Tints the shadow with the specified colour (e.g., `shadow-red-500`) |

A colour needs a shade (`shadow-red-500`); only `shadow-white` and `shadow-black` resolve without one.

### Shadow Opacity

`shadow-{color}` keeps each preset layer's own alpha; a `/opacity` modifier is currently ignored when a size is present.

```dart
// The xl layers' own alpha decides the strength
WDiv(className: 'shadow-xl shadow-red-500 dark:shadow-red-400')
```

### Removing Shadows

Use `shadow-none` to remove any existing box shadows from an element. This is useful for resetting shadows at specific breakpoints.

```dart
WDiv(className: 'shadow-lg md:shadow-none')
```

<a name="responsive-design"></a>
## Responsive Design

Apply different shadow utilities at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WDiv(className: 'shadow-sm md:shadow-lg xl:shadow-2xl')
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply different shadow styles when the application is in dark mode.

```dart
WDiv(className: 'shadow-lg bg-white dark:bg-gray-800 dark:shadow-black')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom shadow colours.

```dart
// Custom shadow color hex
WDiv(className: 'shadow-lg shadow-[#50d71e]')
```

> [!NOTE]
> Currently, arbitrary values only support custom colours. For custom shadow sizes (offsets, blur), use the theme customisation options.

<a name="customizing-theme"></a>
## Customizing Theme

To extend or override the default shadow scale, modify the `shadows` property in `WindThemeData`.

```dart
WindThemeData(
  shadows: {
    // Add a custom shadow preset
    'soft': [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    // Override the default 'xl' shadow
    'xl': [
      BoxShadow(
        color: Colors.blue.withValues(alpha: 0.2),
        blurRadius: 30,
        spreadRadius: 5,
      ),
    ],
  },
)
```

Usage:

```dart
WDiv(className: 'shadow-soft')
```

<a name="related-documentation"></a>
## Related Documentation

- [Opacity](./opacity.md)
- [Ring](../borders/ring.md)
- [Background Colour](../styling/background-color.md)
