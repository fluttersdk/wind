# WSvg

A utility-first SVG component with fill, stroke color, sizing, and parent inheritance (like WIcon).

## Basic Usage

```dart
WSvg(
  src: 'assets/icons/star.svg',
  className: 'fill-yellow-500 w-8 h-8',
)

// Inline SVG
WSvg.string('<svg>...</svg>', className: 'fill-red-500 text-xl')
```

<x-preview path="svg/svg_basic" size="md"></x-preview>

---

## Fill Color

```dart
WSvg(src: '...', className: 'fill-red-500 w-6 h-6')
WSvg(src: '...', className: 'fill-[#ff5500] w-6 h-6')
WSvg(src: '...', className: 'fill-blue-500/50 w-6 h-6')  // With opacity
```

---

## Stroke Color (Outlined Icons)

For SVGs with `stroke="currentColor"`:

```dart
WSvg(src: '...', className: 'stroke-blue-500 w-8 h-8')
WSvg(src: '...', className: 'stroke-red-500 w-8 h-8')
```

---

## Sizing

### Text Size Classes (like WIcon)
```dart
className: 'fill-gray-500 text-sm'   // 14px
className: 'fill-gray-500 text-lg'   // 18px
className: 'fill-gray-500 text-xl'   // 20px
className: 'fill-gray-500 text-2xl'  // 24px
```

### Pixel Size
```dart
className: 'fill-gray-500 w-8 h-8'   // 32px
className: 'fill-gray-500 w-12 h-12' // 48px
```

---

## Parent Inheritance (like WIcon)

Inherits color and size from parent's `DefaultTextStyle`:

```dart
WDiv(
  className: 'text-red-500 text-xl',
  children: [
    WSvg(src: 'heart.svg'),  // Inherits red + xl
    WText('Liked'),
  ],
)
```

---

## Props

| Prop | Type | Description |
|------|------|-------------|
| `src` | `String?` | Asset path |
| `svgString` | `String?` | Inline SVG via `WSvg.string()` |
| `className` | `String?` | Utility classes |
| `states` | `Set<String>?` | Active states |
| `semanticsLabel` | `String?` | Accessibility |

---

## Supported Classes

| Class | Effect |
|-------|--------|
| `fill-{color}` | Fill color |
| `fill-none` | No fill |
| `stroke-{color}` | Stroke color |
| `text-{size}` | Size (text sizing) |
| `w-{n}`, `h-{n}` | Size (pixels) |
| `opacity-{n}` | Opacity |
