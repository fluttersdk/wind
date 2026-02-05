# WIcon

A utility-first icon component with className support and parent style inheritance.

<x-preview path="icons/icon_basic" size="md" source="example/lib/pages/icons/icon_basic.dart"></x-preview>

## Basic Usage

Display icons with color and size classes:

```dart
WIcon(Icons.star, className: 'text-yellow-500 text-2xl')
```

## Text Size Classes

Use `text-{size}` to set icon size (same as text sizing):

```dart
WIcon(Icons.home, className: 'text-gray-600 text-sm')   // 14px
WIcon(Icons.home, className: 'text-gray-600 text-base') // 16px
WIcon(Icons.home, className: 'text-gray-600 text-lg')   // 18px
WIcon(Icons.home, className: 'text-gray-600 text-xl')   // 20px
WIcon(Icons.home, className: 'text-gray-600 text-2xl')  // 24px
```

## Pixel Size

For exact dimensions, use `w-{n}` and `h-{n}`:

```dart
WIcon(Icons.star, className: 'text-yellow-500 w-8 h-8')  // 32px
```

## Parent Inheritance

Icons inherit color and size from parent's `DefaultTextStyle` (like HTML):

```dart
WDiv(
  className: 'text-red-500 text-xl',
  children: [
    WIcon(Icons.favorite), // Inherits red + xl size
    WText('Liked'),        // Same styling
  ],
)
```

## Animations

Add animations with `animate-*` classes:

```dart
WIcon(Icons.refresh, className: 'text-blue-500 text-2xl animate-spin')
WIcon(Icons.circle, className: 'text-gray-400 text-2xl animate-pulse')
WIcon(Icons.arrow_downward, className: 'text-green-500 text-2xl animate-bounce')
```

## Opacity

Control transparency with `opacity-{n}`:

```dart
WIcon(Icons.circle, className: 'text-blue-500 text-2xl opacity-50')
```

## Props

| Prop | Type | Description |
| :--- | :--- | :--- |
| `icon` | `IconData` | The icon to display (required) |
| `className` | `String?` | Utility classes |
| `states` | `Set<String>?` | Active states for dynamic styling |
| `semanticLabel` | `String?` | Accessibility label |
| `textDirection` | `TextDirection?` | Text direction |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Color** | `text-{color}` | Icon color |
| **Text Size** | `text-{size}` | Font-relative sizing |
| **Pixel Size** | `w-{n}`, `h-{n}` | Explicit dimensions |
| **Opacity** | `opacity-{n}` | Opacity (0-100) |
| **Animation** | `animate-spin`, `animate-pulse`, `animate-bounce`, `animate-ping` | Icon animations |
| **Transition** | `duration-{ms}`, `ease-{curve}` | Animated opacity transitions |

> **Size Priority:** `w-{n}` / `h-{n}` > `text-{size}` > inherited from parent

> **Color Priority:** `text-{color}` > inherited from parent

## Related Documentation

- [WSvg](./w-svg.md) - SVG component with similar inheritance
- [WText](./w-text.md) - Text component
- [Animation](../interactivity/animation.md) - Animation utilities
