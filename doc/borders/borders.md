# Borders

Utilities for controlling border width, color, style, and radius.

## Border Radius

Utilities for rounded corners.

<x-preview path="borders/radius_basic" size="md" class="min-h-64" source="example/lib/pages/borders/radius_basic.dart"></x-preview>

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

### Directional Radius

Apply radius to specific corners or sides.

```dart
WDiv(className: "rounded-t-lg ...")   // Top corners
WDiv(className: "rounded-r-lg ...")   // Right corners
WDiv(className: "rounded-b-lg ...")   // Bottom corners
WDiv(className: "rounded-l-lg ...")   // Left corners
WDiv(className: "rounded-tl-lg ...")  // Top-left only
WDiv(className: "rounded-tr-lg ...")  // Top-right only
WDiv(className: "rounded-bl-lg ...")  // Bottom-left only
WDiv(className: "rounded-br-lg ...")  // Bottom-right only
```

## Border Width

<x-preview path="borders/width_basic" size="md" source="example/lib/pages/borders/width_basic.dart"></x-preview>

| Class | Description |
| :--- | :--- |
| `border` | 1px border all sides |
| `border-0` | 0px |
| `border-2` | 2px |
| `border-4` | 4px |
| `border-8` | 8px |

### Individual Sides

Control border width on specific sides.

<x-preview path="borders/width_sides" size="md" source="example/lib/pages/borders/width_sides.dart"></x-preview>

```dart
WDiv(className: "border-t-4 border-indigo-500 ...")  // Top only
WDiv(className: "border-r-4 border-indigo-500 ...")  // Right only
WDiv(className: "border-b-4 border-indigo-500 ...")  // Bottom only
WDiv(className: "border-l-4 border-indigo-500 ...")  // Left only
```

### Arbitrary Width

Use bracket notation for custom border widths.

```dart
WDiv(className: "border-[3px] border-indigo-500 ...")
WDiv(className: "border-[0.5px] border-gray-300 ...")
```

## Border Style

Control the style of the border.

| Class | Description |
| :--- | :--- |
| `border-solid` | Solid border (default) |
| `border-none` | Remove border |

```dart
WDiv(className: "border-2 border-solid border-gray-500 ...")
WDiv(className: "border-none ...")  // Remove border
```

## Border Color

Use `border-{color}-{shade}` utilities to set the border color.

<x-preview path="borders/colors_theme" size="md" source="example/lib/pages/borders/colors_theme.dart"></x-preview>

```dart
WDiv(className: "border-2 border-gray-200 ...")
WDiv(className: "border-2 border-red-500 ...")
WDiv(className: "border-2 border-transparent ...")
```

### Color Opacity

Control border color opacity with the `/` modifier.

```dart
WDiv(className: "border-2 border-red-500 ...")     // 100% opacity
WDiv(className: "border-2 border-red-500/75 ...")  // 75% opacity
WDiv(className: "border-2 border-red-500/50 ...")  // 50% opacity
WDiv(className: "border-2 border-red-500/25 ...")  // 25% opacity
```

### Arbitrary Colors

<x-preview path="borders/colors_arbitrary" size="md" source="example/lib/pages/borders/colors_arbitrary.dart"></x-preview>

```dart
WDiv(className: "border-2 border-[#FF5733] ...")
WDiv(className: "border-2 border-[#1da1f2] ...")
```

## All Classes

| Class | Description |
| :--- | :--- |
| `rounded-{size}` | Uniform border radius |
| `rounded-{dir}-{size}` | Directional radius (t/r/b/l/tl/tr/bl/br) |
| `border` / `border-{width}` | Border width |
| `border-{dir}-{width}` | Directional border width |
| `border-[value]` | Arbitrary border width |
| `border-{color}-{shade}` | Border color |
| `border-{color}/opacity` | Color with opacity |
| `border-[#hex]` | Arbitrary color |
| `border-solid` / `border-none` | Border style |

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

## Related Documentation

- [Ring](./ring.md) - Focus ring utilities
- [Outline](./outline.md) - Outline utilities
- [Shadow](../styling/shadow.md) - Box shadow utilities
