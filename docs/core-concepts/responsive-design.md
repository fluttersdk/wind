# Responsive Design

Wind makes building responsive interfaces incredibly simple. Instead of using `LayoutBuilder` or `MediaQuery` manually, you can prefix any utility class with a breakpoint name.

## Breakpoints

Wind includes five default breakpoints, inspired by Tailwind CSS:

| Prefix | Minimum Width | CSS Equivalent |
| :--- | :--- | :--- |
| `sm` | 640px | `@media (min-width: 640px)` |
| `md` | 768px | `@media (min-width: 768px)` |
| `lg` | 1024px | `@media (min-width: 1024px)` |
| `xl` | 1280px | `@media (min-width: 1280px)` |
| `2xl` | 1536px | `@media (min-width: 1536px)` |

## Mobile-First

Wind uses a **mobile-first** system. This means valid utilities without a prefix apply to all screen sizes. Prefixed utilities only apply when the screen width is *at least* that size.

```dart
// Default: Green background (mobile)
// md (Tablets): Blue background
// lg (Desktops): Red background
WDiv(
  className: "w-full h-32 bg-green-500 md:bg-blue-500 lg:bg-red-500",
)
```

### Example: Responsive Grid

Here is a grid that starts with 1 column on mobile, moves to 2 columns on tablets, and 4 columns on desktops.

```dart
WDiv(
  className: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4",
  children: [
    // ... items
  ],
)
```

## Customizing Theme

### Breakpoints (Screens)

You can define your own breakpoints in `WindThemeData`:

```dart
WindThemeData(
  screens: {
    'tablet': 600,
    'desktop': 1200,
  },
)
```

Usage:
```dart
WDiv(className: "w-full tablet:w-1/2 desktop:w-1/3")
```

### Containers

If you often use container widths (e.g. for `max-w-screen-*` behavior if implemented, or programmatic `getSpacing()` usage):

```dart
WindThemeData(
  containers: {
    'sm': 600,
    'md': 720,
    'lg': 960,
    'xl': 1140,
  }
)
```

These values affect programmatic helpers like `wSpacing(context, 'lg')` if it resolves to container width.
