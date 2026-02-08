# Animation

Utilities for animating elements with CSS-like animation classes. Whether you're building a loading state or adding some life to your UI, Wind's animation utilities make it easy to drop in common motion patterns.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
  - [Spin](#spin)
  - [Ping](#ping)
  - [Pulse](#pulse)
  - [Bounce](#bounce)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<a name="preview"></a>
<!-- TODO: [EXAMPLE_NEEDED] path="interactivity/animation_basic" action="CREATE" -->
<!-- Description: Show basic examples of all animation variants (spin, ping, pulse, bounce) -->
<x-preview path="interactivity/animation_basic" size="md" source="example/lib/pages/interactivity/animation_basic.dart"></x-preview>

```dart
// Spinning loader
WDiv(className: 'animate-spin w-8 h-8 border-4 border-blue-500 rounded-full')

// Pulsing skeleton
WDiv(className: 'animate-pulse w-full h-4 bg-gray-200 rounded')
```

<a name="basic-usage"></a>
## Basic Usage

Use the `animate-{type}` classes to add pre-defined animations to any widget. These are great for loading indicators, notification badges, or grabbing a user's attention.

```dart
WIcon(
  Icons.refresh,
  className: 'animate-spin text-blue-600',
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Value | Description |
|:------|:------|:------------|
| `animate-none` | none | Removes any active animation |
| `animate-spin` | spin | Continuous 360-degree rotation |
| `animate-ping` | ping | Scaling outward like a radar ping |
| `animate-pulse` | pulse | Gentle opacity fade in/out |
| `animate-bounce` | bounce | Vertical bouncing motion |

<a name="variants"></a>
## Variants

### Spin

Use `animate-spin` for things like loading indicators. It provides a smooth, linear rotation. Let's look at a basic spinner:

```dart
WDiv(className: 'animate-spin w-6 h-6 border-2 border-t-transparent border-blue-500 rounded-full')
```

### Ping

The `animate-ping` utility makes an element scale and fade out, resembling a radar ping or notification alert. This is perfect for status indicators.

```dart
WDiv(className: 'relative flex h-3 w-3', children: [
  WDiv(className: 'animate-ping absolute inline-flex h-full w-full rounded-full bg-sky-400 opacity-75'),
  WDiv(className: 'relative inline-flex rounded-full h-3 w-3 bg-sky-500'),
])
```

### Pulse

Use `animate-pulse` to create a skeleton loading effect. It gently fades the opacity of the element, making it ideal for content that is still loading.

```dart
WDiv(className: 'animate-pulse flex space-x-4', children: [
  WDiv(className: 'rounded-full bg-slate-200 h-10 w-10'),
  WDiv(className: 'flex-1 space-y-6 py-1', children: [
    WDiv(className: 'h-2 bg-slate-200 rounded'),
    WDiv(className: 'grid grid-cols-3 gap-4', children: [
      WDiv(className: 'h-2 bg-slate-200 rounded col-span-2'),
      WDiv(className: 'h-2 bg-slate-200 rounded col-span-1'),
    ]),
  ]),
])
```

### Bounce

The `animate-bounce` utility is perfect for scroll indicators or call-to-action buttons that need a bit of personality.

```dart
WIcon(Icons.keyboard_arrow_down, className: 'animate-bounce text-slate-400')
```

<a name="responsive-design"></a>
## Responsive Design

You can enable or disable animations at specific breakpoints. For example, you might want to only animate an element on larger screens to keep the mobile experience "quiet".

```dart
WDiv(className: 'animate-none md:animate-spin')
```

<a name="dark-mode"></a>
## Dark Mode

Animations work seamlessly with dark mode. You'll typically just change the colors of the animated element when switching to dark mode.

```dart
WDiv(className: 'animate-pulse bg-gray-200 dark:bg-gray-700')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If the built-in animations don't quite fit, you can use arbitrary values to specify custom animation strings.

```dart
WDiv(className: 'animate-[wiggle_1s_ease-in-out_infinite]')
```

<a name="customizing-theme"></a>
## Customizing Theme

Want to add your own animations to the system? You can extend the `animations` map in your `WindThemeData`.

```dart
WindThemeData(
  animations: {
    'wiggle': WindAnimationType.bounce, // Map to existing logic or custom type
  },
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Transitions](./transition.md) - Smooth property changes
- [Hover States](../core-concepts/state-management.md) - Interactive triggers

That's all.
