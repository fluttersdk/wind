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

## Basic Usage

Use `shadow-{size}` utilities to apply different shadow intensities to an element.

```dart
WDiv(
  className: 'shadow-lg bg-white rounded-lg p-6',
  child: WText('Shadow Example'),
)
```

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

## Variants

### Shadow Colors

Use `shadow-{color}` utilities to change the color of the shadow. This preserves the original shadow's opacity structure while tinting it with the specified color.

<x-preview path="effects/shadows_colored" size="md" source="example/lib/pages/effects/shadows_colored.dart"></x-preview>

```dart
// Blue tinted shadow
WDiv(className: 'shadow-lg shadow-blue-500')

// Red tinted shadow
WDiv(className: 'shadow-md shadow-red-500')
```

| Class | Description |
|:------|:------------|
| `shadow-{color}` | Tints the shadow with the specified color (e.g., `shadow-red-500`) |

### Shadow Opacity

Control shadow color opacity with the `/` modifier.

```dart
WDiv(className: 'shadow-xl shadow-red-500/50')
```

### Removing Shadows

Use `shadow-none` to remove any existing box shadows from an element. This is useful for resetting shadows at specific breakpoints.

```dart
WDiv(className: 'shadow-lg md:shadow-none')
```

## Responsive Design

Apply different shadow utilities at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WDiv(className: 'shadow-sm md:shadow-lg xl:shadow-2xl')
```

## Dark Mode

Use the `dark:` prefix to apply different shadow styles when the application is in dark mode.

```dart
WDiv(className: 'shadow-lg bg-white dark:bg-gray-800 dark:shadow-black/30')
```

## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom shadow colors.

```dart
// Custom shadow color hex
WDiv(className: 'shadow-lg shadow-[#50d71e]')
```

> [!NOTE]
> Currently, arbitrary values only support custom colors. For custom shadow sizes (offsets, blur), use the theme customization options.

## Customizing Theme

To extend or override the default shadow scale, modify the `shadows` property in `WindThemeData`.

```dart
WindThemeData(
  shadows: {
    // Add a custom shadow preset
    'soft': [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    // Override the default 'xl' shadow
    'xl': [
      BoxShadow(
        color: Colors.blue.withOpacity(0.2),
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

## Related Documentation

- [Opacity](./opacity.md)
- [Ring](../borders/ring.md)
- [Background Color](../styling/background-color.md)
