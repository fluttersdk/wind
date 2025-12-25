# Aspect Ratio

Utilities for controlling the aspect ratio of an element.

## Basic Usage

Control the aspect ratio using `aspect-{value}` utilities.

```dart
// Square (1:1)
WDiv(className: "aspect-square w-32 bg-blue-500")

// Video (16:9)
WDiv(className: "aspect-video w-64 bg-red-500")

// Auto (no constraint)
WDiv(className: "aspect-auto w-32 h-24 bg-green-500")
```

<x-preview path="sizing/aspectratio" size="md"></x-preview>

| Class | Aspect Ratio |
| :--- | :--- |
| `aspect-auto` | No aspect ratio constraint |
| `aspect-square` | 1 / 1 |
| `aspect-video` | 16 / 9 |

## Arbitrary Values

For custom aspect ratios, use the bracket notation.

```dart
// 4:3 aspect ratio
WDiv(className: "aspect-[4/3] w-48 bg-purple-500")

// 21:9 ultrawide
WDiv(className: "aspect-[21/9] w-64 bg-orange-500")

// 3:2 classic photo
WDiv(className: "aspect-[3/2] w-48 bg-teal-500")
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
