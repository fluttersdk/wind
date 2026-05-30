# Overflow

Make content scrollable when it exceeds the available space using the `overflow-scroll` utility class.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How It Works](#how-it-works)
- [Responsive Overflow](#responsive-overflow)
- [Related Documentation](#related-documentation)

<x-preview path="flex/scrollable_overflow" size="md" source="example/lib/pages/flex/scrollable_overflow.dart"></x-preview>

```dart
WFlexContainer(
  className: 'overflow-scroll flex-col bg-gray-100 h-64',
  children: List.generate(
    20,
    (index) => WCard(
      className: 'bg-gray-200 w-full h-10',
      child: WText('Item $index', className: 'text-black'),
    ),
  ),
);
```

<a name="basic-usage"></a>
## Basic Usage

Apply `overflow-scroll` to a `WFlexContainer` to wrap its content in a `SingleChildScrollView` when
the content height exceeds the container's available space.

```dart
WFlexContainer(
  className: 'overflow-scroll flex-col bg-white h-48',
  children: [
    WCard(className: 'bg-gray-100 w-full h-12', child: WText('Row 1')),
    WCard(className: 'bg-gray-100 w-full h-12', child: WText('Row 2')),
    WCard(className: 'bg-gray-100 w-full h-12', child: WText('Row 3')),
    WCard(className: 'bg-gray-100 w-full h-12', child: WText('Row 4')),
    WCard(className: 'bg-gray-100 w-full h-12', child: WText('Row 5')),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description |
| :--- | :--- |
| `overflow-scroll` | Wraps content in a `SingleChildScrollView` when overflow occurs |

<a name="how-it-works"></a>
## How It Works

When `overflow-scroll` is present in the `className`, `FlexParser.applyOverflow` wraps the flex
content in a `SingleChildScrollView`. This is applied to `WFlexContainer` only; the scroll direction
follows the flex axis.

<a name="responsive-overflow"></a>
## Responsive Overflow

The `overflow-scroll` token supports responsive breakpoint prefixes, allowing overflow behavior to
activate only at certain screen sizes.

```dart
// Scrollable only on small screens; normal layout on medium and above.
WFlexContainer(
  className: 'sm:overflow-scroll md:flex-row flex-col bg-gray-100',
  children: [...],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Flex Direction](../flex/flex-direction.md) — `flex-col` and `flex-row` layout direction
- [Axis Sizes](../flex/axis-sizes.md) — controlling main-axis size
- [WFlexContainer](../widgets/wflexcontainer.md) — the widget that applies overflow behavior
