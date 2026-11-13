# Background Image

Utilities for controlling background images, sizing, positioning, and repeat behaviour.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="backgrounds/image" size="md" source="example/lib/pages/backgrounds/image.dart"></x-preview>

```dart
WDiv(
  className: 'bg-[url(images/hero.png)] bg-cover bg-center h-64 w-full rounded-lg',
  child: WText('Hero Section', className: 'text-white font-bold'),
)
```

<a name="basic-usage"></a>
## Basic Usage

### Setting a Background Image

Use the `bg-[url(...)]` utility to set a background image. Wind supports asset paths and absolute file paths. An absolute file path (a `/path` value) loads a `FileImage`, so it works only on platforms with `dart:io` file support: on web and WASM it produces no background image.

```dart
// Asset image (shorthand for assets/)
WDiv(className: 'bg-[url(images/hero.png)]')

// Asset with explicit prefixes
WDiv(className: 'bg-[url(~/images/hero.png)]') // Resolves to assets/images/hero.png
WDiv(className: 'bg-[url(@/images/hero.png)]') // Resolves to assets/images/hero.png
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description | Flutter Equivalent |
|:--- |:--- |:--- |
| `bg-[url(...)]` | Sets the background image | `DecorationImage(image: ...)` |
| `bg-cover` | Scales image to cover container | `fit: BoxFit.cover` |
| `bg-contain` | Scales image to fit container | `fit: BoxFit.contain` |
| `bg-center` | Centres the image | `alignment: Alignment.center` |
| `bg-top` | Aligns image to top | `alignment: Alignment.topCenter` |
| `bg-bottom` | Aligns image to bottom | `alignment: Alignment.bottomCenter` |
| `bg-left` | Aligns image to left | `alignment: Alignment.centerLeft` |
| `bg-right` | Aligns image to right | `alignment: Alignment.centerRight` |
| `bg-no-repeat` | Prevents image repetition | `repeat: ImageRepeat.noRepeat` |

<a name="variants"></a>
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

<a name="responsive-design"></a>
## Responsive Design

Prefix any background utility with a breakpoint modifier to apply it at specific screen sizes.

```dart
WDiv(
  // Mobile: Cover
  // Desktop: Contain
  className: 'bg-[url(...)] bg-cover lg:bg-contain'
)
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to change the background image in dark mode.

```dart
WDiv(
  className: 'bg-[url(bg-light.png)] dark:bg-[url(bg-dark.png)]'
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

The `bg-[...]` syntax allows you to pass any string value.

```dart
// Standard URL syntax
WDiv(className: 'bg-[url(images/hero.png)]')

// Direct path syntax (also supported)
// An absolute path loads a FileImage: native platforms only, no background on web or WASM
WDiv(className: 'bg-[/path/to/local/file.png]')
```

<a name="customizing-theme"></a>
## Customizing Theme

Background images are typically dynamic and not defined in the theme. However, the parser handles `bg-*` classes for colours as well. If you need to customise background **colours**, see the [Background Colour](./background-color.md) documentation.

For images, Wind uses standard Flutter `ImageProvider` implementations based on the URL format:
- URLs starting with `/` become `FileImage`
- All others become `AssetImage` (prefixed with `assets/` unless using `~/` or `@/`)

A URL containing `:` (`http://`, `https://`) cannot sit in a className: the prefix resolver splits on `:` and drops the token. For a network image, stack a `WImage(src: ...)` under the content.

<a name="related-documentation"></a>
## Related Documentation

- [Background Colour](./background-color.md)
- [Background Gradient](./background-gradient.md)
