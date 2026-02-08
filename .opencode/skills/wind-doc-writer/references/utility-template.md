# Wind Utility Documentation Template

This template defines the standard structure for documenting utility classes in Wind. Use this as a blueprint when creating new documentation for features like padding, margins, colors, borders, etc.

---

# {Utility Name}

{One-two sentence description of what this utility does. Focus on the visual impact and how it mirrors Tailwind CSS behavior.}

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="{category}/{feature}_basic" size="md" source="example/lib/pages/{category}/{feature}_basic.dart"></x-preview>

```dart
// Basic examples showing the syntax
WDiv(className: '{utility-class}')
WDiv(className: '{utility-class-variant}')
```

## Basic Usage

Use `{class}` to {describe effect}. Mention common use cases.

```dart
WDiv(
  className: '{class}',
  child: WText('Example'),
)
```

## Quick Reference

| Class | Value | Description |
|:------|:------|:------------|
| `{class-1}` | {value} | {description} |
| `{class-2}` | {value} | {description} |

## Variants

### {Variant Category 1}

{Explain what this variant adds, e.g., "Directional Padding" or "Color Intensity".}

<x-preview path="{category}/{feature}_{variant}" size="md" source="example/lib/pages/{category}/{feature}_{variant}.dart"></x-preview>

```dart
WDiv(className: '{variant-class}')
```

| Class | Description |
|:------|:------------|
| `{variant-1}` | {effect} |

## Responsive Design

Apply different {utility} at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WDiv(className: '{class} md:{class-md} lg:{class-lg}')
```

## Dark Mode

Use the `dark:` prefix to apply different {utility} styles when the application is in dark mode.

```dart
WDiv(className: '{class} dark:{dark-class}')
```

## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly.

```dart
WDiv(className: '{utility}-[{custom-value}]')
```

## Customizing Theme

To extend or override the default scale for {utility}, modify the `WindThemeData` in your app root.

```dart
WindThemeData(
  {themeProperty}: {
    '{custom-key}': {custom-value},
  },
)
```

## Related Documentation

- [{Related Topic 1}](./{related-1}.md)
- [{Related Topic 2}](./{related-2}.md)

---

## Placeholder Naming Conventions

| Placeholder | Description | Example |
|:------------|:------------|:--------|
| `{Utility Name}` | The human-readable name of the utility. | Padding |
| `{category}` | The folder name in `example/lib/pages`. | layout |
| `{feature}` | The specific feature being documented. | padding |
| `{class}` | The primary utility class. | p-4 |
| `{themeProperty}` | The key in `WindThemeData` to customize. | spacing |
| `{utility-class}` | A concrete class example. | bg-red-500 |
