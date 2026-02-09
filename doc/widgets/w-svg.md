# WSvg

The utility-first SVG component. `WSvg` brings HTML SVG semantics to Flutter with Tailwind-like utility classes for styling, supporting both asset paths and raw SVG strings.

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

<!-- Description: Demonstrate WSvg with asset source and string source, showing fill/stroke and sizing. -->
<x-preview path="widgets/w_svg" size="md" source="example/lib/pages/widgets/w_svg.dart"></x-preview>

```dart
WSvg(
  src: 'assets/icons/star.svg',
  className: 'fill-yellow-500 w-6 h-6 hover:scale-110 transition-transform',
)
```

## Basic Usage

The `WSvg` widget allows you to render SVG graphics and style them using utility classes. It inherits colors and sizes from parent styles if not explicitly defined.

### From Asset
Use the default constructor for files located in your assets folder.

```dart
WSvg(
  src: 'assets/logo.svg',
  className: 'w-12 h-12 fill-blue-600',
)
```

### From String
Use the `WSvg.string` constructor to render raw SVG content.

```dart
WSvg.string(
  '<svg>...</svg>',
  className: 'stroke-red-500 stroke-2 w-8 h-8',
)
```

## Constructor

```dart
WSvg({
  Key? key,
  required String? src,
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})

WSvg.string(
  String svg, {
  Key? key,
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes for sizing, coloring, and effects. |
| `src` | `String?` | `null` | The asset path to the SVG file. |
| `svgString` | `String?` | `null` | Raw SVG string content (used in `WSvg.string`). |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling prefixes. |
| `semanticsLabel` | `String?` | `null` | Semantic label for accessibility. |

## Layout Modes

`WSvg` behaves as a fixed-size or flexible graphic depending on the classes provided.

### Sizing Priority
The widget determines its size based on the following priority:
1. `w-{n}` or `h-{n}` classes.
2. `text-{size}` classes (font size).
3. Inherited font size from the parent `DefaultTextStyle`.

```dart
WSvg(
  src: 'assets/icon.svg',
  className: 'w-10 h-10', // Explicit size
)
```

## Event Handling

`WSvg` does not handle events directly. To add interactivity, wrap it in a `WAnchor` or `WButton`.

```dart
WAnchor(
  onTap: () => print('SVG clicked'),
  child: WSvg(
    src: 'assets/icon.svg',
    className: 'hover:fill-blue-500 transition-colors',
  ),
)
```

## State Variants

Use state prefixes to change SVG styles based on interactions or environment:

```dart
WSvg(
  src: 'assets/icon.svg',
  className: 'fill-gray-400 hover:fill-blue-500 dark:fill-white',
)
```

## Styling Examples

### Color Priority
The widget applies a color filter using the following priority:
1. `stroke-{color}` (ideal for outlined icons)
2. `fill-{color}`
3. `text-{color}` (fallback)
4. Inherited color from parent

```dart
// Applying a stroke color to an outlined SVG
WSvg(
  src: 'assets/outline-star.svg',
  className: 'stroke-amber-500',
)
```

### Opacity and Transitions
You can apply opacity and animate it using transition classes.

```dart
WSvg(
  src: 'assets/logo.svg',
  className: 'opacity-50 hover:opacity-100 duration-300',
)
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Sizing | `w-{size}`, `h-{size}`, `text-{size}` |
| Coloring | `fill-{color}`, `stroke-{color}`, `text-{color}` |
| Opacity | `opacity-{n}` |
| Transitions| `duration-{ms}`, `ease-{curve}` |
| Animations | `animate-spin`, `animate-pulse`, `animate-bounce` |

## Customizing Theme

You can define custom colors in your `WindThemeData` that will be available to `WSvg`.

```dart
WindThemeData(
  colors: {
    'brand': Colors.blue,
  },
)
```

Then use it as: `className: 'fill-brand-500'`.

## Related Documentation

- [WIcon](./w-icon.md)
- [WImage](./w-image.md)
- [SVG Parser](../parsers/svg_parser.md)
