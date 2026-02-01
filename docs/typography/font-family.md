# Font Family

Utilities for controlling the font family of an element.

<x-preview path="typography/font_family" size="lg" source="example/lib/pages/typography/font_family.dart"></x-preview>

## Basic Usage

Control the font family using `font-{family}` utilities:

### font-sans

System UI, sans-serif fonts (applied by default):

```dart
WText(
  'The quick brown fox jumps over the lazy dog.',
  className: 'font-sans text-lg text-gray-800',
)
```

### font-serif

Serif fonts for elegant typography:

```dart
WText(
  'The quick brown fox jumps over the lazy dog.',
  className: 'font-serif text-lg text-gray-800',
)
```

### font-mono

Monospace fonts for code:

```dart
WText(
  'const message = "Hello, World!";',
  className: 'font-mono text-lg text-gray-800',
)
```

| Class | Font Family |
| :--- | :--- |
| `font-sans` | System UI, sans-serif |
| `font-serif` | Georgia, serif |
| `font-mono` | UI Monospace, monospace |

## Arbitrary Values

For custom font families, use the bracket notation:

```dart
WText('Custom font', className: 'font-[Roboto]')
WText('Font stack', className: 'font-[Inter, sans-serif]')
```

## Customizing Theme

Define custom font families in `WindThemeData`:

```dart
WindTheme(
  data: WindThemeData(
    fontFamilies: {
      'sans': 'Inter, system-ui, sans-serif',
      'serif': 'Georgia, serif',
      'mono': 'JetBrains Mono, monospace',
      'display': 'Poppins, sans-serif',  // custom
    },
  ),
  child: ...
)
```

Usage: `font-display`

## Using Google Fonts

Integrate [google_fonts](https://pub.dev/packages/google_fonts) package:

```dart
import 'package:google_fonts/google_fonts.dart';

WindTheme(
  data: WindThemeData(
    fontFamilies: {
      'sans': GoogleFonts.inter().fontFamily!,
      'serif': GoogleFonts.merriweather().fontFamily!,
      'mono': GoogleFonts.jetBrainsMono().fontFamily!,
      'display': GoogleFonts.poppins().fontFamily!,
    },
  ),
  child: ...
)
```

## Default Font

By default, Wind applies `font-sans` to all text (like Tailwind CSS). Control with `applyDefaultFontFamily`:

```dart
// Disable default font
WindTheme(
  data: WindThemeData(applyDefaultFontFamily: false),
  child: ...
)
```

## All Font Family Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sans** | `font-sans` | System UI, sans-serif |
| **Serif** | `font-serif` | Georgia, serif |
| **Mono** | `font-mono` | Monospace fonts |
| **Arbitrary** | `font-[Name]` | Custom font family |

## Related Documentation

- [Font Size](./font-size.md) - Text size utilities
- [Font Weight](./font-weight.md) - Font weight utilities
