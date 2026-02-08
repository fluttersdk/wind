# WSpacer

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Responsive Spacing](#responsive-spacing)
- [Why WSpacer?](#why-wspacer)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

The `WSpacer` is a lightweight widget designed specifically for adding consistent gaps between elements. Unlike `WDiv`, which supports a full range of decorations and layout properties, `WSpacer` renders as a simple `SizedBox`, making it highly efficient for layouts where you only need spacing.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w_spacer_basic" action="CREATE" -->
<!-- Description: Demonstrates WSpacer providing vertical gap between form fields -->
<x-preview path="widgets/w_spacer_basic" size="md" source="example/lib/pages/widgets/w_spacer_basic.dart"></x-preview>

```dart
WDiv(
  className: 'flex flex-col',
  children: [
    WText('Label', className: 'font-bold'),
    WSpacer(className: 'h-2'), // 8px vertical gap
    WInput(placeholder: 'Enter text...'),
  ],
)
```

<a name="basic-usage"></a>
## Basic Usage

The `WSpacer` widget extracts width and height values from your utility classes and applies them to a `SizedBox`. It supports the standard Wind spacing scale (based on a 4px unit by default).

### Vertical Spacing
Use the `h-{n}` classes to add vertical gaps in columns:

```dart
WSpacer(className: 'h-4') // 16px height
```

### Horizontal Spacing
Use the `w-{n}` classes to add horizontal gaps in rows:

```dart
WSpacer(className: 'w-2') // 8px width
```

<a name="constructor"></a>
## Constructor

```dart
const WSpacer({
  Key? key,
  String? className,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes for sizing (h-*, w-*). |

> [!NOTE]
> Non-sizing classes (like `bg-red-500` or `p-4`) are parsed but ignored by `WSpacer` as it renders a `SizedBox` which does not support decoration or padding.

<a name="responsive-spacing"></a>
## Responsive Spacing

You can adjust spacing based on screen size using responsive prefixes. This is particularly useful for increasing margins on tablet or desktop layouts.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w_spacer_responsive" action="CREATE" -->
<!-- Description: Demonstrates h-4 on mobile and h-8 on desktop -->
<x-preview path="widgets/w_spacer_responsive" size="md" source="example/lib/pages/widgets/w_spacer_responsive.dart"></x-preview>

```dart
WSpacer(className: 'h-4 md:h-8')
```

<a name="why-wspacer"></a>
## Why WSpacer?

While you could use `WDiv` with padding or margin, `WSpacer` is preferred for explicit gaps for several reasons:

1.  **Performance:** It bypasses complex composition and renders as a single `SizedBox`.
2.  **Semantics:** It clearly communicates "this widget exists only for spacing" to other developers.
3.  **Convenience:** It replaces the verbose `SizedBox(height: 16)` with the more maintainable `WSpacer(className: 'h-4')`.

<a name="all-supported-classes"></a>
## All Supported Classes

| Category | Classes | Description |
|:---------|:--------|:------------|
| Sizing | `h-{n}`, `w-{n}` | Standard scale (h-1, h-2, etc.) |
| Arbitrary | `h-[15px]`, `w-[2px]` | Custom pixel values |
| Responsive | `md:h-*`, `lg:w-*` | Breakpoint-specific spacing |

<a name="customizing-theme"></a>
## Customizing Theme

The pixel values for `h-{n}` and `w-{n}` are derived from the `baseSpacingUnit` in your theme.

```dart
WindThemeData(
  baseSpacingUnit: 4.0, // Default: h-1 = 4px
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WDiv](./w-div.md)
- [Sizing Utilities](../layout/sizing.md)
- [Spacing Utilities](../layout/spacing.md)
- [Responsive Design](../core-concepts/responsive-design.md)
