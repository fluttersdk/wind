# Background Image

Utilities for controlling background images, sizing, positioning, and repeat behavior.

<x-preview path="backgrounds/image" size="md" source="example/lib/pages/backgrounds/image.dart"></x-preview>

## Image Source

Set a background image using URL notation:

```dart
// Network image
WDiv(className: 'bg-[url(https://example.com/image.png)]')

// Asset image (automatically prefixed with assets/)
WDiv(className: 'bg-[url(hero.png)]')

// Asset with path prefix
WDiv(className: 'bg-[url(~/images/hero.png)]')  // → assets/images/hero.png
```

## Image Size

Control how the background image fills its container:

```dart
WDiv(className: 'bg-cover bg-[url(...)]')   // Scale to cover
WDiv(className: 'bg-contain bg-[url(...)]') // Scale to fit
```

| Class | Description |
| :--- | :--- |
| `bg-cover` | Scale image to cover container (may crop) |
| `bg-contain` | Scale image to fit container (may have gaps) |

## Image Position

Control where the background image is positioned:

```dart
WDiv(className: 'bg-center bg-[url(...)]')  // Center
WDiv(className: 'bg-top bg-[url(...)]')     // Top center
WDiv(className: 'bg-bottom bg-[url(...)]')  // Bottom center
```

| Class | Position |
| :--- | :--- |
| `bg-center` | Center |
| `bg-top` | Top center |
| `bg-bottom` | Bottom center |
| `bg-left` | Center left |
| `bg-right` | Center right |
| `bg-top-left` | Top left |
| `bg-top-right` | Top right |
| `bg-bottom-left` | Bottom left |
| `bg-bottom-right` | Bottom right |

## Image Repeat

Control how the background image repeats:

```dart
WDiv(className: 'bg-no-repeat bg-[url(...)]')  // No repeat
WDiv(className: 'bg-repeat bg-[url(...)]')     // Repeat both
WDiv(className: 'bg-repeat-x bg-[url(...)]')   // Repeat horizontal
WDiv(className: 'bg-repeat-y bg-[url(...)]')   // Repeat vertical
```

| Class | Behavior |
| :--- | :--- |
| `bg-no-repeat` | Don't repeat image |
| `bg-repeat` | Repeat in both directions |
| `bg-repeat-x` | Repeat horizontally only |
| `bg-repeat-y` | Repeat vertically only |

## Combined Example

```dart
WDiv(
  className: '''
    bg-[url(https://example.com/hero.jpg)]
    bg-cover
    bg-center
    bg-no-repeat
    h-64
    rounded-lg
  ''',
  child: WText('Hero Section', className: 'text-white text-2xl'),
)
```

## All Classes

| Class | Description |
| :--- | :--- |
| `bg-[url(...)]` | Set background image |
| `bg-cover` | Scale to cover |
| `bg-contain` | Scale to fit |
| `bg-center` | Position center |
| `bg-top` | Position top |
| `bg-bottom` | Position bottom |
| `bg-left` | Position left |
| `bg-right` | Position right |
| `bg-top-left` | Position top-left |
| `bg-top-right` | Position top-right |
| `bg-bottom-left` | Position bottom-left |
| `bg-bottom-right` | Position bottom-right |
| `bg-no-repeat` | Don't repeat |
| `bg-repeat` | Repeat both directions |
| `bg-repeat-x` | Repeat horizontal |
| `bg-repeat-y` | Repeat vertical |

## Related Documentation

- [Background Color](./background-color.md) - Solid background colors
- [Background Gradient](./background-gradient.md) - Gradient backgrounds
