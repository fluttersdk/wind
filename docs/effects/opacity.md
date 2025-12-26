# Opacity

Utilities for controlling the opacity of an element.

## Basic Usage

Control the opacity of an element using `opacity-{value}` utilities.

<x-preview path="effects/opacity" size="md"></x-preview>

```dart
WDiv(className: "opacity-100 bg-blue-500")
WDiv(className: "opacity-75 bg-blue-500")
WDiv(className: "opacity-50 bg-blue-500")
WDiv(className: "opacity-25 bg-blue-500")
WDiv(className: "opacity-0 bg-blue-500")
```

| Class | Properties |
| :--- | :--- |
| `opacity-0` | opacity: 0 |
| `opacity-5` | opacity: 0.05 |
| `opacity-10` | opacity: 0.1 |
| `opacity-20` | opacity: 0.2 |
| `opacity-25` | opacity: 0.25 |
| `opacity-30` | opacity: 0.3 |
| `opacity-40` | opacity: 0.4 |
| `opacity-50` | opacity: 0.5 |
| `opacity-60` | opacity: 0.6 |
| `opacity-70` | opacity: 0.7 |
| `opacity-75` | opacity: 0.75 |
| `opacity-80` | opacity: 0.8 |
| `opacity-90` | opacity: 0.9 |
| `opacity-95` | opacity: 0.95 |
| `opacity-100` | opacity: 1 |

## Arbitrary Values

For one-off opacity values, use the bracket notation.

```dart
WDiv(className: "opacity-[0.35] bg-blue-500")
WDiv(className: "opacity-[0.67] bg-blue-500")
```

## Customizing Theme

You can customize the available opacity intervals in your `WindThemeData`.

```dart
WindTheme(
  theme: WindThemeData(
    opacities: {
      'disabled': 0.35,
      'faint': 0.10,
    },
  ),
  child: MyApp(),
)
```

Now you can use these custom keys in your utilities:

```dart
WDiv(className: "opacity-disabled") // 0.35
WDiv(className: "opacity-faint")    // 0.10
```
