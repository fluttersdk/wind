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
  className: 'w-full h-64 object-cover rounded-xl shadow-lg',
)
```

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
  ImageLoadingBuilder? loadingBuilder,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `src` | `String?` | `null` | Image source URL. Prefix with `asset://` for local assets. |
| `image` | `ImageProvider?` | `null` | Direct ImageProvider (e.g., `NetworkImage`, `FileImage`). |
| `alt` | `String?` | `null` | Alternative text for accessibility (semantic label). |
| `className` | `String?` | `null` | Wind utility classes for sizing, fit, and decoration. |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling. |
| `placeholder` | `Widget?` | `null` | Widget to show while the image is loading. |
| `errorBuilder` | `ImageErrorBuilder?` | `null` | Custom builder for error handling. |
| `loadingBuilder` | `ImageLoadingBuilder?` | `null` | Custom builder for loading indicators. |

> [!NOTE]
> Either `src` or `image` must be provided. If `src` is provided, it takes precedence in determining the `ImageProvider`.

## Layout Modes

`WImage` supports common image layout utilities to control how the image is resized and fitted within its container.

### Object Fit

Control how the image content should be resized to fit its container using `object-{fit}` classes.

<x-preview path="widgets/w_image_fit" size="md" source="example/lib/pages/widgets/w_image_fit.dart"></x-preview>

```dart
WImage(
  src: 'https://example.com/photo.jpg',
  className: 'w-64 h-64 object-contain bg-gray-200',
)
```

### Aspect Ratio

Ensure the image maintains a specific aspect ratio regardless of its content dimensions.

<x-preview path="widgets/w_image_ratio" size="md" source="example/lib/pages/widgets/w_image_ratio.dart"></x-preview>

```dart
WImage(
  src: 'https://example.com/banner.jpg',
  className: 'w-full aspect-video object-cover',
)
```

## Event Handling

`WImage` is a display-only widget and does not include built-in gesture handlers. To make an image interactive, wrap it in a `WAnchor` or `WButton`.

```dart
WAnchor(
  onTap: () => print('Image clicked!'),
  child: WImage(
    src: 'https://example.com/avatar.jpg',
    className: 'w-12 h-12 rounded-full hover:opacity-80 transition-opacity',
  ),
)
```

## State Variants

You can use state prefixes to change the image's appearance based on parent state or custom state sets.

```dart
WImage(
  src: 'https://example.com/photo.jpg',
  className: 'opacity-100 hover:opacity-75 transition-opacity duration-300',
)
```

## Styling Examples

### Profile Avatars

Creating circular avatars with borders and shadows.

```dart
WImage(
  src: 'https://example.com/user.jpg',
  className: 'w-16 h-16 rounded-full border-2 border-white shadow-sm object-cover',
)
```

### Rounded Cards

Using specific border radius and shadow depth.

```dart
WImage(
  src: 'https://example.com/thumbnail.jpg',
  className: 'w-full h-48 rounded-t-lg object-cover',
)
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Sizing | `w-{size}`, `h-{size}`, `max-w-{size}`, `min-h-{size}` |
| Object Fit | `object-cover`, `object-contain`, `object-fill`, `object-none`, `object-scale-down` |
| Aspect Ratio | `aspect-square`, `aspect-video`, `aspect-{ratio}` |
| Borders | `border`, `border-{width}`, `border-{color}`, `rounded-{size}` |
| Effects | `shadow-{size}`, `opacity-{n}` |

## Customizing Theme

The default spacing, border radius, and colors used by `WImage` are controlled via `WindThemeData`.

```dart
WindThemeData(
  borderRadius: {
    'xl': 12.0,
  },
  // WImage also respects the default spacing scale for w-* and h-* classes
)
```

## Related Documentation

- [WDiv](./w-div.md) - The fundamental layout container.
- [WSvg](./w-svg.md) - For vector-based graphics.
- [WIcon](./w-icon.md) - For system and custom icons.
