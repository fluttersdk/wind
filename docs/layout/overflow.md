# Overflow

Utilities for controlling how an element handles content that is too large for the container.

## Basic Usage

Control how content overflows using `overflow-{value}` utilities.

```dart
// Clip content that overflows
WDiv(className: "overflow-hidden w-32 h-32")

// Allow content to be visible outside the container
WDiv(className: "overflow-visible w-32 h-32")

// Enable scrolling for overflow content
WDiv(className: "overflow-scroll w-32 h-32")

// Auto scrolling (scroll only when needed)
WDiv(className: "overflow-auto w-32 h-32")
```

<x-preview path="effects/overflow_basic" size="md"></x-preview>

| Class | Behavior |
| :--- | :--- |
| `overflow-hidden` | Clip content using `ClipRect` |
| `overflow-visible` | Allow content to overflow (default) |
| `overflow-scroll` | Enable scrolling via `SingleChildScrollView` |
| `overflow-auto` | Auto scrolling when content overflows |

## Directional Overflow

Control overflow for specific axes.

```dart
// Horizontal scroll only
WDiv(className: "overflow-x-scroll")

// Vertical scroll only
WDiv(className: "overflow-y-scroll")

// Hide horizontal overflow
WDiv(className: "overflow-x-hidden")

// Hide vertical overflow
WDiv(className: "overflow-y-hidden")
```

<x-preview path="effects/overflow_directional" size="md"></x-preview>

## Supported Utility Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **General** | `overflow-{hidden/visible/scroll/auto}` | Overflow for both axes |
| **X-Axis** | `overflow-x-{hidden/visible/scroll/auto}` | Overflow for horizontal axis |
| **Y-Axis** | `overflow-y-{hidden/visible/scroll/auto}` | Overflow for vertical axis |
