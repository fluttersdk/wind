# Dark Mode

Switch your entire app between light and dark themes with a single call. Wind automatically inverts every color in your palette, so widgets styled with `bg-gray-200` or `text-black` adapt to dark mode without rewriting their class names.

- [Basic Usage](#basic-usage)
- [How It Works](#how-it-works)
- [The `dark:` Prefix](#the-dark-prefix)
- [Keeping Colors Static](#keeping-colors-static)
- [Best Practices](#best-practices)
- [Related Documentation](#related-documentation)

<x-preview path="core/dark_mode" size="lg" source="example/lib/pages/core/dark_mode.dart"></x-preview>

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DarkMode extends StatefulWidget {
  const DarkMode({super.key});

  @override
  State<DarkMode> createState() => _DarkModeState();
}

class _DarkModeState extends State<DarkMode> {
  void enableDarkMode() {
    setState(() {
      WindTheme.setType(Brightness.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WCard(
      className: 'shadow-lg rounded-lg p-4 bg-white',
      child: WFlex(
        className: 'flex-col axis-min gap-2 items-start',
        children: [
          WText('12', className: 'text-4xl leading-6 font-bold text-black'),
          WText('Active users on the website', className: 'text-black leading-4'),
        ],
      ),
    );
  }
}
```

<a name="basic-usage"></a>
## Basic Usage

Dark mode is driven entirely by `WindTheme`. Call `WindTheme.setType(Brightness.dark)` to switch the active brightness, then rebuild the widget tree so the new colors take effect:

```dart
setState(() {
  WindTheme.setType(Brightness.dark);
});
```

To follow the platform brightness instead of toggling manually, derive it from the current `BuildContext`:

```dart
WindTheme.setTypeFromContext(context);
```

You never list a separate dark palette. The colors you already use (`bg-white`, `text-black`, `bg-gray-200`) are inverted automatically the moment the brightness changes.

<a name="how-it-works"></a>
## How It Works

When you call `setType`, Wind runs `WindTheme.generateDarkenColors()` under the hood. For every registered color it swaps the shade scale end-for-end, so the lightest shade becomes the darkest and vice versa:

| Light value | Inverted dark value |
|:--|:--|
| `gray-50` | `gray-900` |
| `gray-200` | `gray-700` |
| `gray-500` | `gray-400` |
| `gray-800` | `gray-100` |
| `white` | a near-black surface |
| `black` | `white` |

The result is that a card styled `bg-white` reads as a dark surface and `text-black` reads as near-white once dark mode is active, with no extra class names. Switching back to `Brightness.light` restores the original palette.

<a name="the-dark-prefix"></a>
## The `dark:` Prefix

When automatic inversion is not enough and you want an explicit dark-mode-only value, prefix any utility with `dark:`. Wind applies the prefixed class only while `WindTheme.getType()` returns `Brightness.dark`:

```dart
WCard(
  className: 'p-4 rounded-lg bg-white dark:bg-gray-800',
  child: WText(
    'Adapts on its own, overridden explicitly when needed.',
    className: 'text-gray-900 dark:text-white',
  ),
);
```

The `dark:` prefix and its `light:` counterpart are resolved by the screens parser, alongside the responsive `sm:`/`md:`/`lg:` breakpoints. See [Responsive Design](responsive-design.md) for the full prefix model.

<a name="keeping-colors-static"></a>
## Keeping Colors Static

Some colors, a brand accent for example, should look identical in both modes. Register them with `WindTheme.addStaticColor` so they are excluded from the inversion pass:

```dart
WindTheme.addStaticColor('primary');
WindTheme.addStaticColor('secondary');
```

A static color keeps the same shade scale regardless of the active brightness. Call `WindTheme.removeStaticColor('primary')` to opt it back into inversion.

<a name="best-practices"></a>
## Best Practices

- Toggle inside `setState` (or your state-management rebuild path) so the tree repaints with the inverted palette.
- Prefer automatic inversion first; reach for the `dark:` prefix only when a specific value should differ from the inverted default.
- Mark brand and accent colors static with `addStaticColor` so they stay recognizable across both modes.
- Use `setTypeFromContext` when you want Wind to follow the system or `MaterialApp` brightness rather than a manual toggle.

<a name="related-documentation"></a>
## Related Documentation
- [Responsive Design](responsive-design.md) — the prefix model `dark:` shares with breakpoints.
- [State-Based Styling](state-based-styling.md) — applying styles for widget states such as `hover` and `disabled`.
- [Colors](../customization/colors.md) — registering palette colors and reading them with `wColor`.
- [Background Color](../backgrounds/background-color.md) — the `bg-*` utilities that benefit from inversion.
