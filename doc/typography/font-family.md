# Font Family

Utilities for controlling the typeface of text.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/font_family" size="lg" source="example/lib/pages/typography/font_family.dart"></x-preview>

```dart
WText('Sans-serif text', className: 'font-sans')
WText('Serif text', className: 'font-serif')
WText('Monospace text', className: 'font-mono')
```

<a name="basic-usage"></a>
## Basic Usage

Use `font-{family}` utilities to apply a font stack to an element.

### Sans-serif

Use `font-sans` to apply a web-safe sans-serif font stack. This is the default font family for Wind.

```dart
WText(
  'The quick brown fox jumps over the lazy dog.',
  className: 'font-sans text-lg',
)
```

### Serif

Use `font-serif` to apply a serif font stack, ideal for long-form text or editorial designs.

```dart
WText(
  'The quick brown fox jumps over the lazy dog.',
  className: 'font-serif text-lg',
)
```

### Monospace

Use `font-mono` to apply a monospace font stack, perfect for code snippets or technical data.

```dart
WText(
  'const pi = 3.14159;',
  className: 'font-mono text-sm bg-gray-100 p-2 rounded',
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Font Family | Description |
|:------|:------------|:------------|
| `font-sans` | `ui-sans-serif, system-ui, ...` | Default sans-serif stack. |
| `font-serif` | `ui-serif, Georgia, ...` | Default serif stack. |
| `font-mono` | `ui-monospace, SFMono-Regular, ...` | Default monospace stack. |

<a name="variants"></a>
## Variants

Hover and focus states can also change the font family, though this is less common.

```dart
WText(
  'Hover me to switch fonts',
  className: 'font-sans hover:font-serif transition-all',
)
```

<a name="responsive-design"></a>
## Responsive Design

Apply different font families at different breakpoints using standard responsive prefixes.

```dart
WText(
  'Responsive Typography',
  className: 'font-sans md:font-serif lg:font-mono',
)
```

<a name="dark-mode"></a>
## Dark Mode

You can enforce specific font families in dark mode using the `dark:` prefix.

```dart
WText(
  'Code Snippet',
  className: 'font-sans dark:font-mono',
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If you need a specific font family that isn't in your theme, use bracket notation. This is useful for one-off fonts.

```dart
WText(
  'Custom Branding',
  className: 'font-[Roboto]',
)
```

<a name="customizing-theme"></a>
## Customizing Theme

To add your own font families (like `font-display` or `font-body`), update `WindThemeData` in your app root.

```dart
WindTheme(
  data: WindThemeData(
    fontFamilies: {
      'sans': 'Inter',      // Overrides default font-sans
      'display': 'Oswald',  // Adds new font-display class
      'body': 'Open Sans',  // Adds new font-body class
    },
  ),
  child: MaterialApp(home: MyApp()),
)
```

Now you can use these classes in your widgets:

```dart
WText('Headlines', className: 'font-display text-4xl')
WText('Body text', className: 'font-body')
```

> [!NOTE]
> When using custom fonts (like Google Fonts), ensure the font assets are properly included in your `pubspec.yaml` or loaded via a package like `google_fonts`.

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](./font-size.md)
- [Font Weight](./font-weight.md)
- [Letter Spacing](./letter-spacing.md)
