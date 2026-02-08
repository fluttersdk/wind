# WDiv

The fundamental building block of Wind. `WDiv` acts as a multi-purpose container that replaces standard Flutter widgets like `Container`, `Row`, `Column`, `Flex`, `Grid`, `Wrap`, and `SingleChildScrollView`.

It embodies the "Intelligent Composition" philosophy, dynamically constructing the most efficient widget tree based on the provided utility classes. Instead of blindly wrapping content, `WDiv` inspects the `className` and selectively applies specialized widgets like `Padding`, `Align`, `Row`, or `GridView` only when necessary.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w_div_basic" action="CREATE" -->
<!-- Description: Basic demonstration of WDiv as a styled container with flex layout -->
<x-preview path="widgets/w_div_basic" size="md" source="example/lib/pages/widgets/w_div_basic.dart"></x-preview>

```dart
WDiv(
  className: 'flex flex-col gap-4 p-6 bg-white rounded-xl shadow-lg',
  children: [
    WText('Hello Wind', className: 'text-2xl font-bold'),
    WText('This is a styled container.', className: 'text-gray-600'),
  ],
)
```

<a name="basic-usage"></a>
## Basic Usage

Use `WDiv` with a single `child` for simple wrapping or with `children` when using layout modes like `flex` or `grid`.

```dart
// Simple container
WDiv(
  className: 'p-4 bg-blue-500 rounded',
  child: WText('Single Child', className: 'text-white'),
)

// Flex row
WDiv(
  className: 'flex flex-row gap-2',
  children: [
    WDiv(className: 'w-10 h-10 bg-red-500'),
    WDiv(className: 'w-10 h-10 bg-green-500'),
  ],
)
```

<a name="constructor"></a>
## Constructor

```dart
const WDiv({
  Key? key,
  String? className,
  Widget? child,
  List<Widget>? children,
  WindStyle? style,
  Set<String>? states,
  bool scrollPrimary = false,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Utility class string defining layout and styles. |
| `child` | `Widget?` | `null` | Single child widget. Mutually exclusive with `children`. |
| `children` | `List<Widget>?` | `null` | List of children widgets. Mutually exclusive with `child`. |
| `style` | `WindStyle?` | `null` | Explicit style object that serves as a base for `className`. |
| `states` | `Set<String>?` | `null` | Custom states to activate prefix classes (e.g., `loading:bg-blue-500`). |
| `scrollPrimary` | `bool` | `false` | Whether this is the primary scroll view for iOS tap-to-top and desktop scrollbar integration. |

<a name="layout-modes"></a>
## Layout Modes

`WDiv` dynamically switches its internal structure based on the `display` utility classes provided in `className`.

- **Block (Default)**: Standard vertical stack or single child wrapper. If `children` is used without `flex` or `grid`, it defaults to a `Column`.
- **Flex**: Enabled via `flex`. Supports `flex-row`, `flex-col`, `gap-*`, `items-*`, `justify-*`. It mimics CSS Flexbox behavior, including automatic `Flexible` wrapping for children in rows.
- **Grid**: Enabled via `grid`. Uses a combination of `Wrap` and `LayoutBuilder` to achieve Tailwind-like grid behavior (`grid-cols-*`) with intrinsic item heights.
- **Wrap**: Enabled via `wrap`. Elements wrap to the next line when space is insufficient, similar to `flex-wrap` in CSS.
- **Hidden**: Enabled via `hidden`. The widget short-circuits to `SizedBox.shrink()` to save resources.

<a name="event-handling"></a>
## Event Handling

`WDiv` automatically becomes interactive when state-based prefixes like `hover:`, `focus:`, or `active:` are used in the `className`. Under the hood, it wraps the content in a `WAnchor` to detect gestures and focus.

For direct gesture support (taps, long presses) or to create semantic buttons, use [WAnchor](/docs/widgets/w-anchor) or [WButton](/docs/widgets/w-button).

<a name="state-variants"></a>
## State Variants

`WDiv` supports all Wind state prefixes, allowing you to change styles based on interaction or environment.

```dart
WDiv(
  className: 'bg-blue-500 hover:bg-blue-600 active:scale-95 duration-200',
  child: WText('Interactive', className: 'text-white'),
)
```

Common prefixes:
- `hover:` - Applies when the mouse pointer is over the element.
- `focus:` - Applies when the element has keyboard focus.
- `disabled:` - Applies when the element or parent is disabled.
- `dark:` - Applies when the application is in dark mode.
- `active:` - Applies while the element is being pressed.

<a name="styling-examples"></a>
## Styling Examples

### Backgrounds & Borders
Combine background colors, gradients, and border properties.

```dart
WDiv(className: 'bg-red-500 border-2 border-red-700 rounded-lg')
```

### Shadows & Rings
Apply depth with shadows or focus indicators with rings.

```dart
WDiv(className: 'shadow-xl ring-2 ring-blue-500 ring-offset-2')
```

### Responsive Design
`WDiv` uses mobile-first breakpoints to adapt layouts to different screen sizes.

```dart
// Stacked on mobile, side-by-side on tablet/desktop
WDiv(className: 'flex flex-col md:flex-row gap-4')

// Variable widths
WDiv(className: 'w-full md:w-1/2 lg:w-1/3')
```

<a name="all-supported-classes"></a>
## All Supported Classes

| Category | Classes |
|:---------|:--------|
| **Display** | `block`, `flex`, `grid`, `wrap`, `hidden` |
| **Flexbox** | `flex-row`, `flex-col`, `justify-*`, `items-*`, `gap-*`, `flex-1`, `flex-2`, etc. |
| **Grid** | `grid-cols-*`, `gap-x-*`, `gap-y-*` |
| **Sizing** | `w-*`, `h-*`, `min-w-*`, `max-w-*`, `aspect-*` |
| **Spacing** | `p-*`, `px-*`, `py-*`, `m-*`, `mx-*`, `my-*`, `space-x-*`, `space-y-*` |
| **Background** | `bg-*`, `bg-gradient-*`, `bg-opacity-*` |
| **Borders** | `border-*`, `rounded-*`, `border-opacity-*` |
| **Effects** | `shadow-*`, `opacity-*`, `ring-*`, `ring-offset-*` |
| **Overflow** | `overflow-hidden`, `overflow-scroll`, `overflow-auto`, `overflow-x-*`, `overflow-y-*` |
| **Animation** | `animate-spin`, `animate-pulse`, `animate-bounce`, `animate-ping` |
| **Transitions** | `transition-*`, `duration-*`, `ease-*` |

<a name="customizing-theme"></a>
## Customizing Theme

`WDiv` respects the configuration defined in `WindThemeData`.

```dart
WindTheme(
  data: WindThemeData(
    baseSpacingUnit: 4.0, // Multiplier for p-1, m-4, etc.
    colors: { ... },      // Custom color palette for bg-*, border-*
    breakpoints: { ... }, // Custom screen sizes for md:, lg:, etc.
  ),
  child: ...,
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Flexbox](../layout/flexbox.md) & [Grid](../layout/grid.md)
- [Sizing Utilities](../layout/sizing.md)
- [Spacing & Margins](../layout/spacing.md)
- [Interaction State Prefixes](../core-concepts/state-management.md)
- [WAnchor Widget](./w-anchor.md)
- [WSpacer Widget](./w-spacer.md)
