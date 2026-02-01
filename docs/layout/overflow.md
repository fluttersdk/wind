# Overflow

Utilities for controlling how an element handles content that is too large for the container.

<x-preview path="effects/overflow_basic" size="lg" source="example/lib/pages/effects/overflow_basic.dart"></x-preview>

## General Overflow

### overflow-visible

Allow content to overflow outside container bounds (default):

```dart
WDiv(
  className: 'overflow-visible w-20 h-20 bg-blue-500 rounded-lg',
  child: WDiv(
    className: 'w-32 h-32 bg-blue-300 rounded-lg flex items-center justify-center',
    child: WText('120x120', className: 'text-blue-900 text-xs font-mono'),
  ),
)
```

### overflow-hidden

Clip content that overflows the container:

```dart
WDiv(
  className: 'overflow-hidden w-20 h-20 bg-red-500 rounded-lg',
  child: WDiv(
    className: 'w-32 h-32 bg-red-300 rounded-lg flex items-center justify-center',
    child: WText('120x120', className: 'text-red-900 text-xs font-mono'),
  ),
)
```

### overflow-scroll

Enable scrolling for overflow content:

```dart
WDiv(
  className: 'overflow-scroll w-24 h-24 bg-green-500 rounded-lg',
  child: WDiv(
    className: 'w-48 h-48 bg-green-300 rounded-lg flex items-center justify-center',
    child: WText('192x192', className: 'text-green-900 text-xs font-mono'),
  ),
)
```

### overflow-auto

Auto scrolling (scroll only when needed):

```dart
WDiv(
  className: 'overflow-auto w-24 h-24 bg-amber-500 rounded-lg',
  child: WDiv(
    className: 'w-48 h-48 bg-amber-300 rounded-lg flex items-center justify-center',
    child: WText('192x192', className: 'text-amber-900 text-xs font-mono'),
  ),
)
```

| Class | Behavior |
| :--- | :--- |
| `overflow-visible` | Allow content to overflow (default) |
| `overflow-hidden` | Clip content using `ClipRect` |
| `overflow-scroll` | Enable scrolling via `SingleChildScrollView` |
| `overflow-auto` | Auto scrolling when content overflows |

## Directional Overflow

Control overflow for specific axes.

<x-preview path="effects/overflow_directional" size="lg" source="example/lib/pages/effects/overflow_directional.dart"></x-preview>

### overflow-x-scroll

Horizontal scroll only:

```dart
WDiv(
  className: 'overflow-x-scroll w-48 h-20 bg-purple-500 rounded-lg',
  child: WDiv(
    className: 'w-96 h-20 bg-purple-300 flex items-center justify-center',
    child: WText('Wide content (384px)', className: 'text-purple-900 font-mono text-sm'),
  ),
)
```

### overflow-y-scroll

Vertical scroll only:

```dart
WDiv(
  className: 'overflow-y-scroll w-48 h-24 bg-teal-500 rounded-lg',
  child: WDiv(
    className: 'w-48 h-64 bg-teal-300 flex items-center justify-center',
    child: WText('Tall content (256px)', className: 'text-teal-900 font-mono text-sm'),
  ),
)
```

### overflow-x-hidden / overflow-y-hidden

Clip overflow on specific axis:

```dart
// Clip horizontal overflow
WDiv(
  className: 'overflow-x-hidden w-48 h-20 bg-orange-500 rounded-lg',
  child: WDiv(className: 'w-96 h-20 bg-orange-300'),
)

// Clip vertical overflow
WDiv(
  className: 'overflow-y-hidden w-48 h-24 bg-pink-500 rounded-lg',
  child: WDiv(className: 'w-48 h-64 bg-pink-300'),
)
```

## All Overflow Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **General** | `overflow-visible` | Allow overflow (default) |
| **General** | `overflow-hidden` | Clip overflow with ClipRect |
| **General** | `overflow-scroll` | Always scrollable (both axes) |
| **General** | `overflow-auto` | Scroll when content overflows |
| **X-Axis** | `overflow-x-hidden` | Clip horizontal overflow |
| **X-Axis** | `overflow-x-scroll` | Horizontal scroll |
| **X-Axis** | `overflow-x-auto` | Horizontal auto scroll |
| **Y-Axis** | `overflow-y-hidden` | Clip vertical overflow |
| **Y-Axis** | `overflow-y-scroll` | Vertical scroll |
| **Y-Axis** | `overflow-y-auto` | Vertical auto scroll |

## Related Documentation

- [Sizing](../sizing/sizing.md) - Width and height utilities
- [Display](./display.md) - Display utilities
