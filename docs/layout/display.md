# Display

Utilities for controlling how elements are displayed, positioned, and their visibility.

<x-preview path="layout/display" size="lg" source="example/lib/pages/layout/display.dart"></x-preview>

## Display Types

### block

Standard box model layout (default for `WDiv`):

```dart
WDiv(
  className: 'block p-4 bg-blue-500 rounded-lg',
  child: WText(
    'block',
    className: 'text-white font-mono text-sm',
  ),
)
```

### flex

Flexbox layout - arrange children in a row or column:

```dart
WDiv(
  className: 'flex gap-2 p-4 bg-emerald-500 rounded-lg',
  children: [
    WDiv(className: 'w-10 h-10 bg-white/30 rounded-lg'),
    WDiv(className: 'w-10 h-10 bg-white/30 rounded-lg'),
    WDiv(className: 'w-10 h-10 bg-white/30 rounded-lg'),
  ],
)
```

### grid

Grid layout - arrange children in columns and rows:

```dart
WDiv(
  className: 'grid grid-cols-3 gap-2 p-4 bg-violet-500 rounded-lg',
  children: [
    WDiv(className: 'h-10 bg-white/30 rounded-lg'),
    WDiv(className: 'h-10 bg-white/30 rounded-lg'),
    WDiv(className: 'h-10 bg-white/30 rounded-lg'),
    WDiv(className: 'h-10 bg-white/30 rounded-lg'),
    WDiv(className: 'h-10 bg-white/30 rounded-lg'),
    WDiv(className: 'h-10 bg-white/30 rounded-lg'),
  ],
)
```

| Class | Description |
| :--- | :--- |
| `block` | Standard box model (default) |
| `flex` | Flexbox layout |
| `grid` | Grid layout |

## Visibility

### hidden

Remove element from layout completely:

```dart
WDiv(
  className: 'hidden',
  child: WText('Not rendered'),
)
```

### invisible

Hide element but preserve its layout space:

```dart
WDiv(
  className: 'invisible w-12 h-12 bg-amber-500',
  child: WText('Invisible'),
)
```

| Class | Description |
| :--- | :--- |
| `hidden` | Remove from layout (not rendered) |
| `opacity-0` | Hide visually but maintain space |

### opacity-0 (Preserve Layout Space)

Use `opacity-0` to hide an element while keeping its layout space:

```dart
WDiv(
  className: 'opacity-0 w-12 h-12 bg-amber-500 rounded-lg',
  child: WText('Hidden but takes space'),
)
```

## Responsive Display

Show or hide elements at specific breakpoints using responsive prefixes like `md:`, `lg:`.

<x-preview path="layout/responsive_display" size="lg" source="example/lib/pages/layout/responsive_display.dart"></x-preview>

```dart
WDiv(
  className: 'flex flex-col gap-2',
  children: [
    // Visible only on mobile (hidden on md+)
    WDiv(
      className: 'md:hidden p-3 bg-red-500 rounded-lg',
      child: WText(
        'Visible on mobile only',
        className: 'text-white text-sm',
      ),
    ),
    // Hidden on mobile, visible on md+
    WDiv(
      className: 'hidden md:block p-3 bg-green-500 rounded-lg',
      child: WText(
        'Visible on md+ only',
        className: 'text-white text-sm',
      ),
    ),
  ],
)
```

Control visibility at specific breakpoints:

### Common Patterns

| Pattern | Description |
| :--- | :--- |
| `md:hidden` | Hide on medium screens and up |
| `hidden md:block` | Show only on medium screens and up |
| `hidden md:flex` | Show as flex on medium screens and up |
| `lg:hidden` | Hide on large screens and up |

## Related Documentation

- [Flexbox](./flexbox.md) - Detailed flex layout utilities
- [Grid](./grid.md) - Detailed grid layout utilities
- [Responsive Design](../core-concepts/responsive-design.md) - Breakpoints and responsive patterns
