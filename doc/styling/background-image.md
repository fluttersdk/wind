# Background Image

Utilities for controlling background images, sizing, positioning, and repeat behavior.

<x-preview path="backgrounds/image" size="md" source="example/lib/pages/backgrounds/image.dart"></x-preview>

```dart
WDiv(
  className: 'bg-[url(https://example.com/hero.jpg)] bg-cover bg-center h-64 w-full rounded-lg',
  child: WText('Hero Section', className: 'text-white font-bold'),
)
```

## Basic Usage

### Setting a Background Image

Use the `bg-[url(...)]` utility to set a background image. Wind supports network URLs, local files, and assets.

```dart
// Network image
WDiv(className: 'bg-[url(https://example.com/image.jpg)]')

// Asset image (shorthand for assets/)
WDiv(className: 'bg-[url(images/hero.png)]')

// Asset with explicit prefixes
WDiv(className: 'bg-[url(~/images/hero.png)]') // Resolves to assets/images/hero.png
WDiv(className: 'bg-[url(@/images/hero.png)]') // Resolves to assets/images/hero.png
```

## Quick Reference

| Class | Description | Flutter Equivalent |
|:--- |:--- |:--- |
| `bg-[url(...)]` | Sets the background image | `DecorationImage(image: ...)` |
| `bg-cover` | Scales image to cover container | `fit: BoxFit.cover` |
| `bg-contain` | Scales image to fit container | `fit: BoxFit.contain` |
| `bg-center` | Centers the image | `alignment: Alignment.center` |
| `bg-top` | Aligns image to top | `alignment: Alignment.topCenter` |
| `bg-bottom` | Aligns image to bottom | `alignment: Alignment.bottomCenter` |
| `bg-left` | Aligns image to left | `alignment: Alignment.centerLeft` |
| `bg-right` | Aligns image to right | `alignment: Alignment.centerRight` |
| `bg-no-repeat` | Prevents image repetition | `repeat: ImageRepeat.noRepeat` |

## Variants

### Size
Control how the background image fills its container using `bg-cover` or `bg-contain`.

```dart
WDiv(className: 'bg-[url(...)] bg-cover')   // Scale to cover (may crop)
WDiv(className: 'bg-[url(...)] bg-contain') // Scale to fit (may have gaps)
```

### Position
Control the position of the background image using `bg-{side}` utilities.

```dart
WDiv(className: 'bg-[url(...)] bg-center')      // Center
WDiv(className: 'bg-[url(...)] bg-top-left')    // Top Left
WDiv(className: 'bg-[url(...)] bg-bottom')      // Bottom Center
```

Supported values: `top`, `bottom`, `left`, `right`, `center`, `top-left`, `top-right`, `bottom-left`, `bottom-right`.

### Repeat
Control how the background image repeats.

```dart
WDiv(className: 'bg-[url(...)] bg-no-repeat') // Default
WDiv(className: 'bg-[url(...)] bg-repeat')    // Tile horizontally and vertically
WDiv(className: 'bg-[url(...)] bg-repeat-x')  // Tile horizontally
WDiv(className: 'bg-[url(...)] bg-repeat-y')  // Tile vertically
```

## Responsive Design

Prefix any background utility with a breakpoint modifier to apply it at specific screen sizes.

```dart
WDiv(
  // Mobile: Cover
  // Desktop: Contain
  className: 'bg-[url(...)] bg-cover lg:bg-contain'
)
```

## Dark Mode

Use the `dark:` prefix to change the background image in dark mode.

```dart
WDiv(
  className: 'bg-[url(bg-light.png)] dark:bg-[url(bg-dark.png)]'
)
```

## Arbitrary Values

The `bg-[...]` syntax allows you to pass any string value.

```dart
// Standard URL syntax
WDiv(className: 'bg-[url(https://site.com/img.png)]')

// Direct path syntax (also supported)
WDiv(className: 'bg-[/path/to/local/file.png]')
```

## Customizing Theme

Background images are typically dynamic and not defined in the theme. However, the parser handles `bg-*` classes for colors as well. If you need to customize background **colors**, see the [Background Color](./background-color.md) documentation.

For images, Wind uses standard Flutter `ImageProvider` implementations based on the URL format:
- URLs starting with `http`/`https` become `NetworkImage`
- URLs starting with `/` become `FileImage`
- All others become `AssetImage` (prefixed with `assets/` unless using `~/` or `@/`)

## Related Documentation

- [Background Color](./background-color.md)
- [Background Gradient](./background-gradient.md)
