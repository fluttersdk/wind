# WBreakpoint

Declarative breakpoint-keyed builder for rendering different widget trees per responsive breakpoint. An **escape hatch** for cases where the widget structure genuinely differs between breakpoints — reach for className prefixes first.

- [Basic Usage](#basic-usage)
- [When to Use](#when-to-use)
- [Constructor](#constructor)
- [Props](#props)
- [Resolution Semantics](#resolution-semantics)
- [Custom Breakpoints](#custom-breakpoints)
- [Nested Theme Overrides](#nested-theme-overrides)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/w_breakpoint" size="md" source="example/lib/pages/widgets/w_breakpoint.dart"></x-preview>

```dart
WBreakpoint(
  base: (ctx) => const MobileLayout(),
  md: (ctx) => const TabletLayout(),
  lg: (ctx) => const DesktopLayout(),
)
```

<a name="basic-usage"></a>
## Basic Usage

`WBreakpoint` picks one widget tree per breakpoint using Wind's own breakpoint resolution. `base` is required; other builders are optional fallbacks.

```dart
WBreakpoint(
  base: (ctx) => WDiv(
    className: 'flex flex-col gap-2',
    children: [/* stacked cards */],
  ),
  md: (ctx) => WDiv(
    className: 'grid grid-cols-3 gap-4',
    children: [/* grid cards */],
  ),
)
```

<a name="when-to-use"></a>
## When to Use

Prefer className-first patterns. `WBreakpoint` is a last resort:

| Need | Prefer |
|:-----|:-------|
| Swap styles per breakpoint | `sm:flex-row`, `md:gap-8` |
| Swap visibility per breakpoint | `hidden sm:block` / `block sm:hidden` |
| Reorder flex children | `order-2 md:order-1` |
| Render different widget **types** | `WBreakpoint` |
| Render different child **counts** | `WBreakpoint` |

If your two branches differ only in className, use prefixes instead — you'll get less code and a cleaner diff.

<a name="constructor"></a>
## Constructor

```dart
const WBreakpoint({
  Key? key,
  required WidgetBuilder base,
  WidgetBuilder? sm,
  WidgetBuilder? md,
  WidgetBuilder? lg,
  WidgetBuilder? xl,
  WidgetBuilder? xxl,
  Map<String, WidgetBuilder> custom = const {},
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `base` | `WidgetBuilder` | **Required** | Fallback builder when no higher breakpoint matches. |
| `sm` | `WidgetBuilder?` | `null` | Builder for `sm` breakpoint (default min width 640). |
| `md` | `WidgetBuilder?` | `null` | Builder for `md` breakpoint (default min width 768). |
| `lg` | `WidgetBuilder?` | `null` | Builder for `lg` breakpoint (default min width 1024). |
| `xl` | `WidgetBuilder?` | `null` | Builder for `xl` breakpoint (default min width 1280). |
| `xxl` | `WidgetBuilder?` | `null` | Builder for `2xl` breakpoint (default min width 1536). |
| `custom` | `Map<String, WidgetBuilder>` | `{}` | Builders for custom breakpoint keys defined in `WindThemeData.screens`. |

<a name="resolution-semantics"></a>
## Resolution Semantics

1. Read the active breakpoint from the `WindContext`.
2. Collect all breakpoints defined in `WindThemeData.screens` that are at or below the active width.
3. Sort them descending and pick the first one that has a builder.
4. Fall back to `base` if nothing matches.

Given default screens and width `1200` (active = `lg`):

```dart
WBreakpoint(
  base: (_) => A(),
  sm: (_) => B(),
  md: (_) => C(),
)
// Resolution walks lg → md → sm. md has a builder → renders C().
```

<a name="custom-breakpoints"></a>
## Custom Breakpoints

Define your own screen in `WindThemeData.screens` and drive `WBreakpoint` through the `custom` map:

```dart
WindTheme(
  data: WindThemeData().copyWith(
    screens: const {
      'sm': 640,
      'md': 768,
      'tablet': 900, // custom
      'lg': 1024,
      'xl': 1280,
      '2xl': 1536,
    },
  ),
  child: WBreakpoint(
    base: (_) => const MobileTable(),
    custom: {'tablet': (_) => const TabletTable()},
    lg: (_) => const DesktopTable(),
  ),
)
```

Custom keys participate in the same descending resolution as built-ins.

<a name="nested-theme-overrides"></a>
## Nested Theme Overrides

`WBreakpoint` reads through any `WindTheme` ancestor, so a nested `WindTheme` override with its own `screens` map applies inside that subtree. Useful for design-system playgrounds and test harnesses.

<a name="related-documentation"></a>
## Related Documentation

- [Responsive Design](../layout/responsive.md)
- [Flexbox & Layout](../layout/flexbox.md)
- [WindTheme](../theme/wind-theme.md)
