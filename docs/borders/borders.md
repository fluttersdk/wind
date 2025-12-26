# Borders

Utilities for controlling border width, color, and radius.


## Border Radius

Utilities for rounded corners.

<x-preview path="borders/radius_basic" size="md" class="min-h-64"></x-preview>

| Class | Radius |
| :--- | :--- |
| `rounded-none` | 0px |
| `rounded-sm` | 2px |
| `rounded` | 4px |
| `rounded-md` | 6px |
| `rounded-lg` | 8px |
| `rounded-xl` | 12px |
| `rounded-2xl` | 16px |
| `rounded-3xl` | 24px |
| `rounded-full` | 9999px (Circle/Pill) |

```dart
WDiv(className: "w-10 h-10 bg-blue-500 rounded-full") // Circle
```

## Border Width

<x-preview path="borders/width_basic" size="md"></x-preview>

| Class | Description |
| :--- | :--- |
| `border` | 1px border all sides |
| `border-0` | 0px |
| `border-2` | 2px |
| `border-4` | 4px |
| `border-8` | 8px |

### Individual Sides
Control border width on specific sides.

<x-preview path="borders/width_sides" size="md"></x-preview>

```dart
WDiv(className: "border-t-4 border-indigo-500 ...")  // Top only
WDiv(className: "border-r-4 border-indigo-500 ...")  // Right only
WDiv(className: "border-b-4 border-indigo-500 ...")  // Bottom only
WDiv(className: "border-l-4 border-indigo-500 ...")  // Left only
```

## Border Color

Use `border-{color}-{shade}` utilities to set the border color.

<x-preview path="borders/colors_theme" size="md"></x-preview>

- `border-gray-200`
- `border-red-500`
- `border-transparent`

### Arbitrary Colors

<x-preview path="borders/colors_arbitrary" size="md"></x-preview>

```dart
WDiv(className: "border-2 border-[#FF5733] ...")
```

## Customizing Theme

You can customize border properties in `WindThemeData`.

### Border Radius

Override or extend values for `rounded-{key}` classes.

```dart
WindThemeData(
  borderRadius: {
    'none': 0,
    'sm': 2,
    'DEFAULT': 4, // 'rounded'
    'md': 6,
    'lg': 8,
    'xl': 12,
    'mega': 50, // Custom key: rounded-mega
  },
)
```

Usage: `rounded-mega`.

### Border Widths

Override or extend values for `border-{key}` classes.

```dart
WindThemeData(
  borderWidths: {
    'DEFAULT': 1, // 'border'
    '0': 0,
    '2': 2,
    'thin': 0.5, // Custom key: border-thin
  },
)
```

Usage: `border-thin`.
