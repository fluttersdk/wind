# Border

Utilities for controlling the border width, color, style, and radius of an element.

## Border Radius

Use the `rounded` utilities to control the border radius.

### Example: Applying Border Radius

<x-preview path="borders/radius_basic" size="md" class="min-h-64"></x-preview>

```dart
WDiv(className: "rounded-sm bg-purple-500 w-16 h-16")
WDiv(className: "rounded-md bg-purple-500 w-16 h-16")
WDiv(className: "rounded-lg bg-purple-500 w-16 h-16")
WDiv(className: "rounded-xl bg-purple-500 w-16 h-16")
```

### All Radius Sizes

| Class | Radius |
|-------|--------|
| `rounded-none` | 0px |
| `rounded-sm` | 2px |
| `rounded` | 4px |
| `rounded-md` | 6px |
| `rounded-lg` | 8px |
| `rounded-xl` | 12px |
| `rounded-2xl` | 16px |
| `rounded-3xl` | 24px |
| `rounded-full` | 9999px |

---

## Border Width

Use the `border`, `border-0`, `border-2`, `border-4`, or `border-8` utilities to set the border width.

### Example: Setting Border Width

<x-preview path="borders/width_basic" size="md"></x-preview>

```dart
WDiv(className: "border border-indigo-500 w-16 h-16")
WDiv(className: "border-2 border-indigo-500 w-16 h-16")
WDiv(className: "border-4 border-indigo-500 w-16 h-16")
WDiv(className: "border-8 border-indigo-500 w-16 h-16")
```

### Individual Sides

<x-preview path="borders/width_sides" size="md"></x-preview>

```dart
WDiv(className: "border-t-4 border-indigo-500 ...")  // Top only
WDiv(className: "border-r-4 border-indigo-500 ...")  // Right only
WDiv(className: "border-b-4 border-indigo-500 ...")  // Bottom only
WDiv(className: "border-l-4 border-indigo-500 ...")  // Left only
```

---

## Border Color

Use `border-{color}-{shade}` utilities to set the border color.

<x-preview path="borders/colors_theme" size="md"></x-preview>

```dart
WDiv(className: "border-2 border-red-500 ...")
WDiv(className: "border-2 border-blue-500 ...")
WDiv(className: "border-2 border-green-500 ...")
```

### Arbitrary Colors

<x-preview path="borders/colors_arbitrary" size="md"></x-preview>

```dart
WDiv(className: "border-2 border-[#FF5733] ...")
WDiv(className: "border-2 border-[#3498DB] ...")
```

---

## Customization

Customize border values via `WindThemeData`:

```dart
WindThemeData(
  borderWidths: {'custom': 3.0},
  borderRadius: {'custom': 10.0},
)
```
