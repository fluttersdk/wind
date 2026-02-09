# Aspect Ratio

Utilities for controlling the aspect ratio of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="layout/aspect_ratio_basic" size="md" source="example/lib/pages/layout/aspect_ratio_basic.dart"></x-preview>

```dart
// Basic examples showing the syntax
WDiv(className: 'aspect-square')
WDiv(className: 'aspect-video')
```

<a name="basic-usage"></a>
## Basic Usage

Use `aspect-{ratio}` to set the preferred aspect ratio of an element. This is particularly useful for images, video players, or ensuring consistent card sizing.

### Video (16:9)

Use `aspect-video` to force a 16:9 ratio, perfect for video content.

```dart
WDiv(
  className: 'w-full aspect-video bg-black',
  child: WText('Video Placeholder', className: 'text-white'),
)
```

### Square (1:1)

Use `aspect-square` to create a perfect square, regardless of width.

```dart
WDiv(
  className: 'w-1/2 aspect-square bg-blue-500',
)
```

### Auto

Use `aspect-auto` to remove any applied aspect ratio constraints.

```dart
WDiv(className: 'aspect-auto')
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Ratio | Description |
|:------|:------|:------------|
| `aspect-auto` | `null` | Default behavior (no ratio) |
| `aspect-square` | `1 / 1` | Square (1:1) |
| `aspect-video` | `16 / 9` | Standard video (16:9) |

<a name="variants"></a>
## Variants

Wind supports standard state variants for aspect ratios.

```dart
// Change aspect ratio on hover
WDiv(className: 'aspect-square hover:aspect-video transition-all')
```

<a name="responsive-design"></a>
## Responsive Design

Apply different aspect ratios at different breakpoints using standard responsive prefixes.

```dart
// Square on mobile, Video on desktop
WDiv(className: 'aspect-square md:aspect-video')
```

<a name="dark-mode"></a>
## Dark Mode

While less common for layout structure, you can conditionally apply aspect ratios in dark mode.

```dart
WDiv(className: 'aspect-square dark:aspect-video')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use the bracket syntax `aspect-[w/h]` to apply any specific aspect ratio that isn't included in the default theme.

```dart
// 4:3 ratio (Classic TV)
WDiv(className: 'aspect-[4/3]')

// 21:9 ratio (Ultrawide)
WDiv(className: 'aspect-[21/9]')
```

> [!NOTE]
> Arbitrary values must use the format `width/height` where both are numbers (e.g., `[4/3]`, `[16/10]`).

<a name="customizing-theme"></a>
## Customizing Theme

Currently, the aspect ratio scale is hardcoded to standard Tailwind defaults (`auto`, `square`, `video`) and cannot be extended via `WindThemeData`.

To use custom ratios, we recommend using [Arbitrary Values](#arbitrary-values) or creating a custom parser if you need named utilities for specific ratios.

<a name="related-documentation"></a>
## Related Documentation

- [Sizing](./sizing.md)
- [Display](./display.md)
