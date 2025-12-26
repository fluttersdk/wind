# WImage

A utility-first image component with HTML `<img>` semantics.

## Basic Usage

```dart
WImage(
  src: 'https://example.com/image.jpg',
  alt: 'Description',
  className: 'w-32 h-32 rounded-lg object-cover',
)
```

<x-preview path="images/image_basic" size="md"></x-preview>

---

## Asset Images

Use `asset://` prefix for local assets:

```dart
WImage(
  src: 'asset://assets/images/logo.png',
  className: 'w-24 h-24',
)
```

---

## Object Fit

| Class | BoxFit |
|-------|--------|
| `object-cover` | `BoxFit.cover` (default) |
| `object-contain` | `BoxFit.contain` |
| `object-fill` | `BoxFit.fill` |
| `object-none` | `BoxFit.none` |
| `object-scale-down` | `BoxFit.scaleDown` |

```dart
WImage(src: '...', className: 'w-24 h-24 object-contain')
```

---

## Aspect Ratio

```dart
WImage(src: '...', className: 'w-32 aspect-video object-cover')  // 16:9
WImage(src: '...', className: 'w-32 aspect-square object-cover') // 1:1
WImage(src: '...', className: 'w-32 aspect-[4/3] object-cover')  // 4:3
```

---

## Rounded Corners

```dart
WImage(src: '...', className: 'w-24 h-24 rounded-full object-cover')
WImage(src: '...', className: 'w-24 h-24 rounded-lg object-cover')
```

---

## Placeholder & Error

```dart
WImage(
  src: 'https://example.com/image.jpg',
  placeholder: CircularProgressIndicator(),
  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
)
```

---

## Props

| Prop | Type | Description |
|------|------|-------------|
| `src` | `String` | Image URL or `asset://` path |
| `alt` | `String?` | Semantic label |
| `className` | `String?` | Utility classes |
| `placeholder` | `Widget?` | Loading widget |
| `errorBuilder` | `ImageErrorBuilder?` | Error handler |
| `loadingBuilder` | `ImageLoadingBuilder?` | Loading handler |

---

## Supported Utility Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-{n}`, `h-{n}` | Dimensions |
| **Fit** | `object-cover`, `object-contain`, `object-fill` | BoxFit mode |
| **Aspect** | `aspect-video`, `aspect-square`, `aspect-[ratio]` | Aspect Ratio |
| **Border** | `rounded-{size}`, `border` | Corner radius & borders |
| **Effects** | `opacity-{n}`, `shadow` | Opacity & Shadow |
