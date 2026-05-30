# WContainer

A utility-first container widget that wraps Flutter's `Container`, styled directly with Wind className utilities.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Supported Utility Classes](#supported-utility-classes)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/wcontainer" size="md" source="example/lib/pages/widgets/wcontainer.dart"></x-preview>

```dart
WContainer(
  className: 'bg-gray-200 p-4 rounded-lg dark:bg-gray-800',
  child: WText('This is a container', className: 'text-lg text-gray-700 dark:text-gray-200'),
);
```

<a name="basic-usage"></a>
## Basic Usage

`WContainer` is the Wind equivalent of an HTML `<div>`: a single-child box you style with utility classes. It wraps a single `child`; it does not lay out multiple children. For multi-child flex layouts reach for [WFlex](wflex.md) or [WFlexContainer](wflexcontainer.md).

```dart
WContainer(
  className: 'bg-blue-500 p-4 rounded-lg shadow-md dark:bg-blue-700',
  child: WText('This is a container', className: 'text-white text-lg'),
);
```

<a name="constructor"></a>
## Constructor

```dart
WContainer({
  Key? key,
  dynamic className = '',
  AlignmentGeometry? alignment,
  EdgeInsetsGeometry? padding,
  Color? color,
  Decoration? decoration,
  Decoration? foregroundDecoration,
  double? width,
  double? height,
  BoxConstraints? constraints,
  EdgeInsetsGeometry? margin,
  Matrix4? transform,
  AlignmentGeometry? transformAlignment,
  Widget? child,
  Clip clipBehavior = Clip.none,
});
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:---|:---|:---|:---|
| `className` | `dynamic` | `''` | Wind utility class string applied to the container. |
| `child` | `Widget?` | `null` | The single widget wrapped by the container. |
| `alignment` | `AlignmentGeometry?` | `null` | Aligns the child within the container; overrides any `alignment-*` utility. |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding; overrides any `p-*` utility. |
| `color` | `Color?` | `null` | Background color; overrides any `bg-*` utility. |
| `decoration` | `Decoration?` | `null` | Full box decoration; when set, overrides the utility-driven background, border, and shadow. |
| `foregroundDecoration` | `Decoration?` | `null` | Decoration painted in front of the child. |
| `width` | `double?` | `null` | Fixed width; overrides any `w-*` utility. |
| `height` | `double?` | `null` | Fixed height; overrides any `h-*` utility. |
| `constraints` | `BoxConstraints?` | `null` | Box constraints; overrides utility-driven min/max sizing. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin; overrides any `m-*` utility. |
| `transform` | `Matrix4?` | `null` | Transformation matrix applied before painting. |
| `transformAlignment` | `AlignmentGeometry?` | `null` | Origin of the `transform` relative to the container's size. |
| `clipBehavior` | `Clip` | `Clip.none` | How content is clipped to the container bounds. |

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

A bordered, rounded card-like box:

```dart
WContainer(
  className: 'bg-white border-2 border-gray-200 rounded-lg p-4 dark:bg-gray-900 dark:border-gray-700',
  child: WText('Bordered box', className: 'text-gray-800 dark:text-gray-100'),
);
```

A fixed-size, centered tile:

```dart
WContainer(
  className: 'w-[120] h-[120] bg-blue-500 alignment-center rounded-lg',
  child: WText('Centered', className: 'text-white'),
);
```

<a name="related-documentation"></a>
## Related Documentation
- [WCard](wcard.md) — card variant with elevation and shadow color.
- [WFlex](wflex.md) — multi-child flex layout.
- [WFlexContainer](wflexcontainer.md) — container and flex combined.
- [WText](wtext.md) — utility-styled text for container children.
