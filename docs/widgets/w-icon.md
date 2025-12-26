# WIcon

A utility-first icon component with className support and parent style inheritance.

## Basic Usage

```dart
WIcon(Icons.star, className: 'text-yellow-500 text-2xl')
```

<x-preview path="icons/icon_basic" size="md"></x-preview>

---

## Text Size Classes

Use `text-{size}` to set icon size (same as text sizing):

```dart
WIcon(Icons.home, className: 'text-gray-600 text-sm')   // 14px
WIcon(Icons.home, className: 'text-gray-600 text-base') // 16px
WIcon(Icons.home, className: 'text-gray-600 text-lg')   // 18px
WIcon(Icons.home, className: 'text-gray-600 text-xl')   // 20px
WIcon(Icons.home, className: 'text-gray-600 text-2xl')  // 24px
```

---

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

---

## Color

```dart
WIcon(Icons.star, className: 'text-yellow-500 text-2xl')
WIcon(Icons.favorite, className: 'text-[#ff5500] text-2xl')
```

---

## Explicit Pixel Size

```dart
WIcon(Icons.star, className: 'text-yellow-500 w-8 h-8')  // 32px
```

---

## Opacity

```dart
WIcon(Icons.circle, className: 'text-blue-500 text-2xl opacity-50')
```

---

## Props

| Prop | Type | Description |
|------|------|-------------|
| `icon` | `IconData` | The icon to display |
| `className` | `String?` | Utility classes |
| `states` | `Set<String>?` | Active states |
| `semanticLabel` | `String?` | Accessibility label |

---

## Supported Utility Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Color** | `text-{color}` | Icon color |
| **Size** | `text-{size}` | Sizing (font-relative) |
| **Dimensions** | `w-{n}`, `h-{n}` | Sizing (explicit pixels) |
| **Effects** | `opacity-{n}` | Opacity |
