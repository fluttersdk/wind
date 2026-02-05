# Z-Index

Utilities for controlling the stack order of an element.

<x-preview path="layout/z_index" size="lg" source="example/lib/pages/layout/z_index.dart"></x-preview>

> [!IMPORTANT]
> Flutter doesn't have CSS-like positioning (`absolute`, `relative`, `fixed`). Z-index only works within `Stack` widgets where children are ordered by index.

## Basic Usage

Control the stack order using `z-{value}` utilities inside a `Stack`:

```dart
Stack(
  children: [
    Positioned(
      left: 0, top: 0,
      child: WDiv(
        className: 'z-10 w-24 h-24 bg-blue-500 rounded-lg flex items-center justify-center',
        child: WText('z-10', className: 'text-white font-bold'),
      ),
    ),
    Positioned(
      left: 40, top: 30,
      child: WDiv(
        className: 'z-20 w-24 h-24 bg-red-500 rounded-lg flex items-center justify-center',
        child: WText('z-20', className: 'text-white font-bold'),
      ),
    ),
    Positioned(
      left: 80, top: 60,
      child: WDiv(
        className: 'z-30 w-24 h-24 bg-green-500 rounded-lg flex items-center justify-center',
        child: WText('z-30', className: 'text-white font-bold'),
      ),
    ),
  ],
)
```

## Preset Values

Standard z-index values from the theme:

| Class | Value |
| :--- | :--- |
| `z-0` | 0 |
| `z-10` | 10 |
| `z-20` | 20 |
| `z-30` | 30 |
| `z-40` | 40 |
| `z-50` | 50 |
| `z-auto` | Reset/unset |

## Arbitrary Values

For custom z-index values, use the bracket notation:

```dart
WDiv(className: 'z-[100]')  // z-index: 100
WDiv(className: 'z-[1000]') // z-index: 1000
WDiv(className: 'z-[-1]')   // z-index: -1
```

## Programmatic Access

You can access the parsed `zIndex` value from `WindStyle`:

```dart
final style = WindParser.parse('z-20', context);
print(style.zIndex); // 20
```

## Customizing Theme

Customize available Z-Index values in `WindThemeData`:

```dart
WindThemeData(
  zIndices: {
    '0': 0,
    '10': 10,
    'dropdown': 1000,
    'modal': 9000,
  }
)
```

Usage: `z-dropdown`, `z-modal`.

## All Z-Index Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Preset** | `z-0`, `z-10`...`z-50` | Standard stack layers |
| **Auto** | `z-auto` | Reset/unset z-index |
| **Arbitrary** | `z-[100]`, `z-[-1]` | Custom z-index value |

## Related Documentation

- [Display](./display.md) - Display and visibility utilities
