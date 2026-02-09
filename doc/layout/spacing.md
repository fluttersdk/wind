# Spacing

Utilities for controlling the padding and margin of elements.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="spacing/padding_margin_basic" size="md" source="example/lib/pages/spacing/padding_margin_basic.dart"></x-preview>

```dart
// Adds 16px padding inside, 16px margin outside
WDiv(className: 'p-4 m-4 bg-white')
```

## Basic Usage

Control the spacing of an element using the `p-{size}` (padding) and `m-{size}` (margin) utilities.

### Padding

Padding adds space **inside** the element's boundary.

```dart
// Add padding to all sides
WDiv(className: 'p-6 bg-blue-100', child: WText('Padding'))
```

### Margin

Margin adds space **outside** the element's boundary.

```dart
// Add margin to all sides
WDiv(className: 'm-4 bg-red-100', child: WText('Margin'))
```

## Quick Reference

The default spacing scale is based on a **4px** unit (`baseSpacingUnit: 4.0`).

| Class | Value (Default) | Description |
|:------|:----------------|:------------|
| `p-0` / `m-0` | 0px | No spacing |
| `p-1` / `m-1` | 4px | Tiny spacing |
| `p-2` / `m-2` | 8px | Small spacing |
| `p-4` / `m-4` | 16px | Normal spacing |
| `p-8` / `m-8` | 32px | Large spacing |
| `p-16` / `m-16` | 64px | Extra large spacing |
| `px-{n}` / `mx-{n}` | - | Horizontal (Left + Right) |
| `py-{n}` / `my-{n}` | - | Vertical (Top + Bottom) |
| `pt-{n}` / `mt-{n}` | - | Top only |
| `pr-{n}` / `mr-{n}` | - | Right only |
| `pb-{n}` / `mb-{n}` | - | Bottom only |
| `pl-{n}` / `ml-{n}` | - | Left only |

## Variants

### Directional Spacing

Target specific sides or axes using direction prefixes.

<x-preview path="spacing/directional" size="md" source="example/lib/pages/spacing/directional.dart"></x-preview>

```dart
// Horizontal padding (Left + Right)
WDiv(className: 'px-4 bg-green-100')

// Vertical margin (Top + Bottom)
WDiv(className: 'my-6 bg-yellow-100')

// Top padding only
WDiv(className: 'pt-8 bg-purple-100')
```

### Horizontal Centering

Use `mx-auto` to center a container horizontally. This sets the left and right margins to align the element within its parent.

> [!NOTE]
> `mx-auto` only works when the element has a defined width less than its parent. Explicit `mx-{value}` classes (like `mx-0`) will override `mx-auto`.

```dart
WDiv(
  className: 'mx-auto w-32 bg-blue-500',
  child: WText('Centered'),
)
```

## Responsive Design

Apply different spacing at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
// p-4 on mobile, p-8 on medium screens, p-12 on large screens
WDiv(className: 'p-4 md:p-8 lg:p-12')
```

## Dark Mode

Use the `dark:` prefix to apply different spacing in dark mode.

```dart
WDiv(className: 'p-4 dark:p-6')
```

## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply exact pixel values.

> [!WARNING]
> Wind parsers for padding and margin currently support **pixels** (`[10px]`, `[10]`) but do NOT support percentages (`[10%]`).

```dart
// Exact 13px padding
WDiv(className: 'p-[13px]')

// Exact 50px top margin
WDiv(className: 'mt-[50px]')
```

## Customizing Theme

To extend or override the default spacing scale, modify the `WindThemeData` in your app root.

The `baseSpacingUnit` controls the multiplier for all spacing utilities (`p-`, `m-`, `gap-`, `w-`, `h-`).

```dart
WindThemeData(
  baseSpacingUnit: 8.0, // Sets 'p-1' to 8px, 'p-4' to 32px
)
```

## Related Documentation

- [Sizing](./sizing.md)
- [Flexbox](./flexbox.md) (Gap utilities)
- [Grid](./grid.md) (Gap utilities)
