# Border

Utilities for controlling the border width, color, style, and radius of an element.

## Border Width

Use the `border`, `border-0`, `border-2`, `border-4`, or `border-8` utilities to set the border width for all sides of an element.

### Example: Setting Border Width

<x-preview path="borders/width" size="md"></x-preview>

```dart
WDiv(className: "border border-gray-300 ..."),
WDiv(className: "border-2 border-gray-300 ..."),
WDiv(className: "border-4 border-gray-300 ..."),
WDiv(className: "border-8 border-gray-300 ..."),
```

### Individual Sides

Use `border-t`, `border-r`, `border-b`, `border-l` to control individual sides:

```dart
WDiv(className: "border-t-4 border-indigo-500 ..."), // Top only
WDiv(className: "border-r-4 border-indigo-500 ..."), // Right only
WDiv(className: "border-b-4 border-indigo-500 ..."), // Bottom only
WDiv(className: "border-l-4 border-indigo-500 ..."), // Left only
```

---

## Border Color

Use `border-{color}-{shade}` utilities to set the border color.

### Example: Setting Border Color

<x-preview path="borders/colors" size="md"></x-preview>

```dart
WDiv(className: "border-2 border-red-500 ..."),
WDiv(className: "border-2 border-blue-500 ..."),
WDiv(className: "border-2 border-green-500 ..."),
```

### Arbitrary Colors

Use arbitrary values for custom colors:

```dart
WDiv(className: "border-2 border-[#FF5733] ..."),
WDiv(className: "border-2 border-[#3498DB] ..."),
```

---

## Border Radius

Use the `rounded` utilities to control the border radius.

### Example: Applying Border Radius

<x-preview path="borders/basic" size="md" class="min-h-64"></x-preview>

```dart
WDiv(className: "rounded-sm bg-purple-500 ..."),
WDiv(className: "rounded-md bg-purple-500 ..."),
WDiv(className: "rounded-lg bg-purple-500 ..."),
WDiv(className: "rounded-xl bg-purple-500 ..."),
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

### Individual Corners

Use directional utilities for specific corners:

```dart
WDiv(className: "rounded-t-lg ..."),  // Top corners
WDiv(className: "rounded-r-lg ..."),  // Right corners
WDiv(className: "rounded-b-lg ..."),  // Bottom corners
WDiv(className: "rounded-l-lg ..."),  // Left corners
WDiv(className: "rounded-tl-lg ..."), // Top-left only
WDiv(className: "rounded-tr-lg ..."), // Top-right only
WDiv(className: "rounded-bl-lg ..."), // Bottom-left only
WDiv(className: "rounded-br-lg ..."), // Bottom-right only
```

---

## Complete Example

Combining border width, color, and radius:

```dart
WDiv(
  className: "border-2 border-blue-500 rounded-lg p-4 bg-white",
  child: WText(
    "Styled Card",
    className: "text-blue-900 font-medium",
  ),
)
```
