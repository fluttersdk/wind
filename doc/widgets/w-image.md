# WImage

The `WImage` widget brings utility-first styling to images in Flutter, providing HTML-like semantics with Tailwind-inspired classes for sizing, object fitting, and decoration.

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

<x-preview path="images/image_basic" size="md" source="example/lib/pages/images/image_basic.dart"></x-preview>

```dart
WImage(
  src: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
  alt: 'Forest landscape',
  className: 'w-96 h-64 object-cover rounded-xl',
)
```

<a name="basic-usage"></a>
## Basic Usage

The `WImage` widget handles both network and asset images. For network images, simply provide the URL to the `src` property. For asset images, use the `asset://` prefix.

```dart
// Network Image
WImage(
  src: 'https://example.com/image.jpg',
  className: 'w-32 h-32 rounded-full',
)

// Asset Image
WImage(
  src: 'asset://assets/images/logo.png',
  className: 'w-12 h-12',
)
```

<a name="constructor"></a>
## Constructor

```dart
const WImage({
  Key? key,
  String? src,
  ImageProvider? image,
  String? alt,
  String? className,
  Set<String>? states,
  Widget? placeholder,
  ImageErrorBuilder? errorBuilder,
  Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `src` | `String?` | `null` | Image source URL. Prefix with `asset://` for local assets. |
| `image` | `ImageProvider?` | `null` | Direct ImageProvider (e.g., `NetworkImage`, `FileImage`). |
| `alt` | `String?` | `null` | Alternative text for accessibility (semantic label). |
| `className` | `String?` | `null` | Wind utility classes for sizing, fit, and decoration. |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling. |
| `placeholder` | `Widget?` | `null` | Widget to show while a network image is loading. Only applies to a network `src`; ignored for `asset://` sources and `image` providers. |
| `errorBuilder` | `ImageErrorBuilder?` | `null` | Custom builder for error handling. |
| `loadingBuilder` | `Widget Function(BuildContext, Widget, ImageChunkEvent?)?` | `null` | Custom builder for loading indicators. Only applies to a network `src`, and takes precedence over `placeholder`. |

> [!NOTE]
> Either `src` or `image` must be provided. If both are provided, `image` takes precedence.
>
> `WImage` declares its own `ImageLoadingBuilder` typedef with the same shape as Flutter's, so naming it in a file that also imports Flutter's widgets library is an ambiguous import. Spell out the function type, as in the constructor above.

<a name="layout-modes"></a>
## Layout Modes

`WImage` supports common image layout utilities to control how the image is resized and fitted within its container. Only fixed `w-{n}` and `h-{n}` sizes are applied; `w-full` and other fractional widths are ignored. For a full-width image, wrap it in `WDiv(className: 'w-full')`.

### Object Fit

Control how the image content should be resized to fit its container using `object-{fit}` classes.

<x-preview path="widgets/w_image_fit" size="md" source="example/lib/pages/widgets/w_image_fit.dart"></x-preview>

```dart
WImage(
  src: 'https://example.com/photo.jpg',
  className: 'w-64 h-64 object-contain bg-gray-200',
)
```

### Object Position

`object-cover` centres the crop, so in a short, wide banner the upper part of a tall photo (a face, a skyline) is cut off. Choose which part stays in view with `object-{position}` classes: `object-top`, `object-bottom`, `object-left`, `object-right`, `object-left-top`, `object-left-bottom`, `object-right-top`, `object-right-bottom` and `object-center` (the default). They combine with every fit class and map to the matching Flutter `Alignment` on the image.

<x-preview path="widgets/w_image_fit" size="md" source="example/lib/pages/widgets/w_image_fit.dart"></x-preview>

```dart
WImage(
  src: 'https://example.com/backdrop.jpg',
  className: 'w-96 h-40 object-cover object-top',
)
```

> [!NOTE]
> Like the `object-{fit}` classes, position classes are read straight off `className`: the first match wins and prefixed forms such as `md:object-top` or `hover:object-bottom` are not applied.

### Aspect Ratio

Ensure the image maintains a specific aspect ratio regardless of its content dimensions.

<x-preview path="widgets/w_image_ratio" size="md" source="example/lib/pages/widgets/w_image_ratio.dart"></x-preview>

```dart
WImage(
  src: 'https://example.com/banner.jpg',
  className: 'w-96 aspect-video object-cover',
)
```

<a name="event-handling"></a>
## Event Handling

`WImage` is a display-only widget and does not include built-in gesture handlers. To make an image interactive, wrap it in a `WAnchor` or `WButton`.

```dart
WAnchor(
  onTap: () => print('Image clicked!'),
  child: WImage(
    src: 'https://example.com/avatar.jpg',
    className: 'w-12 h-12 rounded-full hover:opacity-80',
  ),
)
```

<a name="state-variants"></a>
## State Variants

You can use state prefixes to change the image's appearance based on parent state or custom state sets.

`WImage` has no anchor of its own, so `hover:` only fires when an ancestor publishes state (`WAnchor`, `WButton`, `WPopover`).

```dart
WAnchor(
  onTap: () {},
  child: WImage(
    src: 'https://example.com/photo.jpg',
    className: 'w-64 h-40 opacity-100 hover:opacity-75',
  ),
)
```

<a name="styling-examples"></a>
## Styling Examples

### Profile Avatars

Creating circular avatars with borders.

```dart
WImage(
  src: 'https://example.com/user.jpg',
  className: 'w-16 h-16 rounded-full border-2 border-white dark:border-gray-800 object-cover',
)
```

### Rounded Cards

Using a specific border radius on the top corners.

```dart
WImage(
  src: 'https://example.com/thumbnail.jpg',
  className: 'w-80 h-48 rounded-t-lg object-cover',
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Sizing | `w-{size}`, `h-{size}` |
| Object Fit | `object-cover`, `object-contain`, `object-fill`, `object-none`, `object-scale-down` |
| Object Position | `object-top`, `object-bottom`, `object-left`, `object-right`, `object-left-top`, `object-left-bottom`, `object-right-top`, `object-right-bottom`, `object-center` |
| Aspect Ratio | `aspect-square`, `aspect-video`, `aspect-{ratio}` |
| Borders | `border`, `border-{width}`, `border-{color}`, `rounded-{size}` |
| Effects | `opacity-{n}` |

`WImage` does not apply `shadow-*` classes. To cast a shadow, put the image inside a `WDiv` that carries the shadow.

<a name="customizing-theme"></a>
## Customizing Theme

The default spacing, border radius, and colours used by `WImage` are controlled via `WindThemeData`.

```dart
WindThemeData(
  borderRadius: {
    'xl': 12.0,
  },
  // WImage also respects the default spacing scale for w-* and h-* classes
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WDiv](./w-div.md) - The fundamental layout container.
- [WSvg](./w-svg.md) - For vector-based graphics.
- [WIcon](./w-icon.md) - For system and custom icons.

<!-- steer probe w-image -->
