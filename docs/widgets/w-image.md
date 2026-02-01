# WImage

A utility-first image component with HTML `<img>` semantics.

<x-preview path="images/image_basic" size="md" source="example/lib/pages/images/image_basic.dart"></x-preview>

## Basic Usage

Display images with utility classes for sizing and styling:

```dart
WImage(
  src: 'https://example.com/image.jpg',
  alt: 'Description',
  className: 'w-32 h-32 rounded-lg object-cover',
)
```

### Using ImageProvider

Pass an `ImageProvider` directly:

```dart
WImage(
  image: AssetImage('assets/images/logo.png'),
  className: 'w-32 h-32 rounded-lg',
)
```

### Asset Images

Use `asset://` prefix for local assets:

```dart
WImage(
  src: 'asset://assets/images/logo.png',
  className: 'w-24 h-24',
)
```

## Object Fit

Control how the image fills its container:

| Class | BoxFit |
| :--- | :--- |
| `object-cover` | `BoxFit.cover` (default) |
| `object-contain` | `BoxFit.contain` |
| `object-fill` | `BoxFit.fill` |
| `object-none` | `BoxFit.none` |
| `object-scale-down` | `BoxFit.scaleDown` |

```dart
WImage(src: '...', className: 'w-24 h-24 object-contain')
```

## Aspect Ratio

Maintain proportions with aspect ratio classes:

```dart
WImage(src: '...', className: 'w-32 aspect-video object-cover')  // 16:9
WImage(src: '...', className: 'w-32 aspect-square object-cover') // 1:1
WImage(src: '...', className: 'w-32 aspect-[4/3] object-cover')  // 4:3
```

## Placeholder & Error

Handle loading and error states:

```dart
WImage(
  src: 'https://example.com/image.jpg',
  placeholder: CircularProgressIndicator(),
  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
)
```

## Props

| Prop | Type | Description |
| :--- | :--- | :--- |
| `src` | `String?` | Image URL or `asset://` path |
| `image` | `ImageProvider?` | Direct ImageProvider (use instead of `src`) |
| `alt` | `String?` | Semantic label |
| `className` | `String?` | Utility classes |
| `placeholder` | `Widget?` | Loading widget |
| `errorBuilder` | `ImageErrorBuilder?` | Error handler |
| `loadingBuilder` | `ImageLoadingBuilder?` | Loading handler |

> **Note:** Either `src` or `image` must be provided.

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-{n}`, `h-{n}` | Width and height |
| **Object Fit** | `object-cover`, `object-contain`, `object-fill`, `object-none`, `object-scale-down` | BoxFit mode |
| **Aspect Ratio** | `aspect-video`, `aspect-square`, `aspect-[X/Y]` | Maintain proportions |
| **Rounded Corners** | `rounded`, `rounded-{size}`, `rounded-full` | Border radius |
| **Border** | `border`, `border-{width}`, `border-{color}` | Image border |
| **Opacity** | `opacity-{n}` | Opacity (0-100) |
| **Shadow** | `shadow`, `shadow-{size}` | Box shadow |

## Related Documentation

- [WAnchor](./w-anchor.md) - Interactive wrapper for hover states
- [WDiv](./w-div.md) - Container component
- [Aspect Ratio](../layout/aspect-ratio.md) - Aspect ratio utilities
