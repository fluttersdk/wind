# WFlex

A utility-first flex layout widget that wraps Flutter's `Flex`, controlling direction, alignment, spacing, and overflow through className utilities.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Supported Utility Classes](#supported-utility-classes)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/wflex" size="md" source="example/lib/pages/widgets/wflex.dart"></x-preview>

```dart
WFlex(
  className: 'flex-col justify-center items-center gap-4',
  children: [
    WContainer(className: 'w-10 h-10 bg-blue-500'),
    WContainer(className: 'w-10 h-10 bg-green-500'),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

`WFlex` is the Wind equivalent of an HTML `<div class="flex">`. It lays out a list of `children` along a main axis, controlling direction, justification, cross-axis alignment, gap spacing, and overflow with utility classes. When a Flutter `Flex` parameter is passed explicitly, it takes precedence over the matching utility class.

```dart
WFlex(
  className: 'flex-row justify-center items-center gap-4',
  children: [
    WText('Child 1', className: 'text-red-500'),
    WText('Child 2', className: 'text-blue-500'),
  ],
);
```

<a name="constructor"></a>
## Constructor

```dart
WFlex({
  Key? key,
  dynamic className = '',
  Axis? direction,
  MainAxisAlignment? mainAxisAlignment,
  MainAxisSize? mainAxisSize,
  CrossAxisAlignment? crossAxisAlignment,
  TextDirection? textDirection,
  VerticalDirection verticalDirection = VerticalDirection.down,
  TextBaseline? textBaseline,
  Clip clipBehavior = Clip.none,
  required List<Widget> children,
});
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:---|:---|:---|:---|
| `className` | `dynamic` | `''` | Wind utility class string applied to the flex layout. |
| `children` | `List<Widget>` | **Required** | The widgets laid out along the main axis. |
| `direction` | `Axis?` | `null` | Main-axis direction; overrides any `flex-row` / `flex-col` utility. |
| `mainAxisAlignment` | `MainAxisAlignment?` | `null` | Main-axis alignment; overrides any `justify-*` utility. |
| `mainAxisSize` | `MainAxisSize?` | `null` | Main-axis size; overrides any `axis-min` / `axis-max` utility. |
| `crossAxisAlignment` | `CrossAxisAlignment?` | `null` | Cross-axis alignment; overrides any `items-*` utility. |
| `textDirection` | `TextDirection?` | `null` | Text direction used to resolve `start` / `end` alignment. |
| `verticalDirection` | `VerticalDirection` | `VerticalDirection.down` | Order in which children are laid out vertically. |
| `textBaseline` | `TextBaseline?` | `null` | Baseline used when cross-axis alignment is baseline. |
| `clipBehavior` | `Clip` | `Clip.none` | How overflowing content is clipped. |

<a name="supported-utility-classes"></a>
## Supported Utility Classes

| Class Type | Example | Documentation |
|:---|:---|:---|
| Responsive Design | `sm:flex-row`, `xs:flex-col` | [Responsive Design](../concepts/responsive-design.md) |
| Flex Direction | `flex-row`, `flex-col` | [Flex Direction](../flex/flex-direction.md) |
| Justify Content | `justify-center`, `justify-start` | [Justify Content](../flex/justify-content.md) |
| Align Items | `items-center`, `items-start` | [Align Items](../flex/align-items.md) |
| Axis Sizes | `axis-max`, `axis-min` | [Axis Sizes](../flex/axis-sizes.md) |
| Gap (Spacing) | `gap-2`, `gap-[4]` | [Gap (Spacing)](../flex/gap.md) |
| Overflow | `overflow-scroll` | [Overflow](../layout/overflow.md) |
| Display Classes | `hide`, `show`, `sm:hide` | [Display](../layout/display.md) |

<a name="styling-examples"></a>
## Styling Examples

A spaced row of items:

```dart
WFlex(
  className: 'flex-row justify-between items-center gap-2',
  children: [
    WText('Left', className: 'text-gray-700 dark:text-gray-200'),
    WText('Right', className: 'text-gray-700 dark:text-gray-200'),
  ],
);
```

A scrollable column:

```dart
WFlex(
  className: 'flex-col gap-4 overflow-scroll',
  children: [
    WContainer(className: 'w-full h-20 bg-blue-500'),
    WContainer(className: 'w-full h-20 bg-green-500'),
    WContainer(className: 'w-full h-20 bg-purple-500'),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation
- [WFlexContainer](wflexcontainer.md) — combines a styled container with flex layout.
- [WFlexible](wflexible.md) — flexible child sizing within a flex layout.
- [WContainer](wcontainer.md) — single-child styled box.
- [Flex Direction](../flex/flex-direction.md) — main-axis direction utilities.
