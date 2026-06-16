# Theme Configuration

- [Introduction](#introduction)
- [The WindTheme Widget](#the-windtheme-widget)
- [Theme Change Callbacks](#theme-change-callbacks)
- [Resetting to System Theme](#resetting-to-system-theme)
- [Colors](#colors)
- [Typography](#typography)
- [Spacing and Sizing](#spacing-and-sizing)
- [Borders and Shadows](#borders-and-shadows)
- [Customizing Defaults](#customizing-defaults)
- [Aliases](#aliases)
- [Quick Reference](#quick-reference)

<x-preview path="core-concepts/theming_example" size="md" source="example/lib/pages/core-concepts/theming_example.dart"></x-preview>

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
      onThemeChanged: (brightness) {
        // Optional: persist user's theme preference
      },
      child: MaterialApp(
        home: MyHome(),
      ),
    ),
  );
}
```

<a name="theme-change-callbacks"></a>
## Theme Change Callbacks

When a user manually toggles the theme via `toggleTheme()`, you may want to persist their preference. The `onThemeChanged` callback fires only on user-initiated theme changes—it does **not** fire when the system brightness changes automatically.

```dart
WindTheme(
  onThemeChanged: (brightness) {
    // Persist user preference
    Vault.set('theme_mode', brightness == Brightness.dark ? 'dark' : 'light');
  },
  data: WindThemeData(),
  child: MaterialApp(
    home: MyHome(),
  ),
)
```

> [!IMPORTANT]
> `onThemeChanged` only fires when the user calls `toggleTheme()`. Automatic system brightness sync does not trigger this callback.

<a name="resetting-to-system-theme"></a>
## Resetting to System Theme

After a user manually toggles the theme, the automatic system sync is disabled to respect their choice. To re-enable automatic system brightness sync, call `resetToSystem()`:

```dart
// Re-enable system brightness sync
WindTheme.of(context).resetToSystem();

// Or via extension
context.windTheme.resetToSystem();
```

This immediately syncs the theme with the current platform brightness and re-enables the `syncWithSystem` flag so future OS changes are reflected automatically.

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

<a name="aliases"></a>
## Aliases

`WindThemeData(aliases: {...})` lets you define short, bare-token names that expand to full utility strings before parsing. Every `W` widget resolves aliases centrally, so a class name like `row` becomes `flex flex-row` everywhere without any per-widget wiring.

```dart
WindThemeData(
  aliases: {
    'row':   'flex flex-row',
    'col':   'flex flex-col',
    'center': 'items-center justify-center',
    'row-c': 'row center',      // recursive: expands 'row' and 'center' first
  },
)
```

With this configuration, the following `className` values are equivalent:

```dart
// Before aliases
WDiv(className: 'flex flex-row items-center justify-center bg-white dark:bg-gray-800')

// After aliases
WDiv(className: 'row-c bg-white dark:bg-gray-800')
```

**How expansion works:**

- Only bare, unprefixed tokens are matched. `md:row` is **not** expanded; only a standalone `row` token qualifies.
- Expansion is recursive: an alias value may reference other aliases. The expander resolves all aliases before handing the result to the parser.
- Aliases are empty by default (`{}`). The feature is purely opt-in: a `WindThemeData` without an `aliases` key behaves identically to today.
- If an alias key shadows a built-in token (for example, `'flex': 'flex flex-row'`), the alias wins and Wind emits a debug-mode warning so you can rename before shipping.

> [!NOTE]
> Alias keys must be plain strings with no colons or slashes. Prefix variants such as `hover:row` or `md:col` are not expanded.

<a name="quick-reference"></a>
## Quick Reference

`WindThemeData` exposes 24 configurable fields. The table below groups them by concern.

### Mode and Behavior

| Property | Type | Default | Description |
|:---------|:-----|:--------|:------------|
| `brightness` | `Brightness` | `light` | Initial mode (`light` or `dark`). Overridden on mount by the OS brightness while `syncWithSystem` is `true` (see note below) |
| `syncWithSystem` | `bool` | `true` | Auto-follow OS brightness until the user calls `toggleTheme()` |
| `applyDefaultFontFamily` | `bool` | `true` | Inject Wind's default font family as a global `DefaultTextStyle` |
| `baseSpacingUnit` | `double` | `4.0` | Multiplier for numeric spacing (`p-4` → `4 * 4 = 16px`) |

> Setting `brightness: Brightness.dark` alone has no effect while `syncWithSystem` is `true` (the default): the controller reads the OS brightness on mount and overrides it, so `dark:` classes stay inactive on a light OS. To pin a fixed mode, pass `WindThemeData(brightness: Brightness.dark, syncWithSystem: false)`, or switch at runtime with `controller.toggleTheme()` / `setTheme(...)`.

### Tokens

| Property | Type | Description |
|:---------|:-----|:------------|
| `colors` | `Map<String, MaterialColor>` | Custom color palettes (`bg-brand-500`, etc.) |
| `screens` | `Map<String, int>` | Breakpoint min-widths (`sm`, `md`, `lg`, `xl`, `2xl`, custom) |
| `containers` | `Map<String, int>` | Container max-widths (`container` utility) |
| `fontFamilies` | `Map<String, String>` | Font aliases (`sans`, `serif`, `mono`, custom) |
| `fontSizes` | `Map<String, double>` | Text size scale (`text-xs` through `text-6xl`) |
| `fontWeights` | `Map<String, FontWeight>` | Weight scale (`font-thin` through `font-black`) |
| `tracking` | `Map<String, double>` | Letter spacing (`tracking-tight`, etc.) |
| `leading` | `Map<String, double>` | Line height (`leading-none`, etc.) |
| `borderWidths` | `Map<String, double>` | Border width scale (`border-2`, etc.) |
| `borderRadius` | `Map<String, double>` | Corner radius scale (`rounded-lg`, etc.) |
| `shadows` | `Map<String, List<BoxShadow>>` | Shadow definitions (`shadow-md`, etc.) |
| `opacities` | `Map<String, double>` | Opacity scale (`opacity-50`, etc.) |
| `zIndices` | `Map<String, int>` | Z-index scale (`z-10`, etc.) |
| `transitionDurations` | `Map<String, Duration>` | Duration scale (`duration-200`, etc.) |
| `transitionCurves` | `Map<String, Curve>` | Easing scale (`ease-in-out`, etc.) |
| `animations` | `Map<String, WindAnimationType>` | Animation types (`animate-spin`, etc.) |
| `aliases` | `Map<String, String>` | Bare-token shorthands that expand (recursively) before parsing. Default `{}`. See [Aliases](#aliases). |

### Ring (Focus) Effects

| Property | Type | Default | Description |
|:---------|:-----|:--------|:------------|
| `ringColor` | `Color` | Tailwind blue-500 | Default ring color when not overridden by `ring-{color}` |
| `ringWidths` | `Map<String, double>` | `0,1,2,DEFAULT=3,4,8` | Ring width scale (`ring`, `ring-2`, etc.) |
| `ringOffsets` | `Map<String, double>` | `0,1,2,4,8` | Ring offset scale (`ring-offset-2`, etc.) |

### Controller methods

`WindTheme.of(context)` returns a `WindThemeController` exposing these mutators:

| Method | Signature | Description |
|:-------|:----------|:------------|
| `toggleTheme()` | `void toggleTheme()` | Flip between light and dark, pinning `syncWithSystem` to `false`. |
| `setTheme()` | `void setTheme(WindThemeData newData)` | Replace the active theme data wholesale. |
| `updateTheme()` | `void updateTheme({Brightness? brightness, Map<String, MaterialColor>? colors, Map<String, int>? screens, Map<String, double>? fontSizes, Map<String, FontWeight>? fontWeights, Map<String, String>? fontFamilies, Map<String, double>? borderWidths, Map<String, double>? borderRadius, double? baseSpacingUnit})` | Partial update via `copyWith`; only the passed fields change. |
| `resetToSystem()` | `void resetToSystem()` | Re-enable automatic OS brightness sync. |

### Equality

`WindThemeData` implements value-based `==` and `hashCode` (the `hashCode` covers scalar fields only), so constructing a fresh default `WindThemeData()` during a parent rebuild does not clobber a `toggleTheme()` choice already held by the controller.

### Widget-level callback

`onThemeChanged` is a `WindTheme` widget parameter, not a `WindThemeData` field. It fires on user-initiated `toggleTheme()` calls and is documented in the [Theme Change Callbacks](#theme-change-callbacks) section above.

For more details on how to sync these values with Flutter's standard Material components, check out the [Theme Binding](./theme-binding.md) guide.
