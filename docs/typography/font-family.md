# Font Family

Utilities for controlling the font family of an element.

## Basic Usage

Control the font family using `font-{family}` utilities.

```dart
// System sans-serif
WText("Sans-serif text", className: "font-sans")

// Serif fonts
WText("Serif text", className: "font-serif")

// Monospace
WText("Monospace text", className: "font-mono")
```

## Supported Utility Classes

| Category | Classes | Font Family |
| :--- | :--- | :--- |
| **Sans** | `font-sans` | System UI, sans-serif |
| **Serif** | `font-serif` | Georgia, serif |
| **Mono** | `font-mono` | UI Monospace, monospace |

## Default Font

By default, Wind applies the `font-sans` family to all text (like Tailwind CSS). This is controlled by `applyDefaultFontFamily` in WindThemeData.

```dart
// Default behavior: font-sans is applied to all text
WindTheme(
  data: WindThemeData(), // applyDefaultFontFamily = true (default)
  child: ...
)

// Disable default font
WindTheme(
  data: WindThemeData(applyDefaultFontFamily: false),
  child: ...
)
```

## Arbitrary Values

For custom font families, use the bracket notation.

```dart
// Custom font
WText("Roboto text", className: "font-[Roboto]")

// Font stack
WText("Inter text", className: "font-[Inter, sans-serif]")
```

## Customizing Theme

You can customize font families via WindThemeData:

```dart
WindTheme(
  data: WindThemeData(
    fontFamilies: {
      'sans': 'Inter, system-ui, sans-serif',
      'serif': 'Georgia, serif',
      'mono': 'JetBrains Mono, monospace',
      'display': 'Poppins, sans-serif',  // custom family
    },
  ),
  child: ...
)
```

Then use in your widgets:

```dart
WText("Display heading", className: "font-display")
```

## Using Google Fonts

You can easily integrate [google_fonts](https://pub.dev/packages/google_fonts) package:

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

<x-preview path="typography/font_family" size="md"></x-preview>
