# Dark Mode

Wind makes it incredibly easy to support dark mode using the `dark:` variant modifier. Instead of managing complex theme objects or multiple style sheets, you simply prefix your utility classes to apply styles only when dark mode is active.

- [Basic Usage](#basic-usage)
- [System vs Manual Mode](#system-vs-manual-mode)
- [Responsive Dark Mode](#responsive-dark-mode)
- [Best Practices](#best-practices)

<a name="basic-usage"></a>
<!-- TODO: [EXAMPLE_NEEDED] path="core_concepts/dark_mode_basic" action="CREATE" -->
<!-- Description: Show a card that adapts to light/dark mode with background, text, and border changes. -->
<x-preview path="core_concepts/dark_mode_basic" size="md" source="example/lib/pages/core_concepts/dark_mode_basic.dart"></x-preview>

```dart
WDiv(
  className: "p-6 bg-white dark:bg-slate-900 rounded-xl shadow-lg dark:shadow-none border border-gray-200 dark:border-slate-800",
  child: WText(
    "Dark Mode Support",
    className: "text-gray-900 dark:text-white font-bold",
  ),
)
```

## Basic Usage

To style an element for dark mode, add the `dark:` prefix to any utility class. This works for colors, borders, shadows, and even opacity.

Let's look at a practical example:

```dart
WDiv(
  className: "bg-gray-100 text-gray-900 dark:bg-gray-800 dark:text-gray-100",
  child: WText("Adaptive text colors"),
)
```

In this example, the background will be light gray in light mode and shift to a dark gray when dark mode is enabled. The text color behaves similarly, maintaining readability across themes.

<a name="system-vs-manual-mode"></a>
## System vs Manual Mode

By default, Wind follows the system's brightness settings via `MediaQuery.platformBrightness`. However, you can manually override this behavior to allow users to toggle themes within your app.

### Manual Toggling

You can use the `WindTheme` controller to toggle the theme or set a specific brightness programmatically:

```dart
// Toggle between light and dark
context.windTheme.toggleTheme();

// Force dark mode
context.windTheme.setTheme(
  context.windThemeData.copyWith(brightness: Brightness.dark),
);
```

### Material Sync

If you want your Material `ThemeData` to stay in sync with Wind's dark mode, use the `toThemeData()` helper in your `MaterialApp`. This is particularly useful for styling native Material components that aren't yet wrapped in Wind widgets.

```dart
WindTheme(
  data: WindThemeData(),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(),
    home: const HomePage(),
  ),
)
```

<a name="responsive-dark-mode"></a>
## Responsive Dark Mode

You can combine the `dark:` modifier with responsive breakpoints to create highly specific layouts. The order of modifiers doesn't strictly matter, but following a consistent pattern like `{breakpoint}:{state}:{utility}` is recommended for readability.

```dart
WDiv(
  // Blue background on mobile, but red on large screens ONLY in dark mode
  className: "bg-blue-500 lg:dark:bg-red-500",
)
```

<a name="best-practices"></a>
## Best Practices

### Avoid Pure Black

Using pure black (`#000000`) for backgrounds can often lead to high contrast that causes eye strain. We recommend using deep grays or slates like `slate-900` or `gray-900` for a more polished dark mode experience.

```dart
// Recommended
className: "dark:bg-slate-900"

// Use sparingly
className: "dark:bg-black"
```

### Soften Your Borders

Borders that look great in light mode might appear too harsh in dark mode. Consider reducing the opacity or choosing a darker shade for borders to keep the design soft.

```dart
WDiv(className: "border border-gray-200 dark:border-gray-700")
```

That's all.
