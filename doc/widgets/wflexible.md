# WFlexible

A utility-first wrapper for Flutter's `Flexible` that controls flex factor and fit through className utilities; renders a `Spacer` when no child is given.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Supported Utility Classes](#supported-utility-classes)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/wflexible" size="md" source="example/lib/pages/widgets/wflexible.dart"></x-preview>

```dart
WFlexible(
  className: 'flex-1 flex-grow',
  child: WText('Flexible Child', className: 'text-blue-500 text-center'),
);
```

<a name="basic-usage"></a>
## Basic Usage

`WFlexible` corresponds to the CSS `flex` property: place it inside a [WFlex](wflex.md) and use `flex-x` to set its flex factor and `flex-grow` / `flex-auto` / `flex-none` to set its fit. If `child` is omitted, `WFlexible` renders a `Spacer` with the resolved `flex` value, which is handy for flexible gaps and layout fillers. Visibility utilities such as `hide`, `show`, and `sm:hide` conditionally render the widget based on screen size.

```dart
WFlexible(
  className: 'flex-1',
  child: WText('Flexible Item'),
);
```

<a name="constructor"></a>
## Constructor

```dart
WFlexible({
  Key? key,
  dynamic className,
  int? flex,
  FlexFit? fit,
  Widget? child,
});
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:---|:---|:---|:---|
| `className` | `dynamic` | `null` | Wind utility class string controlling flex factor and fit. |
| `flex` | `int?` | `null` | Flex factor; overrides any `flex-x` utility. Falls back to `1` when neither is set. |
| `fit` | `FlexFit?` | `null` | How the child fills available space; overrides any `flex-grow` / `flex-auto` / `flex-none` utility. Defaults to `FlexFit.loose` when unset. |
| `child` | `Widget?` | `null` | The widget to make flexible. When omitted, a `Spacer` is rendered instead. |

<a name="supported-utility-classes"></a>
## Supported Utility Classes

| Class Type | Example | Documentation |
|:---|:---|:---|
| Responsive Design | `sm:`, `xs:`, `md:` | [Responsive Design](../concepts/responsive-design.md) |
| Flex-x | `flex-1`, `flex-2` | [Flex-x](../flex/flex-x.md) |
| Flex Fit Classes | `flex-grow`, `flex-auto` | [Flex Fit Classes](../flex/flex-fit.md) |
| Display Classes | `hide`, `show`, `sm:hide` | [Display](../layout/display.md) |

<a name="styling-examples"></a>
## Styling Examples

A flexible item that grows to fill its row:

```dart
WFlex(
  className: 'flex-row gap-2',
  children: [
    WContainer(className: 'w-16 bg-gray-300'),
    WFlexible(
      className: 'flex-1 flex-grow',
      child: WContainer(className: 'bg-blue-500 h-10'),
    ),
  ],
);
```

A spacer pushing items apart (no child):

```dart
WFlex(
  className: 'flex-row',
  children: [
    WText('Left', className: 'text-gray-700 dark:text-gray-200'),
    WFlexible(className: 'flex-1'),
    WText('Right', className: 'text-gray-700 dark:text-gray-200'),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation
- [WFlex](wflex.md) — the flex layout WFlexible lives inside.
- [WFlexContainer](wflexcontainer.md) — styled container with flex layout.
- [Flex-x](../flex/flex-x.md) — flex factor utilities.
- [Flex Fit Classes](../flex/flex-fit.md) — flex fit utilities.
