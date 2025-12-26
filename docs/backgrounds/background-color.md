# Backgrounds

Utilities for controlling the background of an element.

## Background Color
Utilities for controlling the background color of an element.

<x-preview path="backgrounds/colors" size="md"></x-preview>

```dart
WText("Red", className: "bg-red-500 text-white")
WText("Opacity", className: "bg-red-500/50")
WText("Arbitrary", className: "bg-[#1da1f2]")
```

| Class | Properties |
| :--- | :--- |
| `bg-transparent` | background-color: transparent; |
| `bg-black` | background-color: #000; |
| `bg-white` | background-color: #fff; |
| `bg-red-500` | background-color: #ef4444; |
| `bg-[#1da1f2]` | background-color: #1da1f2; |

### Opacity
You can control the opacity of the background color using the color opacity modifier.

| Class | Properties |
| :--- | :--- |
| `bg-red-500/50` | background-color: rgb(239 68 68 / 0.5); |
| `bg-blue-500/[0.2]` | background-color: rgb(59 130 246 / 0.2); |

## Background Gradient
Utilities for controlling the background gradient.

<x-preview path="backgrounds/gradients" size="md"></x-preview>

```dart
WDiv(className: "bg-gradient-to-r from-cyan-500 to-blue-500")
WDiv(className: "bg-gradient-to-b from-yellow-400 via-orange-500 to-red-500")
```

| Class | Properties |
| :--- | :--- |
| `bg-gradient-to-r` | background-image: linear-gradient(to right, ...); |
| `bg-gradient-to-tr` | ... |
| `from-yellow-400` | --tw-gradient-from: #facc15; |
| `via-red-500` | --tw-gradient-stops: var(--tw-gradient-from), #ef4444, var(--tw-gradient-to); |
| `to-pink-500` | --tw-gradient-to: #ec4899; |

### Usage
Combine direction, from, (optional via), and to classes.

```dart
WDiv(
  className: "bg-gradient-to-r from-cyan-500 to-blue-500",
  // Content
)
```

## Customizing Theme

### Colors
You can extend the global color palette in `WindThemeData`, which is used for background colors, text colors, and border colors.

```dart
WindThemeData(
  colors: {
    'brand': Colors.blue,
    'surface': Color(0xFF1E293B),
  },
)
```
Usage: `bg-brand-500`, `bg-surface`.
