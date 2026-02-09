# Sizing

Utilities for setting the width and height of elements.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Width](#width)
- [Height](#height)
- [Min & Max Dimensions](#min--max-dimensions)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="layout/sizing_basic" size="md" source="example/lib/pages/layout/sizing_basic.dart"></x-preview>

```dart
// Fixed width and height
WDiv(className: 'w-64 h-32 bg-blue-500')

// Percentage based
WDiv(className: 'w-1/2 h-full bg-green-500')

// Viewport relative
WDiv(className: 'w-screen h-screen bg-gray-900')
```

<a name="basic-usage"></a>
## Basic Usage

Use `w-{size}` and `h-{size}` to set fixed dimensions based on the global spacing scale, or use fraction/percentage utilities like `w-1/2` or `w-full`.

```dart
WDiv(
  className: 'w-full max-w-md mx-auto p-6 bg-white rounded-lg shadow-lg',
  child: WText('Centered Content'),
)
```

<a name="quick-reference"></a>
## Quick Reference

### Fixed Sizes

Values follow the global spacing scale (1 unit = 4px).

| Class | Value | Description |
|:------|:------|:------------|
| `w-0` / `h-0` | 0px | Zero width/height |
| `w-px` / `h-px` | 1px | 1px width/height |
| `w-1` / `h-1` | 4px | Tiny |
| `w-4` / `h-4` | 16px | Small |
| `w-16` / `h-16` | 64px | Medium |
| `w-96` / `h-96` | 384px | Large |

### Percentages & Viewport

| Class | Value | Description |
|:------|:------|:------------|
| `w-full` / `h-full` | 100% | Full parent width/height |
| `w-screen` / `h-screen` | 100vw / 100vh | Full viewport width/height |
| `w-1/2` / `h-1/2` | 50% | Half parent size |
| `w-1/3` / `h-1/3` | 33.33% | Third parent size |
| `w-2/3` / `h-2/3` | 66.66% | Two-thirds parent size |
| `w-1/4` / `h-1/4` | 25% | Quarter parent size |
| `w-3/4` / `h-3/4` | 75% | Three-quarters parent size |

<a name="width"></a>
## Width

Set the width of an element using `w-{number}` or `w-{fraction}`.

<x-preview path="layout/sizing_width" size="md" source="example/lib/pages/layout/sizing_width.dart"></x-preview>

```dart
// Fixed width (128px)
WDiv(className: 'w-32 bg-blue-200')

// Fractional width (50%)
WDiv(className: 'w-1/2 bg-blue-300')

// Full width (100%)
WDiv(className: 'w-full bg-blue-400')
```

<a name="height"></a>
## Height

Set the height of an element using `h-{number}`, `h-{fraction}`, or `h-screen`.

<x-preview path="layout/sizing_height" size="md" source="example/lib/pages/layout/sizing_height.dart"></x-preview>

```dart
// Fixed height (64px)
WDiv(className: 'h-16 bg-red-200')

// Full screen height
WDiv(className: 'h-screen bg-red-300')
```

<a name="min--max-dimensions"></a>
## Min & Max Dimensions

Constrain the size of elements using `min-w`, `max-w`, `min-h`, and `max-h` utilities.

### Max-Width Scale

Wind includes a comprehensive max-width scale, perfect for keeping text readable ("measure") or constraining layout width.

| Class | Value |
|:------|:------|
| `max-w-0` | 0px |
| `max-w-none` | No limit (Infinity) |
| `max-w-xs` | 320px |
| `max-w-sm` | 384px |
| `max-w-md` | 448px |
| `max-w-lg` | 512px |
| `max-w-xl` | 576px |
| `max-w-2xl` | 672px |
| `max-w-3xl` | 768px |
| `max-w-4xl` | 896px |
| `max-w-5xl` | 1024px |
| `max-w-6xl` | 1152px |
| `max-w-7xl` | 1280px |
| `max-w-full` | 100% |
| `max-w-screen` | 100vw |
| `max-w-prose` | 65ch (~1040px) |

```dart
// Constrain content width and center it
WDiv(
  className: 'max-w-2xl mx-auto p-4',
  child: WText('Readable content...'),
)
```

### Other Constraints

| Class | Value |
|:------|:------|
| `min-w-0` | 0px |
| `min-w-full` | 100% |
| `min-w-screen` | 100vw |
| `min-h-0` | 0px |
| `min-h-full` | 100% |
| `min-h-screen` | 100vh |
| `max-h-full` | 100% |
| `max-h-screen` | 100vh |

<a name="responsive-design"></a>
## Responsive Design

Apply different sizing utilities at different breakpoints using standard prefixes.

```dart
// Full width on mobile, 50% on tablet, 33% on desktop
WDiv(className: 'w-full md:w-1/2 lg:w-1/3')
```

<a name="dark-mode"></a>
## Dark Mode

While sizing rarely changes based on theme, you can use `dark:` modifiers if needed.

```dart
WDiv(className: 'w-64 dark:w-full')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use square brackets to apply specific values that aren't in the theme scale.

```dart
// Specific pixels
WDiv(className: 'w-[350px] h-[50px]')

// Specific percentage
WDiv(className: 'w-[33%] h-[45%]')
```

<a name="customizing-theme"></a>
## Customizing Theme

To extend the sizing scale, modify the `spacing` section of your `WindThemeData`. This affects width, height, padding, margin, and positioning.

```dart
WindThemeData(
  spacing: {
    '128': 512.0, // Adds w-128, h-128, p-128...
  },
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Padding & Margin](./spacing.md)
- [Flexbox & Grid](./flexbox.md)
- [Aspect Ratio](./aspect_ratio.md)
