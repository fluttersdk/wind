# Responsive design with Wind UI

Wind's responsive system has three layers: breakpoint prefixes (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`), platform prefixes (`ios:`, `android:`, `web:`, `mobile:`), and the `WBreakpoint` widget for when WIDGET STRUCTURE — not just styling — must change per breakpoint.

## Breakpoint values (defaults)

| Prefix | Min viewport width |
|--------|-------------------|
| (none) | base — applies always |
| `sm:` | 640 px |
| `md:` | 768 px |
| `lg:` | 1024 px |
| `xl:` | 1280 px |
| `2xl:` | 1536 px |

Mobile-first cascade: `text-sm md:text-base lg:text-lg` reads as "small font on mobile (< md), base font from md+, large from lg+".

Override defaults in `WindThemeData(screens: {...})`. Custom screens (e.g., `'tablet': 600`) work as className prefixes (`tablet:flex-row`) and as `WBreakpoint.custom['tablet']` keys.

## How the cascade resolves

The parser computes the current breakpoint set: `{base, sm, md, ...}` up to the largest one whose pixel width ≤ current viewport. A class with a `<bp>:` prefix activates if the prefix is in the active set.

| Viewport width | Active set | `md:bg-blue-500` applies? |
|----------------|-----------|---------------------------|
| 480 px | `{base}` | No (md not in set) |
| 720 px | `{base, sm}` | No |
| 800 px | `{base, sm, md}` | Yes |
| 1100 px | `{base, sm, md, lg}` | Yes |
| 1400 px | `{base, sm, md, lg, xl}` | Yes |

## Common patterns

### Hide on mobile, show desktop

```dart
WDiv(className: 'hidden md:flex', children: [/* sidebar */])
```

### Stack on mobile, side-by-side on desktop

```dart
WDiv(className: 'flex flex-col md:flex-row gap-4', children: [left, right])
```

### Grid columns scale with viewport

```dart
WDiv(className: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4', children: cards)
```

### Font size scale

```dart
WText('Title', className: 'text-xl md:text-2xl lg:text-3xl font-bold')
```

### Padding scale

```dart
WDiv(className: 'p-4 md:p-6 lg:p-8', child: content)
```

### Combined with state + dark

```dart
WButton(
  className: '''
    bg-blue-600 dark:bg-blue-700
    md:bg-indigo-600 dark:md:bg-indigo-700
    hover:bg-blue-700 dark:hover:bg-blue-600
    md:hover:bg-indigo-700 dark:md:hover:bg-indigo-600
    px-4 py-2 md:px-6 md:py-3 rounded-lg
    text-sm md:text-base text-white
  ''',
  onTap: _onPress,
  child: const WText('Click'),
);
```

Prefix order within a single class is arbitrary; ALL prefixes must match. `md:hover:bg-blue-500` and `hover:md:bg-blue-500` both activate on md+ hover.

## Platform prefixes

Override styling per OS:

| Prefix | Active when |
|--------|-------------|
| `ios:` | `WindPlatformService.platform == 'ios'` |
| `android:` | `WindPlatformService.platform == 'android'` |
| `web:` | `WindPlatformService.platform == 'web'` |
| `mobile:` | iOS OR Android (convenience shorthand) |

### Example: iOS gets larger rounded corners

```dart
WDiv(className: 'rounded-md ios:rounded-2xl bg-white dark:bg-gray-800 p-4', child: content)
```

### iOS-specific feedback

```dart
WButton(
  className: '''
    bg-blue-600
    hover:bg-blue-700           // web/desktop hover
    ios:active:bg-blue-800      // iOS press-darken
    android:active:bg-blue-800
  ''',
  onTap: _tap,
  child: const WText('Tap'),
);
```

## `axis-min` / `axis-max` (Wind-only)

Tailwind has no equivalent. These control Flutter's `MainAxisSize` on flex containers.

| Token | Effect |
|-------|--------|
| `axis-min` | Container wraps tightly around content (default for Column/Row) |
| `axis-max` | Container fills the available main-axis space |

