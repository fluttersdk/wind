# Aspect Ratio

Utilities for controlling the aspect ratio of an element.

<x-preview path="sizing/aspectratio" size="lg" source="example/lib/pages/sizing/aspectratio.dart"></x-preview>

## Preset Aspect Ratios

### aspect-square

Square aspect ratio (1:1):

```dart
WDiv(
  className: 'w-32 aspect-square bg-blue-500 rounded-lg flex items-center justify-center',
  child: WText('1:1', className: 'text-white font-bold'),
)
```

### aspect-video

Video aspect ratio (16:9):

```dart
WDiv(
  className: 'w-64 aspect-video bg-red-500 rounded-lg flex items-center justify-center',
  child: WText('16:9', className: 'text-white font-bold'),
)
```

### aspect-auto

No aspect ratio constraint:

```dart
WDiv(
  className: 'w-32 h-24 aspect-auto bg-green-500 rounded-lg flex items-center justify-center',
  child: WText('auto', className: 'text-white font-bold'),
)
```

| Class | Aspect Ratio |
| :--- | :--- |
| `aspect-square` | 1 / 1 |
| `aspect-video` | 16 / 9 |
| `aspect-auto` | No constraint |

## Arbitrary Values

For custom aspect ratios, use the bracket notation:

```dart
// 4:3 aspect ratio
WDiv(
  className: 'w-48 aspect-[4/3] bg-purple-500 rounded-lg flex items-center justify-center',
  child: WText('4:3', className: 'text-white font-bold'),
)

// 21:9 ultrawide
WDiv(
  className: 'w-64 aspect-[21/9] bg-orange-500 rounded-lg flex items-center justify-center',
  child: WText('21:9', className: 'text-white font-bold'),
)

// 3:2 classic photo
WDiv(
  className: 'w-48 aspect-[3/2] bg-teal-500 rounded-lg flex items-center justify-center',
  child: WText('3:2', className: 'text-white font-bold'),
)
```

## Common Aspect Ratios

| Ratio | Usage |
| :--- | :--- |
| `aspect-[1/1]` | Square images, profile pictures |
| `aspect-[4/3]` | Classic TV, old photos |
| `aspect-[16/9]` | HD video, modern screens |
| `aspect-[21/9]` | Ultrawide cinema |
| `aspect-[3/2]` | Classic 35mm photography |
| `aspect-[9/16]` | Vertical/portrait video |

## Related Documentation

- [Sizing](./sizing.md) - Width and height utilities
- [Width](../sizing/width.md) - Width utilities
