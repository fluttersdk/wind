# Responsive Design

Adapt layouts across screen sizes with breakpoint prefixes. Inspired by TailwindCSS, Wind lets you write responsive styles such as `sm:w-full` or `lg:w-100` directly in a `className`, applied the moment the screen width crosses the matching breakpoint.

- [Basic Usage](#basic-usage)
- [Default Breakpoints](#default-breakpoints)
- [How It Works](#how-it-works)
- [Managing Breakpoints](#managing-breakpoints)
- [Best Practices](#best-practices)
- [Related Documentation](#related-documentation)

<x-preview path="core/responsive_design" size="lg" source="example/lib/pages/core/responsive_design.dart"></x-preview>

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ResponsiveDesign extends StatelessWidget {
  const ResponsiveDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'w-full h-full justify-center items-center flex-col bg-gray-200',
      children: [
        WCard(
          className: 'sm:w-full lg:w-100 p-4 bg-white rounded-lg items-center justify-center',
          child: WText('Full width on small screens, fixed on large.', className: 'text-black'),
        ),
        WCard(
          className: 'lg:w-full p-4 bg-white rounded-lg items-center justify-center',
          child: WText('Full width on large screens.', className: 'text-black'),
        ),
      ],
    );
  }
}
```

<a name="basic-usage"></a>
## Basic Usage

Prefix any utility with a breakpoint name to apply it from that width upward:

```dart
WCard(
  className: 'sm:w-full md:w-1/2 lg:w-100 p-4 bg-white rounded-lg',
  child: WText('Resizes as the viewport grows.', className: 'text-black'),
);
```

Breakpoints are min-width based: `lg:w-100` takes effect once the available width is at least the `lg` breakpoint and stays in effect at wider sizes.

<a name="default-breakpoints"></a>
## Default Breakpoints

Wind ships with five breakpoints out of the box. The width is the minimum screen width, in logical pixels, at which the prefix activates:

| Prefix | Min width (px) |
|:--|:--|
| `sm` | 640 |
| `md` | 768 |
| `lg` | 1024 |
| `xl` | 1280 |
| `2xl` | 1536 |

Retrieve the full map programmatically:

```dart
final screens = WindTheme.getScreens();
```

<a name="how-it-works"></a>
## How It Works

Wind reads each space-separated token in a `className`. When a token carries a known breakpoint prefix, the screens parser checks the current `MediaQuery` width against `WindTheme.getScreenValue(prefix)`. If the width meets or exceeds that value, the prefix is stripped and the underlying utility is applied; otherwise the token is skipped.

Because the check is min-width based, listing several breakpoints lets the larger one win at wider sizes:

```dart
// w-full below lg, then a fixed 100-unit width from lg upward.
WContainer(className: 'sm:w-full lg:w-100');
```

The same prefix machinery also resolves `dark:`/`light:` and operating-system prefixes (`ios:`, `android:`, `web:`, ...), so a single token can target a breakpoint and a mode together.

<a name="managing-breakpoints"></a>
## Managing Breakpoints

Add, update, or remove custom breakpoints through `WindTheme`. Do this once during setup, before the widgets that depend on them build:

```dart
// Add a custom breakpoint.
WindTheme.addScreen('watch', 300);

// Update an existing breakpoint.
WindTheme.updateScreen('watch', 400);

// Remove a custom breakpoint.
WindTheme.removeScreen('watch');
```

Once registered, a custom prefix behaves exactly like the built-in ones: `watch:w-full` applies from its width upward.

<a name="best-practices"></a>
## Best Practices

- Order tokens from smallest to largest breakpoint so the intent reads top-down (`sm:... md:... lg:...`).
- Remember breakpoints are min-width based: a value with no prefix is the base, and each prefix overrides it from its width upward.
- Register custom breakpoints during app setup, not inside `build`, so the map is stable across rebuilds.
- Combine breakpoint and mode prefixes when needed (`lg:dark:bg-gray-800`) rather than duplicating widgets.

<a name="related-documentation"></a>
## Related Documentation
- [Dark Mode](dark-mode.md) — the `dark:` prefix that shares this resolution model.
- [State-Based Styling](state-based-styling.md) — applying styles for widget states.
- [Width](../sizing/width.md) — the `w-*` utilities most often made responsive.
- [Display](../layout/display.md) — `hide`/`show` utilities with breakpoint prefixes.