Example: a header that fills the row width even with a small icon child:

```dart
WDiv(
  className: 'flex flex-row axis-max items-center gap-2',
  children: [WIcon(Icons.menu_outlined), WText('Title')],
)
```

## `WBreakpoint` widget — when className isn't enough

Use `WBreakpoint` when the WIDGET TREE STRUCTURE — not just style — must change per breakpoint.

```dart
WBreakpoint(
  base: (ctx) => MobileNavigation(),     // < sm
  md: (ctx) => DesktopNavigation(),      // ≥ md (also covers lg, xl, 2xl since highest-match-wins)
);
```

`base` is required. The resolver picks the highest-matching builder ≤ active breakpoint: at `lg`, both `md` and `lg` builders are candidates if both are set; `lg` wins.

### Example: completely different mobile vs desktop chrome

```dart
WBreakpoint(
  base: (ctx) => Scaffold(
    appBar: AppBar(title: const Text('App')),
    drawer: const Drawer(child: NavMenu()),
    body: const HomeBody(),
  ),
  lg: (ctx) => Row(
    children: const [
      SizedBox(width: 240, child: NavSidebar()),
      Expanded(child: HomeBody()),
    ],
  ),
);
```

### Custom breakpoints

```dart
WindTheme(
  data: WindThemeData(screens: {'tablet': 600, 'desktop': 1024, 'wide': 1440}),
  builder: (ctx, ctrl) => MaterialApp(...),
);

// Then:
WBreakpoint(
  base: (ctx) => MobileView(),
  custom: const {
    'tablet': TabletView.builder,    // ≥ 600
    'wide': WideDesktopView.builder, // ≥ 1440
  },
);
```

## When to use what

| Need | Use |
|------|-----|
| Different padding, font size, color, gap, grid columns at different sizes | className prefixes (`md:`, `lg:`, etc.) |
| Different LAYOUT (flex direction, hidden vs visible) | className prefixes |
| Completely different widget COMPOSITION (drawer vs sidebar; mobile menu vs desktop nav) | `WBreakpoint` |
| Read current breakpoint programmatically (e.g., trigger a setState branch) | `context.wActiveBreakpoint` getter; or `MediaQuery.of(context).size.width` |
| OS-specific styling | platform prefixes (`ios:`, `android:`, `web:`, `mobile:`) |
| OS-specific structure | conditional `if (Theme.of(context).platform == TargetPlatform.iOS)` in Dart; platform-conditional widgets are not auto-styled |

## Reading current state programmatically

```dart
final breakpoint = context.wActiveBreakpoint;  // 'base' | 'sm' | 'md' | 'lg' | 'xl' | '2xl'
final isMobile = context.wIsMobile;            // bool: width < 768
final isTablet = context.wIsTablet;            // bool: 768 ≤ width < 1024
final isDesktop = context.wIsDesktop;          // bool: width ≥ 1024
final isDark = context.windIsDark;             // bool
```

Use these for `if` branches in Dart, e.g., to enable a side-panel widget structurally. For styling, use className prefixes — they re-resolve automatically on viewport change without rebuilding the widget.

## Anti-patterns

| Wrong | Right |
|-------|-------|
| Manual `if (width > 768) ... else ...` for styling | Use className prefixes — they cascade automatically |
| `WBreakpoint` for tiny style differences | Use prefixes; `WBreakpoint` is for structural shifts |
| String interpolation in className based on `MediaQuery.of(context).size.width` | Use className prefixes; interpolation breaks cache |
| Same breakpoint repeated for every property | Group properties: `md:flex-row md:gap-8 md:p-6` instead of declaring `md` once per property — the parser handles each token independently anyway |
| Custom screen names colliding with defaults (`'sm': 800` overrides Wind's default sm) | Pick distinct names (`'tablet': 800`) unless you really intend to redefine sm |
| Forgetting `lg:` after `md:` (assuming `md` covers larger sizes) | Cascade is mobile-first; `md:` activates from md onward (covers lg, xl, 2xl). Add `lg:` only when you want a DIFFERENT value at lg+ |
