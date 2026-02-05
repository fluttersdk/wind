# Sizing

Utilities for setting width, height, and size constraints.

<x-preview path="sizing/sizing_overview" size="md" source="example/lib/pages/sizing/sizing_overview.dart"></x-preview>

## Width

Control element width using fixed values, percentages, or screen-relative units.

<x-preview path="sizing/width" size="md" source="example/lib/pages/sizing/width.dart"></x-preview>

### Fixed Width

```dart
WDiv(className: 'w-8 h-8 bg-blue-500')   // 32px
WDiv(className: 'w-16 h-8 bg-blue-500')  // 64px
WDiv(className: 'w-32 h-8 bg-blue-500')  // 128px
WDiv(className: 'w-48 h-8 bg-indigo-500') // 192px
```

| Class | Width |
| :--- | :--- |
| `w-0` | 0px |
| `w-4` | 16px |
| `w-8` | 32px |
| `w-16` | 64px |
| `w-32` | 128px |
| `w-48` | 192px |
| `w-64` | 256px |

### Fractional Width

```dart
WDiv(className: 'w-1/4 h-8 bg-purple-500')  // 25%
WDiv(className: 'w-1/2 h-8 bg-purple-500')  // 50%
WDiv(className: 'w-3/4 h-8 bg-violet-500')  // 75%
WDiv(className: 'w-full h-8 bg-fuchsia-500') // 100%
```

| Class | Width |
| :--- | :--- |
| `w-1/4` | 25% |
| `w-1/3` | 33.333% |
| `w-1/2` | 50% |
| `w-2/3` | 66.667% |
| `w-3/4` | 75% |
| `w-full` | 100% |
| `w-screen` | 100vw (viewport width) |

### Arbitrary Width

```dart
WDiv(className: 'w-[100px] h-8 bg-emerald-500')  // Exact 100px
WDiv(className: 'w-[50%] h-8 bg-teal-500')       // 50% of parent
```

## Height

Control element height using the same patterns as width.

<x-preview path="sizing/height" size="md" source="example/lib/pages/sizing/height.dart"></x-preview>

### Fixed Height

```dart
WDiv(className: 'h-8 w-16 bg-emerald-500')   // 32px
WDiv(className: 'h-12 w-16 bg-emerald-500')  // 48px
WDiv(className: 'h-16 w-16 bg-teal-500')     // 64px
WDiv(className: 'h-24 w-16 bg-cyan-500')     // 96px
WDiv(className: 'h-32 w-16 bg-sky-500')      // 128px
```

| Class | Height |
| :--- | :--- |
| `h-8` | 32px |
| `h-12` | 48px |
| `h-16` | 64px |
| `h-24` | 96px |
| `h-32` | 128px |
| `h-full` | 100% |
| `h-screen` | 100vh (viewport height) |

### Arbitrary Height

```dart
WDiv(className: 'h-[50px] w-20 bg-amber-500')
WDiv(className: 'h-[80px] w-20 bg-orange-500')
```

## Max Width

Constrain maximum width. Useful for readable content and responsive containers.

### Named Max-Width Sizes

| Class | Width | Use Case |
| :--- | :--- | :--- |
| `max-w-xs` | 320px | Extra small containers |
| `max-w-sm` | 384px | Small cards, modals |
| `max-w-md` | 448px | Medium containers |
| `max-w-lg` | 512px | Large cards |
| `max-w-xl` | 576px | Wide containers |
| `max-w-2xl` | 672px | Article content |
| `max-w-3xl` | 768px | Wide content |
| `max-w-4xl` | 896px | Dashboard panels |
| `max-w-5xl` | 1024px | Large layouts |
| `max-w-6xl` | 1152px | Extra wide |
| `max-w-7xl` | 1280px | Full width constrained |
| `max-w-prose` | 65ch (~1040px) | Optimal reading width |
| `max-w-full` | 100% | No constraint |
| `max-w-screen` | 100vw | Viewport width |

```dart
// Content container with readable width
WDiv(
  className: 'max-w-2xl mx-auto p-6',
  child: WText('Article content...'),
)
```

## Min Width

Set minimum width constraints.

```dart
WDiv(className: 'min-w-32 h-10 bg-amber-500')  // At least 128px
WDiv(className: 'min-w-0')                      // Remove min-width
WDiv(className: 'min-w-full')                   // At least 100%
```

| Class | Min Width |
| :--- | :--- |
| `min-w-0` | 0px |
| `min-w-{n}` | n × 4px |
| `min-w-full` | 100% |

## Max Height

Constrain maximum height.

```dart
WDiv(className: 'max-h-64 overflow-y-auto')  // 256px max, scrollable
WDiv(className: 'max-h-screen')              // Viewport height max
```

| Class | Max Height |
| :--- | :--- |
| `max-h-{n}` | n × 4px |
| `max-h-full` | 100% |
| `max-h-screen` | 100vh |

## Min Height

Set minimum height constraints.

```dart
WDiv(className: 'min-h-screen')  // At least viewport height
WDiv(className: 'min-h-64')      // At least 256px
```

| Class | Min Height |
| :--- | :--- |
| `min-h-0` | 0px |
| `min-h-{n}` | n × 4px |
| `min-h-full` | 100% |
| `min-h-screen` | 100vh |

## Responsive Sizing

Combine with responsive prefixes for adaptive layouts:

```dart
WDiv(
  className: '''
    w-full
    md:w-1/2
    lg:w-1/3
    xl:max-w-xs
  ''',
  child: card,
)
```

## Common Patterns

### Full-Screen Container

```dart
WDiv(
  className: 'w-screen h-screen flex items-center justify-center',
  child: content,
)
```

### Scrollable Content Area

```dart
WDiv(
  className: 'max-h-96 overflow-y-auto',
  children: longList,
)
```

### Centered Content with Max Width

```dart
WDiv(
  className: 'w-full max-w-4xl mx-auto px-4',
  child: pageContent,
)
```

## Notes

### Full Sizing Inside Scroll Views

When using `w-full` or `h-full` inside a scrollable container, Wind automatically uses screen dimensions for proper layout:

```dart
WDiv(
  className: 'w-full h-full overflow-auto',
  child: WDiv(
    className: 'w-full h-full flex items-center justify-center',
    child: WText('Centered Content'),
  ),
)
```

## Related Documentation

- [Spacing](./spacing.md) - Padding and margin
- [Aspect Ratio](./aspect-ratio.md) - Aspect ratio constraints
- [Flexbox](./flexbox.md) - Flex layouts with sizing
