# Spacing

Utilities for controlling padding and margin.

## Padding
Utilities for controlling the padding of an element.

<x-preview path="spacing/padding" size="md"></x-preview>

```dart
WText("p-4", className: "p-4 bg-red-200")
WText("px-8", className: "px-8 bg-blue-200")
WText("pt-4", className: "pt-4 bg-yellow-200")
```

## Margin
Utilities for controlling the margin of an element.

<x-preview path="spacing/margin" size="md"></x-preview>

```dart
WText("m-4", className: "m-4 bg-red-200")
WText("mx-8", className: "mx-8 bg-blue-200")
WText("my-4", className: "my-4 bg-green-200")
```

## Supported Utility Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Padding** | `p-{n}`, `px-{n}`, `py-{n}`, `pt-{n}`, `pr-{n}`, `pb-{n}`, `pl-{n}` | Inner spacing |
| **Margin** | `m-{n}`, `mx-{n}`, `my-{n}`, `mt-{n}`, `mr-{n}`, `mb-{n}`, `ml-{n}` | Outer spacing |

### Arbitrary Values

You can use square brackets for precise pixel values:

- `p-[20px]`
- `mt-[10.5px]`
- `gap-[5px]`

## Customizing Theme

### Base Spacing Unit

Wind uses a grid system divisible by 4. You can customize this standard spacing unit in `WindThemeData`.
The default is `4.0` pixels.

```dart
WindThemeData(
  baseSpacingUnit: 8.0, // Now 'p-1' is 8px, 'p-4' is 32px
)
```

This affects all utilities that use the spacing scale:
- Padding (`p-*`)
- Margin (`m-*`)
- Width (`w-*`, except percentages)
- Height (`h-*`, except percentages)
- Gap (`gap-*`)
- Inset (`top-*`, `left-*` etc. if supported)
