# Flex-x

Assign a numeric flex factor to a child widget using `flex-N`, where `N` is a positive integer. Higher numbers claim proportionally more space.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/flex_x" size="md" source="example/lib/pages/flex/flex_x.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WFlexContainer(
  className: 'flex-row bg-gray-200',
  children: [
    WCard(
      className: 'flex-2 bg-blue-500',
      child: WText('Flex 2'),
    ),
    WCard(
      className: 'flex-1 bg-green-500',
      child: WText('Flex 1'),
    ),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

Use `flex-N` on a child widget to assign it a flex factor. The space is divided proportionally: a child with `flex-2` receives twice the space of a sibling with `flex-1`.

Under the hood, `flex-N` resolves to `FlexFit.tight` with a `flex` value of `N`. This wraps the child in a Flutter `Flexible` widget.

```dart
WFlexContainer(
  className: 'flex-row bg-gray-200',
  children: [
    WCard(className: 'flex-3 bg-blue-500', child: WText('3 parts')),
    WCard(className: 'flex-1 bg-green-500', child: WText('1 part')),
    WCard(className: 'flex-1 bg-red-500', child: WText('1 part')),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Syntax | Flex Factor | FlexFit | Description |
|:-------|:------------|:--------|:------------|
| `flex-1` | `1` | `FlexFit.tight` | Child receives 1 proportional share |
| `flex-2` | `2` | `FlexFit.tight` | Child receives 2 proportional shares |
| `flex-N` | `N` | `FlexFit.tight` | Child receives N proportional shares |

Any positive integer is accepted for `N`.

<a name="responsive-design"></a>
## Responsive Design

Prefix `flex-N` with a breakpoint to change the flex factor at specific screen sizes.

```dart
WFlexContainer(
  className: 'flex-row bg-gray-200',
  children: [
    WCard(
      className: 'flex-1 md:flex-2 bg-blue-500',
      child: WText('Grows on md+'),
    ),
    WCard(
      className: 'flex-1 bg-green-500',
      child: WText('Always 1'),
    ),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Flex Fit](./flex-fit.md) — `flex-grow` / `flex-auto` for non-numeric flex sizing.
- [Axis Sizes](./axis-sizes.md) — control the container's main-axis size.
- [WFlexible](../widgets/wflexible.md) — the widget that wraps Flutter `Flexible`.
- [WFlexContainer](../widgets/wflexcontainer.md) — the primary flex layout widget.
