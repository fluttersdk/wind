# Responsive Design

Wind makes building responsive interfaces incredibly simple. Instead of using `LayoutBuilder` or `MediaQuery` manually, you can prefix any utility class with a breakpoint name.

## Breakpoints

Wind includes five default breakpoints, inspired by Tailwind CSS:

| Prefix | Minimum Width | CSS Equivalent | Target Devices |
| :--- | :--- | :--- | :--- |
| *(none)* | 0px | - | Mobile (default) |
| `sm` | 640px | `@media (min-width: 640px)` | Large phones, small tablets |
| `md` | 768px | `@media (min-width: 768px)` | Tablets |
| `lg` | 1024px | `@media (min-width: 1024px)` | Laptops, small desktops |
| `xl` | 1280px | `@media (min-width: 1280px)` | Desktops |
| `2xl` | 1536px | `@media (min-width: 1536px)` | Large desktops |

## Mobile-First Approach

Wind uses a **mobile-first** breakpoint system. This means:

1. Unprefixed utilities apply to **all screen sizes**
2. Prefixed utilities apply at that breakpoint **and above**
3. Larger breakpoints override smaller ones

```dart
// Mobile: 1 column, green background
// Tablets (md+): 2 columns, blue background
// Desktops (lg+): 4 columns, red background
WDiv(
  className: '''
    grid grid-cols-1 bg-green-500
    md:grid-cols-2 md:bg-blue-500
    lg:grid-cols-4 lg:bg-red-500
  ''',
  children: [...],
)
```

> **Think "min-width"**: When you use `md:`, you're saying "at 768px and above". This is the opposite of max-width media queries.

## Common Patterns

### Responsive Layout

<x-preview path="responsive/layout" source="example/lib/pages/responsive/layout.dart"></x-preview>

A sidebar layout that stacks on mobile and shows side-by-side on larger screens:

```dart
WDiv(
  className: 'flex flex-col lg:flex-row min-h-screen',
  children: [
    // Sidebar: full width on mobile, fixed width on desktop
    WDiv(
      className: 'w-full lg:w-64 bg-slate-800 p-4',
      child: WText('Sidebar', className: 'text-white'),
    ),
    // Main content: takes remaining space
    WDiv(
      className: 'flex-1 p-6 bg-white',
      child: WText('Main Content'),
    ),
  ],
)
```

### Responsive Grid

<x-preview path="responsive/grid" source="example/lib/pages/responsive/grid.dart"></x-preview>

A product grid that adapts to screen size:

```dart
WDiv(
  className: '''
    grid gap-4
    grid-cols-1
    sm:grid-cols-2
    lg:grid-cols-3
    xl:grid-cols-4
  ''',
  children: List.generate(8, (index) {
    return WDiv(
      className: '''
        bg-blue-500 rounded-xl
        h-24 md:h-32
        flex items-center justify-center
      ''',
      child: WText(
        'Item ${index + 1}',
        className: 'text-white font-semibold',
      ),
    );
  }),
)
```

### Responsive Typography

<x-preview path="responsive/typography" source="example/lib/pages/responsive/typography.dart"></x-preview>

Text that scales with screen size:

```dart
// Heading
WText(
  'Heading',
  className: 'text-2xl md:text-4xl lg:text-5xl font-bold text-gray-800',
)

// Subheading
WText(
  'Subheading text that scales with screen size',
  className: 'text-base md:text-lg lg:text-xl text-gray-600',
)

// Body
WText(
  'Body text with responsive sizing.',
  className: 'text-sm md:text-base lg:text-lg text-gray-500',
)
```

### Responsive Spacing

<x-preview path="responsive/spacing" source="example/lib/pages/responsive/spacing.dart"></x-preview>

Padding, max-width and gap that adjust for different screens:

```dart
// Responsive Padding
WDiv(
  className: '''
    p-4 md:p-6 lg:p-8
    rounded-xl bg-violet-100
  ''',
  child: content,
)

// Responsive Max-Width
WDiv(
  className: '''
    w-full max-w-xs md:max-w-md lg:max-w-2xl
    p-4 rounded-xl
  ''',
  child: content,
)

// Responsive Gap
WDiv(
  className: 'flex flex-wrap gap-2 md:gap-4 lg:gap-6',
  children: items,
)
```

### Show/Hide Elements

<x-preview path="responsive/visibility" source="example/lib/pages/responsive/visibility.dart"></x-preview>

Control visibility at different breakpoints:

```dart
// Mobile only - hidden on md and above
WDiv(
  className: 'block md:hidden p-4 rounded-xl bg-red-500',
  child: WIcon(Icons.phone_android),
)

// Tablet only - visible on md, hidden on lg+
WDiv(
  className: 'hidden md:block lg:hidden p-4 rounded-xl bg-amber-500',
  child: WIcon(Icons.tablet_android),
)

// Desktop only - visible on lg and above
WDiv(
  className: 'hidden lg:block p-4 rounded-xl bg-emerald-500',
  child: WIcon(Icons.desktop_windows),
)
```

### Responsive Card Layout

<x-preview path="responsive/card" source="example/lib/pages/responsive/card.dart"></x-preview>

