# Opacity

Utilities for controlling the opacity of an element.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<!-- TODO: [UPDATE] path="effects/opacity" action="verify" -->
<!-- Description: Ensure example demonstrates opacity scale and arbitrary values -->
<x-preview path="effects/opacity" size="md" source="example/lib/pages/effects/opacity.dart"></x-preview>

```dart
WDiv(className: 'opacity-100 bg-blue-500')
WDiv(className: 'opacity-75 bg-blue-500')
WDiv(className: 'opacity-50 bg-blue-500')
WDiv(className: 'opacity-25 bg-blue-500')
WDiv(className: 'opacity-0 bg-blue-500')
```

<a name="basic-usage"></a>
## Basic Usage

Control the opacity of an element using `opacity-{value}` utilities. This affects the entire element, including its content, background, and borders.

```dart
WDiv(
  className: 'opacity-50 bg-blue-500 text-white p-4',
  child: WText('This entire element is 50% opaque'),
)
```

> [!NOTE]
> This utility sets the Flutter `Opacity` widget or `color.withOpacity()` equivalent depending on context. To change only the background color's opacity without affecting text, use the color opacity modifier (e.g., `bg-blue-500/50`) instead.

<a name="quick-reference"></a>
## Quick Reference

| Class | Value | Description |
|:--- |:--- |:--- |
| `opacity-0` | 0 | Fully transparent |
| `opacity-5` | 0.05 | |
| `opacity-10` | 0.1 | |
| `opacity-20` | 0.2 | |
| `opacity-25` | 0.25 | |
| `opacity-30` | 0.3 | |
| `opacity-40` | 0.4 | |
| `opacity-50` | 0.5 | |
| `opacity-60` | 0.6 | |
| `opacity-70` | 0.7 | |
| `opacity-75` | 0.75 | |
| `opacity-80` | 0.8 | |
| `opacity-90` | 0.9 | |
| `opacity-95` | 0.95 | |
| `opacity-100` | 1 | Fully opaque |

<a name="variants"></a>
## Variants

Wind supports all standard state variants for opacity.

```dart
// Change opacity on hover
WDiv(className: 'opacity-50 hover:opacity-100')

// Change opacity when button is disabled
WButton(className: 'bg-blue-500 disabled:opacity-50')

// Change opacity on focus
WInput(className: 'opacity-75 focus:opacity-100')
```

<a name="responsive-design"></a>
## Responsive Design

Change opacity based on screen size using responsive prefixes.

```dart
WDiv(className: 'opacity-100 md:opacity-50 lg:opacity-25')
```

<a name="dark-mode"></a>
## Dark Mode

Adjust opacity based on the current theme brightness.

```dart
WDiv(className: 'opacity-100 dark:opacity-80')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use square brackets to define a custom opacity value between `0.0` and `1.0`.

```dart
WDiv(className: 'opacity-[0.67]')
WDiv(className: 'opacity-[0.125]')
```

> [!WARNING]
> Values are clamped between 0.0 and 1.0. `opacity-[1.5]` will resolve to `1.0`.

<a name="customizing-theme"></a>
## Customizing Theme

You can customize the available opacity scale in your `WindThemeData`.

```dart
WindTheme(
  data: WindThemeData(
    opacities: {
      'disabled': 0.35,
      'faint': 0.10,
      'glass': 0.85,
    },
  ),
  child: MyApp(),
)
```

Now you can use these custom keys in your utilities:

```dart
WDiv(className: 'opacity-disabled') // 0.35
WDiv(className: 'opacity-glass')    // 0.85
```

<a name="related-documentation"></a>
## Related Documentation

- [Background Color](/doc/styling/background-color.md) - Using `/alpha` modifiers for backgrounds
- [Text Color](/doc/typography/text-color.md) - Using `/alpha` modifiers for text
- [Shadow](/doc/styling/shadow.md) - Box shadow utilities
