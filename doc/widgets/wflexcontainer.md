# WFlexContainer

A utility-first widget that combines a styled `WContainer` with a `WFlex` layout, letting you decorate a box and lay out its children in one className.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Supported Utility Classes](#supported-utility-classes)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/wflexcontainer" size="md" source="example/lib/pages/widgets/wflexcontainer.dart"></x-preview>

```dart
WFlexContainer(
  className: 'flex-col items-center justify-center gap-4 bg-gray-200 dark:bg-gray-800',
  children: [
    WContainer(
      className: 'w-16 h-16 bg-blue-500',
      child: WText('Child 1', className: 'text-white'),
    ),
    WContainer(
      className: 'w-16 h-16 bg-green-500',
      child: WText('Child 2', className: 'text-white'),
    ),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

`WFlexContainer` is a `WContainer` wrapping a `WFlex`, so it accepts both container styling utilities (background, border, padding, sizing) and flex layout utilities (direction, justify, align, gap) in the same className. It is the Wind equivalent of an HTML `<div class="flex ...">` that also carries box styling.

```dart
WFlexContainer(
  className: 'flex-col justify-center items-center gap-4 bg-gray-200 dark:bg-gray-800',
  children: [
    WContainer(className: 'w-full h-10 bg-blue-500'),
    WContainer(className: 'w-full h-10 bg-green-500'),
  ],
);
```

<a name="constructor"></a>
## Constructor

```dart
WFlexContainer({
  Key? key,
  required List<Widget> children,
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
  Clip clipBehavior = Clip.none,
  Axis? direction,
  MainAxisAlignment? mainAxisAlignment,
  MainAxisSize? mainAxisSize,
  CrossAxisAlignment? crossAxisAlignment,
  TextDirection? textDirection,
  VerticalDirection verticalDirection = VerticalDirection.down,
  TextBaseline? textBaseline,
});
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:---|:---|:---|:---|
| `className` | `dynamic` | `''` | Wind utility class string applied to both the container and the flex layout. |
| `children` | `List<Widget>` | **Required** | The widgets laid out along the main axis. |
| `alignment` | `AlignmentGeometry?` | `null` | Container alignment; overrides utility-driven alignment. |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding of the container. |
| `color` | `Color?` | `null` | Container background color. |
| `decoration` | `Decoration?` | `null` | Full box decoration for the container. |
| `foregroundDecoration` | `Decoration?` | `null` | Decoration painted in front of the children. |
| `width` | `double?` | `null` | Fixed container width. |
| `height` | `double?` | `null` | Fixed container height. |
| `constraints` | `BoxConstraints?` | `null` | Box constraints for the container. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin of the container. |
| `transform` | `Matrix4?` | `null` | Transformation matrix applied to the container. |
| `transformAlignment` | `AlignmentGeometry?` | `null` | Origin of the `transform`. |
| `clipBehavior` | `Clip` | `Clip.none` | How content is clipped, applied to both container and flex. |
| `direction` | `Axis?` | `null` | Main-axis direction; overrides any `flex-row` / `flex-col` utility. |
| `mainAxisAlignment` | `MainAxisAlignment?` | `null` | Main-axis alignment; overrides any `justify-*` utility. |
| `mainAxisSize` | `MainAxisSize?` | `null` | Main-axis size; overrides any `axis-min` / `axis-max` utility. |
| `crossAxisAlignment` | `CrossAxisAlignment?` | `null` | Cross-axis alignment; overrides any `items-*` utility. |
| `textDirection` | `TextDirection?` | `null` | Text direction used to resolve `start` / `end` alignment. |
| `verticalDirection` | `VerticalDirection` | `VerticalDirection.down` | Order in which children are laid out vertically. |
| `textBaseline` | `TextBaseline?` | `null` | Baseline used when cross-axis alignment is baseline. |

<a name="supported-utility-classes"></a>
## Supported Utility Classes

| Class Type | Example | Documentation |
|:---|:---|:---|
| Responsive Design | `sm:flex-col`, `xs:flex-row` | [Responsive Design](../concepts/responsive-design.md) |
| Flex Direction | `flex-row`, `flex-col` | [Flex Direction](../flex/flex-direction.md) |
| Justify Content | `justify-center`, `justify-between` | [Justify Content](../flex/justify-content.md) |
| Align Items | `items-start`, `items-center` | [Align Items](../flex/align-items.md) |
| Axis Sizes | `axis-max`, `axis-min` | [Axis Sizes](../flex/axis-sizes.md) |
| Gap (Spacing) | `gap-2`, `gap-[4]` | [Gap (Spacing)](../flex/gap.md) |
| Flex-x | `flex-1`, `flex-2` | [Flex-x](../flex/flex-x.md) |
| Flex Fit Classes | `flex-grow`, `flex-auto` | [Flex Fit Classes](../flex/flex-fit.md) |
| Alignment | `alignment-top-left`, `alignment-center-right` | [Alignment](../flex/alignment.md) |
| Padding | `p-4`, `px-[6]`, `py-2` | [Padding](../spacing/padding.md) |
| Margin | `m-8`, `mx-[4]`, `my-2` | [Margin](../spacing/margin.md) |
| Width | `w-10`, `w-[30]` | [Width](../sizing/width.md) |
| Height | `h-10`, `h-[30]` | [Height](../sizing/height.md) |
| Max-Width & Min-Width | `max-w-10`, `min-w-[50]` | [Max-Width & Min-Width](../sizing/max-width-min-width.md) |
| Max-Height & Min-Height | `max-h-10`, `min-h-[50]` | [Max-Height & Min-Height](../sizing/max-height-min-height.md) |
| Background Color | `bg-red-500`, `bg-[#1abc9c]` | [Background Color](../backgrounds/background-color.md) |
| Border Width | `border-4`, `border-[6]` | [Border Width](../borders/border-width.md) |
| Border Color | `border-red-500`, `border-[#1abc9c]` | [Border Color](../borders/border-color.md) |
| Border Radius | `rounded-lg`, `rounded-full` | [Border Radius](../borders/border-radius.md) |
| Overflow | `overflow-scroll` | [Overflow](../layout/overflow.md) |
| Shadow | `shadow-md`, `shadow-lg` | [Shadow](../effects/shadow.md) |
| Display Classes | `hide`, `show`, `sm:hide` | [Display](../layout/display.md) |

<a name="styling-examples"></a>
## Styling Examples

A padded, rounded panel with centered children:

```dart
WFlexContainer(
  className: 'flex-col items-center gap-4 p-4 rounded-lg bg-white shadow-md dark:bg-gray-900',
  children: [
    WText('Title', className: 'text-lg font-bold text-gray-900 dark:text-white'),
    WText('Subtitle', className: 'text-gray-600 dark:text-gray-300'),
  ],
);
```

A horizontal bar:

```dart
WFlexContainer(
  className: 'flex-row justify-between items-center px-4 h-16 bg-gray-100 dark:bg-gray-800',
  children: [
    WText('Brand', className: 'font-bold text-gray-900 dark:text-white'),
    WText('Menu', className: 'text-gray-600 dark:text-gray-300'),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation
- [WFlex](wflex.md) — flex layout without container styling.
- [WContainer](wcontainer.md) — styled box without flex layout.
- [WFlexible](wflexible.md) — flexible child sizing within the layout.
- [Justify Content](../flex/justify-content.md) — main-axis alignment utilities.
