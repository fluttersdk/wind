# WCard

A utility-first card widget that wraps Flutter's `Card`, adding elevation, shadow, border, and padding through Wind className utilities.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Supported Utility Classes](#supported-utility-classes)
- [Styling Examples](#styling-examples)
- [WCard vs WContainer](#wcard-vs-wcontainer)
- [Related Documentation](#related-documentation)

```dart
WCard(
  className: 'bg-white shadow-lg rounded-lg p-4 dark:bg-gray-800',
  child: WText('Card Content', className: 'text-gray-800 dark:text-gray-100'),
);
```

<a name="basic-usage"></a>
## Basic Usage

`WCard` wraps a single `child` and applies Wind utilities for background color, elevation/shadow, border, border radius, and padding. Use it when you want a card surface; for a plain styled box use [WContainer](wcontainer.md).

```dart
WCard(
  className: 'bg-white shadow-lg rounded-lg p-4 dark:bg-gray-800',
  child: WText('This is a card.', className: 'text-gray-800 dark:text-gray-100'),
);
```

<a name="constructor"></a>
## Constructor

```dart
WCard({
  Key? key,
  dynamic className = '',
  Color? color,
  Color? shadowColor,
  Color? surfaceTintColor,
  double? elevation,
  ShapeBorder? shape,
  bool borderOnForeground = true,
  EdgeInsetsGeometry? margin,
  Clip? clipBehavior,
  Widget? child,
  bool semanticContainer = true,
});
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:---|:---|:---|:---|
| `className` | `dynamic` | `''` | Wind utility class string applied to the card. |
| `color` | `Color?` | `null` | Card background color; overrides any `bg-*` utility. |
| `shadowColor` | `Color?` | `null` | Color of the drop shadow cast below the card. |
| `surfaceTintColor` | `Color?` | `null` | Surface tint overlay color applied at elevation. |
| `elevation` | `double?` | `null` | Card elevation; overrides any `shadow-*` utility. |
| `shape` | `ShapeBorder?` | `null` | Card shape and border; overrides utility-driven border and radius. |
| `borderOnForeground` | `bool` | `true` | Whether the shape border is painted in front of the child. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin; overrides any `m-*` utility. |
| `clipBehavior` | `Clip?` | `null` | How the card content is clipped. |
| `child` | `Widget?` | `null` | The single widget wrapped by the card. |
| `semanticContainer` | `bool` | `true` | Whether the card is treated as a single semantic boundary. |

<a name="supported-utility-classes"></a>
## Supported Utility Classes

| Class Type | Example | Documentation |
|:---|:---|:---|
| Responsive Design | `sm:p-4`, `xs:mt-2` | [Responsive Design](../concepts/responsive-design.md) |
| Flex-x | `flex-1`, `flex-3` | [Flex-x](../flex/flex-x.md) |
| Flex Fit Classes | `flex-grow`, `flex-auto` | [Flex Fit Classes](../flex/flex-fit.md) |
| Alignment | `alignment-top-left` | [Alignment](../flex/alignment.md) |
| Padding | `p-4`, `p-[11]` | [Padding](../spacing/padding.md) |
| Margin | `m-8`, `m-[4]` | [Margin](../spacing/margin.md) |
| Width | `w-10`, `w-[30]` | [Width](../sizing/width.md) |
| Height | `h-10`, `h-[30]` | [Height](../sizing/height.md) |
| Max-Width & Min-Width | `max-w-10`, `min-w-10` | [Max-Width & Min-Width](../sizing/max-width-min-width.md) |
| Max-Height & Min-Height | `max-h-10`, `min-h-10` | [Max-Height & Min-Height](../sizing/max-height-min-height.md) |
| Background Color | `bg-red-500`, `bg-green` | [Background Color](../backgrounds/background-color.md) |
| Border Width | `border-4`, `border-[6]` | [Border Width](../borders/border-width.md) |
| Border Color | `border-red-500`, `border-[#1abc9c]` | [Border Color](../borders/border-color.md) |
| Border Radius | `rounded-lg`, `rounded-full` | [Border Radius](../borders/border-radius.md) |
| Shadow | `shadow-sm`, `shadow-lg` | [Shadow](../effects/shadow.md) |
| Display Classes | `hide`, `show`, `sm:hide` | [Display](../layout/display.md) |

<a name="styling-examples"></a>
## Styling Examples

An elevated, padded card:

```dart
WCard(
  className: 'bg-white shadow-lg rounded-lg p-4 dark:bg-gray-800',
  child: WText('Elevated card', className: 'text-gray-800 dark:text-gray-100'),
);
```

A bordered, flat card:

```dart
WCard(
  className: 'bg-white border-2 border-gray-200 rounded-lg p-4 dark:bg-gray-900 dark:border-gray-700',
  child: WText('Flat bordered card', className: 'text-gray-700 dark:text-gray-200'),
);
```

<a name="wcard-vs-wcontainer"></a>
## WCard vs WContainer

`WCard` is purpose-built for cards: it exposes `elevation`, `shadowColor`, and `surfaceTintColor`, which `WContainer` does not. `WContainer` is a general-purpose styled box. Reach for `WContainer` when you need a plain styled container, and `WCard` when you need a card surface with elevation and shadow.

<a name="related-documentation"></a>
## Related Documentation
- [WContainer](wcontainer.md) — general-purpose styled box.
- [WText](wtext.md) — utility-styled text for card children.
- [Shadow](../effects/shadow.md) — shadow utilities used for elevation.
- [Border Radius](../borders/border-radius.md) — corner rounding utilities.