A card that changes layout based on screen size:

```dart
WDiv(
  className: '''
    flex flex-col md:flex-row
    bg-white rounded-xl shadow-lg overflow-hidden
  ''',
  children: [
    // Image: full width on mobile, fixed width on desktop
    WDiv(
      className: '''
        w-full md:w-48 h-48
        bg-gradient-to-br from-cyan-400 to-blue-500
        flex items-center justify-center
      ''',
      child: WIcon(Icons.image, className: 'text-white/50 text-5xl'),
    ),
    // Content
    WDiv(
      className: 'p-4 flex-1',
      children: [
        WText('Card Title', className: 'text-lg font-bold'),
        WText('Description...', className: 'text-gray-600 mt-2'),
      ],
    ),
  ],
)
```

## How It Works

Wind calculates the active breakpoint using `MediaQuery`:

```
Screen Width: 1100px

Breakpoint Check:
  sm (640px)  ✓ Active (1100 >= 640)
  md (768px)  ✓ Active (1100 >= 768)
  lg (1024px) ✓ Active (1100 >= 1024)
  xl (1280px) ✗ Not active (1100 < 1280)

Result: "lg" is the current breakpoint
Applied classes: base + sm + md + lg
```

When resolving classes, Wind applies all breakpoints up to and including the active one. This means `md:bg-blue-500` will apply when the screen is `md`, `lg`, `xl`, or `2xl`.

## Combining with Other Modifiers

Responsive prefixes can be combined with state and dark mode modifiers:

```dart
WButton(
  className: '''
    bg-blue-500 text-white p-3 rounded-lg
    hover:bg-blue-600
    md:p-4 md:text-lg
    md:hover:bg-blue-700
    dark:bg-slate-700
    dark:hover:bg-slate-600
    lg:dark:bg-slate-800
  ''',
  child: WText('Responsive Button'),
)
```

**Modifier order**: `breakpoint:state:utility` or `breakpoint:dark:utility`

## Platform-Specific Styles

Wind also supports platform prefixes:

```dart
WDiv(
  className: '''
    p-4
    mobile:p-2
    web:p-8
    ios:bg-gray-100
    android:bg-white
    macos:rounded-xl
  ''',
  child: content,
)
```

| Prefix | Applies To |
| :--- | :--- |
| `mobile` | iOS and Android |
| `web` | Web platform |
| `ios` | iOS only |
| `android` | Android only |
| `macos` | macOS only |
| `windows` | Windows only |
| `linux` | Linux only |

## Customizing Breakpoints

### Custom Breakpoints

Define your own breakpoints in `WindThemeData`:

```dart
WindTheme(
  data: WindThemeData(
    screens: {
      'tablet': 600,
      'laptop': 1024,
      'desktop': 1440,
      'ultrawide': 1920,
    },
  ),
  child: MyApp(),
)
```

Usage:

```dart
WDiv(
  className: '''
    grid-cols-1
    tablet:grid-cols-2
    laptop:grid-cols-3
    desktop:grid-cols-4
    ultrawide:grid-cols-6
  ''',
  children: [...],
)
```

### Extending Default Breakpoints

Add to the defaults without replacing them:

```dart
WindThemeData(
  screens: {
    // Wind will merge with defaults (sm, md, lg, xl, 2xl)
    '3xl': 1920,
    '4xl': 2560,
  },
)
```

### Container Sizes

Containers define max-width values for centered content:

```dart
WindThemeData(
  containers: {
    'sm': 640,
    'md': 768,
    'lg': 1024,
    'xl': 1280,
  },
)
```

These are used with `max-w-screen-*` utilities:

```dart
WDiv(
  className: 'max-w-screen-lg mx-auto px-4',
  child: content,
)
```

## Best Practices

### 1. Design Mobile-First

Start with mobile styles, then add complexity for larger screens:

```dart
// ✅ Good: Mobile-first
className: 'flex-col md:flex-row'

// ❌ Avoid: Desktop-first thinking
className: 'md:flex-col lg:flex-row xl:flex-row'
```

### 2. Use Semantic Breakpoints

Choose breakpoints based on your design, not device names:

```dart
// ✅ Good: Based on layout needs
className: 'grid-cols-1 md:grid-cols-2 xl:grid-cols-4'

// ❌ Avoid: Too many breakpoints for simple layouts
className: 'grid-cols-1 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-4'
```

### 3. Group Related Utilities

Keep responsive variants together for readability:

```dart
// ✅ Good: Grouped by property
className: '''
  p-4 md:p-6 lg:p-8
  text-sm md:text-base lg:text-lg
  gap-2 md:gap-4
'''

// ❌ Harder to read: Mixed
className: 'p-4 text-sm gap-2 md:p-6 md:text-base md:gap-4 lg:p-8 lg:text-lg'
```

### 4. Test All Breakpoints

Use Flutter DevTools or browser dev tools to test your responsive layouts at each breakpoint.

## Related Documentation

- [Utility-First Fundamentals](./utility-first.md) - Core concepts
- [Theming](./theming.md) - Theme configuration
- [State Management](./state-management.md) - Hover, focus, and custom states
- [Dark Mode](./dark-mode.md) - Dark mode support
