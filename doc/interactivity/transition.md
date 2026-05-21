# Transitions

Utilities for controlling the duration and easing of state transitions in Wind.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
  - [Duration](#duration)
  - [Easing](#easing)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

Transitions allow you to change property values smoothly over a given duration. In Wind, these are typically paired with state modifiers like `hover:`, `focus:`, or `active:`.

<x-preview path="interactivity/transition_basic" size="md" source="example/lib/pages/interactivity/transition_basic.dart"></x-preview>

```dart
// Smoothly transition background color on hover
WDiv(
  className: 'bg-blue-500 hover:bg-blue-700 duration-300 ease-in-out',
  child: WText('Hover Me', className: 'text-white'),
)
```

By adding `duration-200`, the background color shift happens over 200 milliseconds instead of snapping instantly.

<a name="quick-reference"></a>
## Quick Reference

### Duration
| Class | Value | Description |
|:------|:------|:------------|
| `duration-75` | 75ms | Very fast transition |
| `duration-100` | 100ms | Fast transition |
| `duration-150` | 150ms | |
| `duration-200` | 200ms | Standard UI transition |
| `duration-300` | 300ms | |
| `duration-500` | 500ms | Noticeable transition |
| `duration-700` | 700ms | |
| `duration-1000` | 1000ms | Slow transition |

### Easing (Timing Function)
| Class | Value | Description |
|:------|:------|:------------|
| `ease-linear` | `Curves.linear` | Constant speed |
| `ease-in` | `Curves.easeIn` | Starts slow, ends fast |
| `ease-out` | `Curves.easeOut` | Starts fast, ends slow |
| `ease-in-out` | `Curves.easeInOut` | Slow start and end |

<a name="variants"></a>
## Variants

<a name="duration"></a>
### Duration

Use the `duration-{ms}` utility to set the length of the transition animation.

```dart
WDiv(className: 'duration-500 ...')
```

<a name="easing"></a>
### Easing

Control the rate of change with `ease-{curve}` utilities. This defines the "feel" of the animation.

```dart
WDiv(className: 'ease-out duration-300 ...')
```

<a name="responsive-design"></a>
## Responsive Design

Apply different transition speeds or curves at different breakpoints using the standard responsive prefixes.

```dart
// Slow transition on desktop, fast on mobile
WDiv(className: 'duration-150 lg:duration-500')
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply different transition styles when the application is in dark mode.

```dart
WDiv(className: 'duration-200 dark:duration-500')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If the standard scale doesn't fit your specific animation needs, use bracket notation to provide a custom millisecond value.

```dart
WDiv(className: 'duration-[420ms] ease-[Curves.bounceOut]')
```

<a name="customizing-theme"></a>
## Customizing Theme

To extend or override the default transition scales, modify `WindThemeData` in your app configuration.

```dart
WindTheme(
  data: WindThemeData(
    transitionDurations: {
      'snappy': Duration(milliseconds: 50),
      'lazy': Duration(milliseconds: 2000),
    },
    transitionCurves: {
      'bounce': Curves.bounceOut,
    },
  ),
  child: MyApp(),
)
```

Usage: `duration-snappy`, `ease-bounce`.

<a name="related-documentation"></a>
## Related Documentation

- [Animation](./animation.md) - Explicit keyframe animations
- [Hover States](../core-concepts/state-management.md) - Handling interactions
- [Opacity](../styling/opacity.md) - Fade transitions
