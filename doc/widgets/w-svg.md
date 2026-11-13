# WSvg

The utility-first SVG component. `WSvg` brings HTML SVG semantics to Flutter with Tailwind-like utility classes for styling, supporting both asset paths and raw SVG strings.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [Preserving Original Colors](#preserving-original-colors)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<!-- Description: Demonstrate WSvg with asset source and string source, showing fill/stroke and sizing. -->
<x-preview path="widgets/w_svg" size="md" source="example/lib/pages/widgets/w_svg.dart"></x-preview>

```dart
WAnchor(
  onTap: () {},
  child: WSvg(
    src: 'assets/icons/star.svg',
    className: 'fill-yellow-500 dark:fill-yellow-400 hover:fill-yellow-600 dark:hover:fill-yellow-300 w-6 h-6',
  ),
)
```

<a name="basic-usage"></a>
## Basic Usage

The `WSvg` widget allows you to render SVG graphics and style them using utility classes. It inherits colours and sizes from parent styles if not explicitly defined.

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
  className: 'stroke-red-500 w-8 h-8',
)
```

<a name="constructor"></a>
## Constructor

```dart
const WSvg({
  Key? key,
  required String? src,
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})

const WSvg.string(
  String svg, {
  Key? key,
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes for sizing, colouring, and effects. |
| `src` | `String?` | **Required** | The asset path to the SVG file (default constructor). |
| `svg` | `String` | **Required** | Raw SVG string content, passed positionally to `WSvg.string`. |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling prefixes. |
| `semanticsLabel` | `String?` | `null` | Semantic label for accessibility. |

<a name="layout-modes"></a>
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

<a name="event-handling"></a>
## Event Handling

`WSvg` does not handle events directly. To add interactivity, wrap it in a `WAnchor` or `WButton`.

```dart
WAnchor(
  onTap: () => print('SVG clicked'),
  child: WSvg(
    src: 'assets/icon.svg',
    className: 'hover:fill-blue-500 dark:hover:fill-blue-400 transition-colors',
  ),
)
```

<a name="state-variants"></a>
## State Variants

The interaction prefixes (`hover:`, `focus:`, `disabled:`) need an ancestor that publishes state (`WAnchor`, `WButton`, `WPopover`); `WSvg` has none of its own. Custom prefixes driven by the `states` prop and `dark:` do not need one.

```dart
WAnchor(
  onTap: () {},
  child: WSvg(
    src: 'assets/icon.svg',
    className: 'fill-gray-400 hover:fill-blue-500 dark:fill-white dark:hover:fill-blue-400',
  ),
)
```

<a name="styling-examples"></a>
## Styling Examples

### Color Priority
The widget applies a colour filter using the following priority:
1. `stroke-{color}` (ideal for outlined icons)
2. `fill-{color}`
3. `text-{color}` (fallback)
4. Inherited colour from parent

```dart
// Applying a stroke color to an outlined SVG
WSvg(
  src: 'assets/outline-star.svg',
  className: 'stroke-amber-500',
)
```

> [!NOTE]
> Adding the `preserve-colors` class bypasses the entire colour priority chain. No `ColorFilter` is applied, and the SVG renders with its original embedded colours.

### Opacity and Transitions
You can apply opacity and animate it using transition classes.

```dart
WAnchor(
  onTap: () {},
  child: WSvg(
    src: 'assets/logo.svg',
    className: 'opacity-50 hover:opacity-100 duration-300',
  ),
)
```

### Preserving Original Colors

By default, `WSvg` applies a `ColorFilter` based on the colour priority chain above. For SVGs that contain multiple colours you want to keep intact (like QR codes, branded logos, or multi-colour illustrations), use the `preserve-colors` utility class.

```dart
// Multi-color logo: keep original colors
WSvg(
  src: 'assets/logo-colored.svg',
  className: 'w-32 h-32 preserve-colors',
)

// QR code: must not be tinted
WSvg(
  src: 'assets/qr-code.svg',
  className: 'w-48 h-48 preserve-colors',
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Sizing | `w-{size}`, `h-{size}`, `text-{size}` |
| Colouring | `fill-{color}`, `stroke-{color}`, `text-{color}` |
| Preserve | `preserve-colors` |
| Opacity | `opacity-{n}` |
| Transitions| `duration-{ms}`, `ease-{curve}` |

`WSvg` does not apply `animate-*` classes. To animate an SVG, wrap it in a `WindAnimationWrapper`.

<a name="customizing-theme"></a>
## Customizing Theme

You can define custom colours in your `WindThemeData` that will be available to `WSvg`.

```dart
WindThemeData(
  colors: {
    'brand': Colors.blue,
  },
)
```

Then use it as: `className: 'fill-brand-500'`.

<a name="related-documentation"></a>
## Related Documentation

- [WIcon](./w-icon.md)
- [WImage](./w-image.md)
