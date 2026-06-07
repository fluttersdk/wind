# WindAnimationWrapper

`WindAnimationWrapper` wraps any widget in a looping animation driven by `WindAnimationType`: spin, ping, pulse, or bounce. It is the
underlying engine behind `animate-*` utility classes; you can also use it directly when you need programmatic control over the type,
duration, or curve.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Animation Types](#animation-types)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="widgets/wind_animation_wrapper_basic" size="md" source="example/lib/pages/widgets/wind_animation_wrapper_basic.dart"></x-preview>

```dart
WindAnimationWrapper(
  animationType: WindAnimationType.spin,
  child: WIcon(Icons.refresh_outlined, className: 'text-blue-500 dark:text-blue-400 text-3xl'),
)
```

Use `animate-*` className tokens for most cases. Reach for `WindAnimationWrapper` directly when you need to vary duration or curve at
runtime, or when wrapping a widget that does not accept a `className` prop.

<a name="constructor"></a>
## Constructor

```dart
const WindAnimationWrapper({
  Key? key,
  required Widget child,
  required WindAnimationType animationType,
  Duration duration = const Duration(milliseconds: 1000),
  Curve curve = Curves.linear,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `child` | `Widget` | **Required** | The widget to animate. |
| `animationType` | `WindAnimationType` | **Required** | The animation style. One of `spin`, `ping`, `pulse`, `bounce`, or `none`. |
| `duration` | `Duration` | `Duration(milliseconds: 1000)` | Full cycle length. Applies to all animation types. |
| `curve` | `Curve` | `Curves.linear` | Easing curve for the animation controller. Note: `ping` and `pulse` apply their own `CurvedAnimation` internally; `curve` primarily affects `spin` and `bounce`. |

<a name="animation-types"></a>
## Animation Types

| `WindAnimationType` | Effect | Typical use |
|:--------------------|:-------|:------------|
| `spin` | Continuous 360-degree rotation. | Loading spinners, refresh icons. |
| `ping` | Scale from 1.0 to 1.5 with matching opacity fade, repeating. | Notification badges, live indicators. |
| `pulse` | Opacity oscillates from 1.0 to 0.5 and back. | Skeleton placeholders, content loading. |
| `bounce` | Vertical offset oscillates between 0 and -5 px (20 * 0.25). | Scroll indicators, attention grabbers. |
| `none` | No animation; returns `child` unchanged. | Default state; safe to pass unconditionally. |

<a name="styling-examples"></a>
## Styling Examples

### Custom duration

Slow a pulse down to a 2-second cycle for a calmer skeleton effect:

```dart
WindAnimationWrapper(
  animationType: WindAnimationType.pulse,
  duration: const Duration(milliseconds: 2000),
  child: WDiv(
    className: 'h-4 w-48 bg-gray-200 dark:bg-gray-700 rounded',
  ),
)
```

### Ping badge

Combine with `Stack` + `Positioned` for a notification badge:

```dart
Stack(
  children: [
    WIcon(Icons.notifications_outlined, className: 'text-gray-600 dark:text-gray-300 text-3xl'),
    Positioned(
      right: 2,
      top: 2,
      child: WindAnimationWrapper(
        animationType: WindAnimationType.ping,
        child: WDiv(className: 'w-3 h-3 bg-red-500 dark:bg-red-400 rounded-full'),
      ),
    ),
  ],
)
```

### Spin with fast duration

Reduce the cycle time for a snappier loading indicator:

```dart
WindAnimationWrapper(
  animationType: WindAnimationType.spin,
  duration: const Duration(milliseconds: 600),
  child: WIcon(Icons.sync_outlined, className: 'text-indigo-500 dark:text-indigo-400 text-2xl'),
)
```

### Via className (most common)

For typical use the `animate-*` className token is the shorter path:

```dart
WIcon(
  Icons.refresh_outlined,
  className: 'text-blue-500 dark:text-blue-400 text-2xl animate-spin',
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WDiv](./w-div.md): Universal container; supports `animate-*` via `className`.
- [WIcon](./w-icon.md): Icon widget; wraps automatically in `WindAnimationWrapper` when className contains `animate-*`.
- [Animation](../interactivity/animation.md): Full reference for the `animate-*` tokens.
- [Transition](../interactivity/transition.md): Reference for `transition-*`, `duration-*`, and `ease-*` tokens.
