# Ring

Utilities for creating focus rings and outline effects.

Ring is implemented as a box shadow with spread radius only (no blur), similar to Tailwind CSS's ring utility.

## Ring Width

Control the width of the ring.

<x-preview path="effects/ring_basic" size="md"></x-preview>

```dart
WDiv(className: "ring ring-blue-500 p-4")
WDiv(className: "ring-2 ring-blue-500 p-4")
WDiv(className: "ring-4 ring-blue-500 p-4")
```

| Class | Width |
| :--- | :--- |
| `ring-0` | 0px |
| `ring-1` | 1px |
| `ring-2` | 2px |
| `ring` | 3px (default) |
| `ring-4` | 4px |
| `ring-8` | 8px |

---

## Ring Color

Control the color of the ring.

<x-preview path="effects/ring_colors" size="md"></x-preview>

```dart
WDiv(className: "ring-4 ring-red-500 p-4")
WDiv(className: "ring-4 ring-green-500 p-4")
WDiv(className: "ring-4 ring-[#1da1f2] p-4")
```

| Class | Behavior |
| :--- | :--- |
| `ring-{color}-{shade}` | Sets the ring color |
| `ring-[#hex]` | Sets arbitrary ring color |

### Opacity

You can control the opacity of the ring color using the color opacity modifier.

<x-preview path="effects/ring_opacity" size="md"></x-preview>

| Class | Behavior |
| :--- | :--- |
| `ring-red-500/50` | Ring color with 50% opacity |
| `ring-blue-500/[0.25]` | Ring color with 25% opacity |

```dart
WDiv(className: "ring-4 ring-red-500/50 p-4")
WDiv(className: "ring-4 ring-blue-500/25 p-4")
```

---

## Ring Offset

Add offset between the ring and the element.

```dart
WDiv(className: "ring-4 ring-offset-2 ring-blue-500 p-4")
WDiv(className: "ring-4 ring-offset-4 ring-blue-500 p-4")
```

| Class | Offset |
| :--- | :--- |
| `ring-offset-0` | 0px |
| `ring-offset-1` | 1px |
| `ring-offset-2` | 2px |
| `ring-offset-4` | 4px |
| `ring-offset-8` | 8px |

---

## Ring Inset

Render the ring on the inside of the element.

```dart
WDiv(className: "ring-4 ring-inset ring-blue-500 p-4")
```

---

## Customizing Theme

You can customize ring properties in `WindThemeData`.

### Default Ring Color

When no ring color is specified (e.g., just `ring`), this color will be used instead of the default blue-500.

```dart
WindThemeData(
  ringColor: Colors.purple,
)
```

### Ring Widths

Override available values for `ring-{width}` classes.

```dart
WindThemeData(
  ringWidths: {
    'DEFAULT': 3,
    '0': 0,
    '10': 10,
  },
)
```
Usage: `ring-10`.

### Ring Offsets

Override available values for `ring-offset-{width}` classes.

```dart
WindThemeData(
  ringOffsets: {
    '0': 0,
    '2': 2,
    'loose': 12,
  },
)
```
Usage: `ring-offset-loose`.
