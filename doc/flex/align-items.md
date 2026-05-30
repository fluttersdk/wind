# Align Items

Control how children are positioned along the cross axis of a flex container using the `items-*` utilities.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/align_items" size="md" source="example/lib/pages/flex/align_items.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WFlexContainer(
  className: 'flex-row items-center bg-gray-100 h-64',
  children: [
    WCard(className: 'bg-blue-500 h-16', child: WText('Card 1')),
    WCard(className: 'bg-green-500 h-16', child: WText('Card 2')),
    WCard(className: 'bg-red-500 h-16', child: WText('Card 3')),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

The `items-*` utilities map directly to Flutter's `CrossAxisAlignment` values and are applied to any `WFlexContainer` or `WFlex`.

```dart
WFlexContainer(
  className: 'flex-row items-start bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 h-12', child: WText('Short')),
    WCard(className: 'bg-green-500 h-24', child: WText('Tall')),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | CrossAxisAlignment | Description |
|:------|:-------------------|:------------|
| `items-start` | `CrossAxisAlignment.start` | Align children at the start of the cross axis |
| `items-end` | `CrossAxisAlignment.end` | Align children at the end of the cross axis |
| `items-center` | `CrossAxisAlignment.center` | Center children along the cross axis |
| `items-baseline` | `CrossAxisAlignment.baseline` | Align children to their text baseline |
| `items-stretch` | `CrossAxisAlignment.stretch` | Stretch children to fill the cross axis |

<a name="responsive-design"></a>
## Responsive Design

Prefix any `items-*` class with a breakpoint to change alignment at specific screen sizes.

```dart
WFlexContainer(
  className: 'flex-row items-start md:items-center lg:items-end',
  children: [
    WCard(className: 'bg-blue-500 h-16', child: WText('A')),
    WCard(className: 'bg-green-500 h-24', child: WText('B')),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Flex Direction](./flex-direction.md) — control whether children are laid out in a row or column.
- [Justify Content](./justify-content.md) — control alignment along the main axis.
- [WFlexContainer](../widgets/wflexcontainer.md) — the primary flex layout widget.
- [WFlex](../widgets/wflex.md) — alternative flex container accepting a `className`.
