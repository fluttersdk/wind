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

## Supported Utility Classes

### Font Size
| Class | Size (rem/px) |
| :--- | :--- |
| `text-xs` | 0.75rem (12px) |
| `text-sm` | 0.875rem (14px) |
| `text-base` | 1rem (16px) |
| `text-lg` | 1.125rem (18px) |
| `text-xl` | 1.25rem (20px) |
| `text-2xl` | 1.5rem (24px) |
| `text-3xl` | 1.875rem (30px) |
| `text-4xl` | 2.25rem (36px) |

### Font Weight
| Class | Weight |
| :--- | :--- |
| `font-thin` | 100 |
| `font-extralight` | 200 |
| `font-light` | 300 |
| `font-normal` | 400 |
| `font-medium` | 500 |
| `font-semibold` | 600 |
| `font-bold` | 700 |
| `font-extrabold` | 800 |
| `font-black` | 900 |

### Decoration
| Class | Description |
| :--- | :--- |
| `underline` | Underline text |
| `line-through` | Strikethrough |
| `no-underline` | Remove decoration |
| `decoration-{color}` | Decoration color |
| `decoration-{style}` | dotted, dashed, double, wavy |
| `decoration-{width}` | 1, 2, 4, 8 |


## Customizing Theme

You can customize typography values in `WindThemeData`.

### Font Sizes & Weights

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

### Letter Spacing (Tracking)

Configure letter spacing values.

```dart
WindThemeData(
  tracking: {
    'tighter': -0.8,
    'tight': -0.4,
    'wide': 0.4,
    'widest': 0.8,
  }
)
```
Usage: `tracking-widest`.

### Line Height (Leading)

Configure line height values.

```dart
WindThemeData(
  leading: {
    'none': 1.0,
    'tight': 1.25,
    'relaxed': 1.625,
    'double': 2.0,
  }
)
```
Usage: `leading-relaxed`.

### Text Colors

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
