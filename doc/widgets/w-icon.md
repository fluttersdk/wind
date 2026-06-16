# WIcon

The utility-first icon component for displaying vector icons with Tailwind-like styling. It wraps Flutter's `Icon` widget and applies utility classes for sizing, coloring, and animations while inheriting styles from the surrounding text context.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Runtime-Dynamic Colors](#runtime-dynamic-colors)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="icons/icon_basic" size="md" source="example/lib/pages/icons/icon_basic.dart"></x-preview>

```dart
WIcon(
  Icons.star,
  className: 'text-yellow-400 text-3xl',
)
```

## Basic Usage

The `WIcon` widget allows you to style icons using `className`. By default, it inherits color and font size from the surrounding `DefaultTextStyle` (e.g., from a parent `WDiv` or `WText`), allowing icons to automatically match adjacent text.

```dart
WIcon(
  Icons.favorite,
  className: 'text-red-500 text-xl',
)
```

## Constructor

```dart
const WIcon(
  IconData icon, {
  Key? key,
  String? className,
  Set<String>? states,
  Color? foregroundColor,
  String? semanticLabel,
  TextDirection? textDirection,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `icon` | `IconData` | **Required** | The icon to display. |
| `className` | `String?` | `null` | Wind utility classes for styling. |
| `states` | `Set<String>?` | `null` | Custom states to activate prefix classes. |
| `foregroundColor` | `Color?` | `null` | Inline icon color for runtime-dynamic values. Overrides any `text-*` / `dark:text-*` from `className`. See [Runtime-Dynamic Colors](#runtime-dynamic-colors). |
| `semanticLabel` | `String?` | `null` | Optional semantic label for accessibility. |
| `textDirection` | `TextDirection?` | `null` | Text direction for the icon. |

<a name="runtime-dynamic-colors"></a>
## Runtime-Dynamic Colors

Utility classes are for **design tokens** (`text-primary-500`, `text-red-500`). When the color is a **runtime value**, a category icon color from the database or a user-picked brand color, use the `foregroundColor` prop instead of interpolating into `text-[#$hex]`.

```dart
// `category.color` is a Color loaded at runtime (e.g. from the database).

// Good: runtime-dynamic color via inline prop
WIcon(
  Icons.star,
  foregroundColor: category.color,
  className: 'text-lg',
)

// Avoid: interpolating a runtime value into className bloats the parser
// cache with one entry per unique color (`categoryHex` is a String like 'ff5500')
WIcon(Icons.star, className: 'text-lg text-[#$categoryHex]')
```

Precedence: inline `foregroundColor` wins over any `text-*` / `dark:text-*` resolved from `className`. When `foregroundColor` is `null`, className behavior, including the `dark:` fallback, is unchanged. The inline color does not participate in the parser cache key.

## Layout Modes

While icons don't have complex layout modes, `WIcon` supports two primary sizing methods. Explicit sizing (`w-*` / `h-*`) takes precedence over typography-based sizing (`text-*`).

### Sizing Modes

<x-preview path="widgets/w_icon_sizing" size="md" source="example/lib/pages/widgets/w_icon_sizing.dart"></x-preview>

```dart
// Typography-based sizing (inherits line-height context)
WIcon(Icons.info, className: 'text-lg')

// Explicit dimension sizing (absolute pixels)
WIcon(Icons.info, className: 'w-12 h-12')
```

## Event Handling

`WIcon` is a purely visual component. To handle user interactions, wrap it in a `WAnchor` or `WButton`. You can pass the parent's state to the `states` prop to trigger state-aware styling.

```dart
WAnchor(
  onTap: () => print('Settings tapped'),
  child: WIcon(
    Icons.settings,
    className: 'text-gray-400 hover:text-blue-500 transition-colors',
  ),
)
```

## State Variants

Use state prefixes for dynamic appearance changes. This works seamlessly when the icon is part of an interactive group.

```dart
WIcon(
  Icons.check_circle,
  className: 'text-green-500 dark:text-green-400 hover:scale-110',
)
```

## Styling Examples

### Colors and Opacity

Icons support full color palette integration including opacity modifiers.

```dart
// Red icon with 50% opacity
WIcon(Icons.error, className: 'text-red-500/50')
```

### Animations

Apply built-in animations to icons for loading states or attention-grabbing effects.

```dart
// Spinning refresh icon
WIcon(Icons.refresh, className: 'text-blue-600 animate-spin')

// Pulsing alert icon
WIcon(Icons.notifications, className: 'text-amber-500 animate-pulse')
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Sizing | `text-{size}`, `w-{size}`, `h-{size}` |
| Colors | `text-{color}`, `text-{color}/{opacity}` |
| Opacity | `opacity-{n}` |
| Animation | `animate-spin`, `animate-pulse`, `animate-bounce`, `animate-ping` |
| Transitions | `duration-{ms}`, `ease-{curve}` |

## Customizing Theme

Icons respect the global configuration in `WindThemeData`. Changing the `fontSizes` or `colors` scales will update all icons using those classes.

```dart
WindThemeData(
  fontSizes: {
    'xl': 20.0,
  },
  colors: {
    'brand': Colors.indigo,
  },
)
```

## Related Documentation

- [WText](./w-text.md) - Cascades typography styles to icons
- [WAnchor](./w-anchor.md) - For making icons interactive
- [WSvg](./w-svg.md) - For custom vector illustrations
- [WImage](./w-image.md) - For rasterized images
