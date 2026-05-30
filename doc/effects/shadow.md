# Shadow

Apply shadow effects to widgets using predefined elevation keys or arbitrary pixel values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="effects/shadow" size="md" source="example/lib/pages/effects/shadow.dart"></x-preview>

```dart
WCard(
  className: 'shadow-lg p-4 bg-white dark:bg-gray-800',
  child: WText('Large Shadow', className: 'text-gray-700 dark:text-gray-200'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Use the `shadow-` prefix followed by a size key to apply a box shadow:

```dart
WCard(
  className: 'shadow p-4 bg-white dark:bg-gray-800',
  child: WText('Default shadow', className: 'text-gray-900 dark:text-white'),
)

WCard(
  className: 'shadow-xl p-4 bg-white dark:bg-gray-800',
  child: WText('Extra large shadow', className: 'text-gray-900 dark:text-white'),
)
```

Shadows are rendered as a `BoxShadow` with `color: Colors.black.withOpacity(0.1)`, the elevation as `blurRadius`, and `offset: Offset(0, elevation / 2)`.

<a name="quick-reference"></a>
## Quick Reference

### Syntax

```text
shadow-[size]
shadow
```

Using `shadow` without a size applies the `default` key (2px blur radius).

| Class | Blur Radius | Description |
|:------|:-----------|:------------|
| `shadow-none` | 0 | No shadow |
| `shadow-sm` | 1 | Subtle shadow |
| `shadow` | 2 | Default shadow |
| `shadow-md` | 4 | Medium shadow |
| `shadow-lg` | 8 | Large shadow |
| `shadow-xl` | 12 | Extra large shadow |
| `shadow-2xl` | 16 | Very large shadow |
| `shadow-3xl` | 24 | Maximum shadow |
| `shadow-inner` | 1 | Inner shadow (subtle) |

<a name="arbitrary-values"></a>
## Arbitrary Values

Set any shadow blur radius with bracket notation. The value is used directly as pixels:

```text
shadow-[[value]]
```

```dart
WCard(
  className: 'shadow-[6] p-4 bg-white dark:bg-gray-800',
  child: WText('Custom Shadow', className: 'text-gray-700 dark:text-gray-200'),
)

WCard(
  className: 'shadow-[20] p-4 bg-white dark:bg-gray-800',
  child: WText('Very large custom shadow'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Adjust shadow intensity at different breakpoints:

```dart
WCard(
  className: 'shadow-sm md:shadow-lg lg:shadow-2xl p-4 bg-white dark:bg-gray-800',
  child: WText('Responsive shadow'),
)
```

<a name="customizing-theme"></a>
## Customizing Theme

Override shadow keys or add new ones with `WindTheme.setShadowSize`:

```dart
// Override an existing key
WindTheme.setShadowSize('lg', 10.0);
// shadow-lg now uses 10px blur radius

// Add a custom key
WindTheme.setShadowSize('card', 6.0);
WCard(className: 'shadow-card p-4 bg-white', child: WText('Card shadow'))
```

See [Customizing Shadows](../customization/shadows.md) for details.

<a name="related-documentation"></a>
## Related Documentation

- [Customizing Shadows](../customization/shadows.md) — override the default shadow scale.
- [Background Color](../backgrounds/background-color.md) — complement shadows with background colors.
- [Border Radius](../borders/border-radius.md) — rounded corners pair well with shadows.
- [Pixel Factor](../customization/pixel-factor.md) — how the pixel factor affects sizing calculations.
