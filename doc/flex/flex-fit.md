# Flex Fit

Control how a child widget sizes itself within a flex container using `flex-grow` and `flex-auto`.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/flex_fit" size="md" source="example/lib/pages/flex/flex_fit.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WFlexContainer(
  className: 'flex-row bg-gray-100',
  children: [
    WCard(
      className: 'flex-grow bg-blue-500',
      child: WText('Grow'),
    ),
    WCard(
      className: 'flex-auto bg-green-500',
      child: WText('Auto'),
    ),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

`flex-grow` expands the child to fill all remaining space in the flex container (`FlexFit.tight`). `flex-auto` lets the child take only the space it needs (`FlexFit.loose`).

```dart
WFlexContainer(
  className: 'flex-row bg-gray-100',
  children: [
    // Takes all remaining horizontal space
    WCard(
      className: 'flex-grow bg-blue-500',
      child: WText('Fills remaining space'),
    ),
    // Sized to its content
    WCard(
      className: 'flex-auto bg-green-500',
      child: WText('Content width'),
    ),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | FlexFit | Description |
|:------|:--------|:------------|
| `flex-grow` | `FlexFit.tight` | Child expands to fill all available space |
| `flex-auto` | `FlexFit.loose` | Child takes only the space it requires |

<a name="responsive-design"></a>
## Responsive Design

Combine flex-fit classes with breakpoint prefixes to change sizing behavior at different screen sizes.

```dart
WFlexContainer(
  className: 'flex-row bg-gray-100',
  children: [
    WCard(
      className: 'flex-auto md:flex-grow bg-blue-500',
      child: WText('Adapts'),
    ),
    WCard(
      className: 'flex-auto bg-green-500',
      child: WText('Always auto'),
    ),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Flex-x](./flex-x.md) — set a numeric flex factor (`flex-1`, `flex-2`, etc.).
- [Axis Sizes](./axis-sizes.md) — control the container's main-axis size.
- [WFlexible](../widgets/wflexible.md) — the widget that wraps the Flutter `Flexible` primitive.
- [WFlexContainer](../widgets/wflexcontainer.md) — the primary flex layout widget.
