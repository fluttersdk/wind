# Utility-First

Utility-first is a design methodology built on small, single-purpose classes that compose into complex designs. Wind brings this approach to Flutter: instead of writing custom styles for every component, you build interfaces directly from utility classes in a `className`.

- [Basic Usage](#basic-usage)
- [The Flutter Way](#the-flutter-way)
- [The Wind Way](#the-wind-way)
- [Why Utility-First](#why-utility-first)
- [Best Practices](#best-practices)
- [Related Documentation](#related-documentation)

<x-preview path="core/utility_first_wind" size="lg" source="example/lib/pages/core/utility_first_wind.dart"></x-preview>

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class UtilityFirstWind extends StatelessWidget {
  const UtilityFirstWind({super.key});

  @override
  Widget build(BuildContext context) {
    return WCard(
      className: 'shadow-lg rounded-lg m-4 p-4 bg-black',
      child: WFlex(
        className: 'flex-col axis-min gap-2 items-start',
        children: [
          WText('12', className: 'text-4xl leading-6 font-bold text-white'),
          WText('Active users on the website', className: 'text-white leading-4'),
          WText(
            'Composed entirely from utility classes.',
            className: 'text-gray-300 text-xs',
          ),
        ],
      ),
    );
  }
}
```

<a name="basic-usage"></a>
## Basic Usage

Every visual decision is expressed as a utility class in `className`. Spacing, color, typography, and radius all live in one place, so you read the styling without jumping between widget constructors:

```dart
WCard(
  className: 'shadow-lg rounded-lg p-4 bg-black',
  child: WText('Styled in one line.', className: 'text-white text-lg font-bold'),
);
```

<a name="the-flutter-way"></a>
## The Flutter Way

Plain Flutter spreads styling across nested constructors and `TextStyle` objects. The same card requires explicit `Card`, `Padding`, `Column`, and per-`Text` styles:

<x-preview path="core/utility_first_flutter" size="md" source="example/lib/pages/core/utility_first_flutter.dart"></x-preview>

```dart
import 'package:flutter/material.dart';

class UtilityFirstFlutter extends StatelessWidget {
  const UtilityFirstFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '12',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Active users on the website',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
```

<a name="the-wind-way"></a>
## The Wind Way

Wind collapses that structure into utility classes on Wind widgets. The intent reads in a single glance and stays consistent because the same tokens map to the same theme values everywhere:

```dart
WCard(
  className: 'shadow-lg rounded-lg m-4 p-4 bg-black',
  child: WFlex(
    className: 'flex-col axis-min gap-2 items-start',
    children: [
      WText('12', className: 'text-4xl leading-6 font-bold text-white'),
      WText('Active users on the website', className: 'text-white leading-4'),
    ],
  ),
);
```

<a name="why-utility-first"></a>
## Why Utility-First

- **Consistency.** Tokens resolve to theme values (`bg-black`, `text-4xl`, `rounded-lg`), so every screen pulls from the same scale instead of one-off magic numbers.
- **Speed.** You style in place without defining a custom widget or `TextStyle` for each variation.
- **Readability.** The full visual definition lives on one line next to the structure it styles.
- **Adaptivity.** The same tokens compose with `dark:`, breakpoint, and state prefixes, so one class string covers multiple contexts.

<a name="best-practices"></a>
## Best Practices

- Reach for utility classes first; extract a custom widget only when a composition repeats across the app.
- Group related tokens in a readable order (layout, spacing, color, typography) inside the `className`.
- Lean on theme tokens (`bg-gray-200`, `text-lg`) over arbitrary values so dark-mode inversion and theming stay coherent.
- Pair color tokens with their `dark:` counterparts where a value should not rely on automatic inversion.

<a name="related-documentation"></a>
## Related Documentation
- [Dark Mode](dark-mode.md) — how utility colors invert automatically.
- [Responsive Design](responsive-design.md) — composing utilities with breakpoint prefixes.
- [State-Based Styling](state-based-styling.md) — utilities that react to widget state.
- [WCard](../widgets/wcard.md) — the card widget used in these examples.
