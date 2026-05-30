# Alignment

Position a widget within its container using the `alignment-*` utilities. These map directly to Flutter's `Alignment` constants and work on any `WContainer`.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Combining with Flex](#combining-with-flex)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/alignment" size="md" source="example/lib/pages/flex/alignment.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WContainer(
  className: 'alignment-center bg-gray-200 w-full h-full',
  child: WText('Centered', className: 'text-black dark:text-white'),
);
```

<a name="basic-usage"></a>
## Basic Usage

Apply an `alignment-*` class to a `WContainer` to position its child widget within the available space.

```dart
WContainer(
  className: 'alignment-top-left bg-gray-200 w-full h-64',
  child: WText('Top-Left', className: 'text-black dark:text-white'),
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Flutter Alignment | Description |
|:------|:------------------|:------------|
| `alignment-top-left` | `Alignment.topLeft` | Aligns to the top-left corner |
| `alignment-top-center` | `Alignment.topCenter` | Aligns to the top-center |
| `alignment-top-right` | `Alignment.topRight` | Aligns to the top-right corner |
| `alignment-center-left` | `Alignment.centerLeft` | Aligns to the center-left edge |
| `alignment-center` | `Alignment.center` | Centers both horizontally and vertically |
| `alignment-center-right` | `Alignment.centerRight` | Aligns to the center-right edge |
| `alignment-bottom-left` | `Alignment.bottomLeft` | Aligns to the bottom-left corner |
| `alignment-bottom-center` | `Alignment.bottomCenter` | Aligns to the bottom-center |
| `alignment-bottom-right` | `Alignment.bottomRight` | Aligns to the bottom-right corner |
| `alignment-left` | `Alignment.centerLeft` | Alias for `alignment-center-left` |
| `alignment-right` | `Alignment.centerRight` | Alias for `alignment-center-right` |

<a name="combining-with-flex"></a>
## Combining with Flex

You can combine `alignment-*` with other flex and style utilities for complex layouts.

```dart
WFlexContainer(
  className: 'flex-row justify-evenly items-center w-full h-64 bg-gray-100',
  children: [
    WContainer(
      className: 'alignment-top-left bg-blue-500 w-32 h-32',
      child: WText('Top-Left', className: 'text-white'),
    ),
    WContainer(
      className: 'alignment-center bg-green-500 w-32 h-32',
      child: WText('Center', className: 'text-white'),
    ),
    WContainer(
      className: 'alignment-bottom-right bg-red-500 w-32 h-32',
      child: WText('Bottom-Right', className: 'text-white'),
    ),
  ],
);
```

<a name="responsive-design"></a>
## Responsive Design

Prefix `alignment-*` classes with a breakpoint to change alignment at different screen sizes.

```dart
WContainer(
  className: 'alignment-top-left md:alignment-center bg-gray-200 w-full h-64',
  child: WText('Responsive Alignment', className: 'text-black dark:text-white'),
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Align Items](./align-items.md) — control cross-axis alignment inside flex containers.
- [Justify Content](./justify-content.md) — control main-axis alignment inside flex containers.
- [WContainer](../widgets/wcontainer.md) — the container widget that alignment classes are applied to.
- [Flex Direction](./flex-direction.md) — control the direction of flex layout.
