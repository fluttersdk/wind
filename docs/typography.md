# Typography

Utilities for controlling the font family, size, weight, alignment, color, and more.

## Font Size
Utilities for controlling value of font size.

<x-preview path="typography/basics" size="md"></x-preview>

```dart
WText("Text XS", className: "text-xs")
WText("Text SM", className: "text-sm")
WText("Text Base", className: "text-base")
WText("Text LG", className: "text-lg")
WText("Text XL", className: "text-xl")
WText("Text 2XL", className: "text-2xl")
```

| Class | Properties |
| :--- | :--- |
| `text-xs` | font-size: 0.75rem; /* 12px */ |
| `text-sm` | font-size: 0.875rem; /* 14px */ |
| `text-base` | font-size: 1rem; /* 16px */ |
| `text-lg` | font-size: 1.125rem; /* 18px */ |
| `text-xl` | font-size: 1.25rem; /* 20px */ |
| `text-2xl` | font-size: 1.5rem; /* 24px */ |
| `text-3xl` | font-size: 1.875rem; /* 30px */ |
| `text-4xl` | font-size: 2.25rem; /* 36px */ |

## Text Color
Utilities for controlling value of text color.

<x-preview path="typography/colors" size="md"></x-preview>

```dart
WText("Red Text", className: "text-red-500")
WText("Arbitrary Hex", className: "text-[#FF00FF]")
WAnchor(
    onTap: () {},
    child: Text("Hover me", className: "text-gray-500 hover:text-blue-500"),
)
```

### Opacity
You can control the opacity of the text color using the color opacity modifier.

| Class | Properties |
| :--- | :--- |
| `text-red-500/50` | color: rgb(239 68 68 / 0.5); |
| `text-blue-500/[0.25]` | color: rgb(59 130 246 / 0.25); |

```dart
WText("50% Opacity", className: "text-red-500/50")
WText("25% Opacity", className: "text-blue-500/25")
```

## Text Alignment
Utilities for controlling the alignment of text.

<x-preview path="typography/alignment" size="md"></x-preview>

```dart
WText("Left Aligned", className: "text-left")
WText("Center Aligned", className: "text-center")
WText("Right Aligned", className: "text-right")
WText("Justified", className: "text-justify")
```

## Text Decoration
Utilities for controlling text decoration.

<x-preview path="typography/decoration" size="md"></x-preview>

```dart
WText("Underline", className: "underline")
WText("Line Through", className: "line-through")
WText("No Underline", className: "no-underline")
WText("Decorated", className: "underline decoration-red-500 decoration-wavy")
```

## Font Weight
Utilities for controlling the font weight.

| Class | Properties |
| :--- | :--- |
| `font-thin` | font-weight: 100; |
| `font-extralight` | font-weight: 200; |
| `font-light` | font-weight: 300; |
| `font-normal` | font-weight: 400; |
| `font-medium` | font-weight: 500; |
| `font-semibold` | font-weight: 600; |
| `font-bold` | font-weight: 700; |
| `font-extrabold` | font-weight: 800; |
| `font-black` | font-weight: 900; |


## Customization

You can customize typography values in `WindThemeData`.

### Customizing Colors
Extend the color palette by passing a `colors` map to `WindThemeData`.

```dart
WindThemeData(
  colors: {
    'brand': Colors.blue,
    'accent': Colors.orange,
  },
)
```
Usage: `text-brand-500`, `text-accent`.

### Customizing Fonts
Override default font sizes or weights.

```dart
WindThemeData(
  fontSizes: {
    'xs': 10.0,
    'mega': 100.0,
  },
  fontWeights: {
    'heavy': FontWeight.w900,
  }
)
```
Usage: `text-mega`, `font-heavy`.

