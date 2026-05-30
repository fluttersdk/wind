# Border Width

Control the thickness of widget borders. The width value maps directly to pixels.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Side-Specific Borders](#side-specific-borders)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="borders/border_width" size="md" source="example/lib/pages/borders/border_width.dart"></x-preview>

```dart
WContainer(
  className: 'border-4 border-blue-500 p-4',
  child: WText('Thick Border', className: 'text-blue-500'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Use the `border-` prefix followed by a number to set the border width in pixels. Border widths are direct pixel values — no REM or Pixel Factor scaling is applied:

```dart
WContainer(
  className: 'border-2 border-gray-300 p-4 rounded-md',
  child: WText('Thin border'),
)

WContainer(
  className: 'border-4 border-blue-500 p-4 rounded-lg',
  child: WText('Thick border'),
)
```

<a name="quick-reference"></a>
## Quick Reference

### Syntax

```text
border-[width]
```

| Class | Width | Description |
|:------|:------|:------------|
| `border` | 1px | Default border (no number) |
| `border-1` | 1px | 1 pixel |
| `border-2` | 2px | 2 pixels |
| `border-4` | 4px | 4 pixels |
| `border-8` | 8px | 8 pixels |

Any integer value works: `border-3`, `border-6`, etc.

<a name="side-specific-borders"></a>
## Side-Specific Borders

Apply a border to individual sides using position suffixes:

| Class | Side |
|:------|:-----|
| `border-t-[width]` | Top |
| `border-b-[width]` | Bottom |
| `border-l-[width]` | Left |
| `border-r-[width]` | Right |
| `border-x-[width]` | Left and right |
| `border-y-[width]` | Top and bottom |

```dart
WContainer(
  className: 'border-b-2 border-gray-200 p-4',
  child: WText('Bottom border only'),
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation for non-standard widths. The value is used directly as pixels:

```text
border-[<value>]
```

```dart
WContainer(
  className: 'border-[6] border-red-400 p-4',
  child: WText('6px border'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Adjust border width at different breakpoints:

```dart
WContainer(
  className: 'border-1 md:border-2 lg:border-4 border-blue-500 p-4',
  child: WText('Responsive border width'),
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Border Color](border-color.md) — apply color to borders.
- [Border Radius](border-radius.md) — round the corners of widgets.
- [Padding](../spacing/padding.md) — inner spacing around widget content.
