# Theme Configuration

- [Introduction](#introduction)
- [The WindTheme Widget](#the-windtheme-widget)
- [Colors](#colors)
- [Typography](#typography)
- [Spacing and Sizing](#spacing-and-sizing)
- [Borders and Shadows](#borders-and-shadows)
- [Customizing Defaults](#customizing-defaults)
- [Quick Reference](#quick-reference)

<!-- TODO: [EXAMPLE_NEEDED] path="core-concepts/theming" action="CREATE" -->
<!-- Description: Showcase a customized WindThemeData with unique colors, spacing, and typography scales. -->
<x-preview path="core-concepts/theming" size="md" source="example/lib/pages/core-concepts/theming_example.dart"></x-preview>

<a name="introduction"></a>
## Introduction

Wind is designed to be fully customizable from the ground up. If you've ever used Tailwind CSS, you'll feel right at home with how we handle "design tokens." Instead of hunting through nested widget properties to change a color or a font size, you define your design system once in your theme configuration.

Everything in Wind—from the colors in `bg-blue-500` to the spacing in `p-4`—is driven by `WindThemeData`. This ensures that your UI remains consistent across the entire application while giving you the freedom to break away from defaults whenever you need to.

<a name="the-windtheme-widget"></a>
## The WindTheme Widget

To start customizing your design system, you need to wrap your application with the `WindTheme` widget. This widget acts as a provider, making your theme configuration available to all `W` widgets in the tree.

> [!IMPORTANT]
> Always use the `data:` parameter when providing your theme configuration. Earlier alpha versions used `theme:`, but this has been updated for consistency.

Let's look at a basic setup:

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  runApp(
    WindTheme(
      data: WindThemeData(
        // We'll customize this in the next sections
      ),
      child: MaterialApp(
        home: MyHome(),
      ),
    ),
  );
}
```

<a name="colors"></a>
## Colors

Colors in Wind are defined as palettes. When you add a color to your theme, Wind expects a `MaterialColor` (or a Map of shades) so it can resolve utilities like `bg-brand-50` through `bg-brand-950`.

Here's how to define custom colors:

```dart
WindThemeData(
  colors: {
    // Single color - Wind automatically generates shades
    'brand': Colors.indigo, 
    
    // Explicit shades for fine-tuned control
    'accent': MaterialColor(0xFF3B82F6, {
      50: Color(0xFFEFF6FF),
      500: Color(0xFF3B82F6),
      900: Color(0xFF1E3A8A),
    }),
  },
)
```

Once defined, these become available as utility classes immediately: `text-brand-600`, `bg-accent-500/50`, or `border-brand-900`.

<a name="typography"></a>
## Typography

You can take full control of your app's typography by overriding font families, sizes, and weights. Wind applies a "sans" font family globally by default, mimicking Tailwind's behavior.

```dart
WindThemeData(
  fontFamilies: {
    'sans': 'Inter',      // The default global font
    'display': 'Oswald',   // Accessible via font-display
  },
  fontSizes: {
    'xs': 12.0,
    'base': 16.0,
    'xl': 20.0,
    '4xl': 36.0,
  },
  fontWeights: {
    'thin': FontWeight.w100,
    'bold': FontWeight.w700,
  },
)
```

But what if you don't want Wind to inject a global `DefaultTextStyle`? You can simply set `applyDefaultFontFamily: false` in your configuration.

<a name="spacing-and-sizing"></a>
## Spacing and Sizing

Wind uses a numeric scale for spacing (`p-4`, `m-2`, `gap-6`). By default, each unit is equal to `4.0` logical pixels. This means `p-4` translates to `16.0` pixels.

If your design system is built on a different grid (like a 5px or 8px grid), you can adjust the `baseSpacingUnit`:

```dart
WindThemeData(
  baseSpacingUnit: 5.0, // Now p-4 = 20px
)
```

You can also customize the "container" sizes or "screen" breakpoints if the default Tailwind values don't fit your needs:

```dart
WindThemeData(
  screens: {
    'sm': 600,
    'md': 900,
    'lg': 1200,
  },
)
```

<a name="borders-and-shadows"></a>
## Borders and Shadows

The "feel" of your app often comes down to its borders and shadows. Wind allows you to define these scales explicitly so your `rounded-lg` or `shadow-xl` classes are always consistent.

```dart
WindThemeData(
  borderRadius: {
    'none': 0,
    'sm': 2,
    'DEFAULT': 4, // Applied by 'rounded' class
    'lg': 8,
    'full': 9999,
  },
  shadows: {
    'sm': [BoxShadow(color: Colors.black12, blurRadius: 2)],
    'md': [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
  },
)
```

<a name="customizing-defaults"></a>
## Customizing Defaults

Wind provides a comprehensive default theme that matches Tailwind CSS v3. When you provide your own `WindThemeData`, your values are **merged** with the defaults.

If you want to tweak just one or two things from an existing configuration, use `copyWith`:

```dart
final darkTheme = myDefaultTheme.copyWith(
  brightness: Brightness.dark,
  ringColor: Colors.amber,
);
```

<a name="quick-reference"></a>
## Quick Reference

| Property | Type | Description |
|:---------|:-----|:------------|
| `brightness` | `Brightness` | Sets the default mode (`light` or `dark`). |
| `colors` | `Map<String, MaterialColor>` | Custom color palettes for your app. |
| `baseSpacingUnit` | `double` | The multiplier for numeric spacing (default: 4.0). |
| `fontFamilies` | `Map<String, String>` | Font aliases (sans, serif, mono, etc.). |
| `fontSizes` | `Map<String, double>` | Numeric scale for text sizes. |
| `borderRadius` | `Map<String, double>` | Corner radius scale for `rounded-*`. |
| `shadows` | `Map<String, List<BoxShadow>>` | Shadow definitions for `shadow-*`. |
| `syncWithSystem` | `bool` | Whether to automatically follow OS brightness. |

For more details on how to sync these values with Flutter's standard Material components, check out the [Theme Binding](./theme-binding.md) guide.

That's all.
