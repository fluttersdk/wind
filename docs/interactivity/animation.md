# Animation

Utilities for animating elements with CSS-like animation classes.

## Animate Classes (Explicit Animations)

Use these classes for continuous or one-off animations like spinners or bounces.

<x-preview path="animation/animation_basic" size="md" source="example/lib/pages/animation/animation_basic.dart"></x-preview>

```dart
// Spinning loading indicator
WDiv(className: 'w-8 h-8 border-4 border-blue-500 rounded-full animate-spin')

// Pulsing skeleton loader
WDiv(className: 'w-full h-4 bg-gray-300 rounded animate-pulse')

// Bouncing scroll indicator
WIcon(Icons.arrow_downward, className: 'text-blue-500 text-2xl animate-bounce')
```

### Available Animations

| Class | Effect | Usage |
|-------|--------|-------|
| `animate-spin` | Continuous rotation | Loading spinners |
| `animate-pulse` | Opacity pulse | Skeleton loaders |
| `animate-bounce` | Vertical bounce | Scroll indicators |
| `animate-ping` | Scale + fade out | Notification badges |
| `animate-none` | Remove animation | Stopping animation |

---

## Implicit Animations (Transitions)

Wind automatically uses Flutter's implicit animations (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedAlign`) when you add a `duration-{n}` class. This makes state changes smooth without any boilerplate.

<x-preview path="animation/animation_implicit" size="md" source="example/lib/pages/animation/animation_implicit.dart"></x-preview>

```dart
// 1. Smoothly animate hover effects (using WAnchor for clean state management)
WAnchor(
  child: WDiv(
    className: 'w-20 h-20 rounded-lg flex items-center justify-center duration-300 bg-gray-300 hover:bg-green-500',
    children: const [WText('Hover', className: 'text-sm')],
  ),
)

// 2. Toggle Switch (Implicit Styling + Explicit Layout)
WDiv(
  states: {if (isToggled) 'toggled'},
  className: 'w-12 h-6 rounded-full p-1 duration-200 ease-in-out bg-gray-300 toggled:bg-blue-500',
  children: [
    AnimatedAlign(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
      child: const WDiv(
        className: 'w-4 h-4 rounded-full bg-white shadow-sm',
      ),
    ),
  ],
)
```

### Supported Properties

When `duration-{n}` is present, the following properties will animate:

- **Layout:** width, height, margin, padding
- **Decoration:** color, border, border-radius, shadows
- **Effects:** opacity, transforms

### Controlling Timing

| Class | Duration |
|-------|----------|
| `duration-75` | 75ms |
| `duration-100` | 100ms |
| `duration-150` | 150ms |
| `duration-200` | 200ms |
| `duration-300` | 300ms |
| `duration-500` | 500ms |
| `duration-700` | 700ms |
| `duration-1000` | 1000ms |
| `duration-[Xms]` | Arbitrary (e.g., `duration-[450ms]`) |

### Controlling Easing

| Class | Curve |
|-------|-------|
| `ease-linear` | Linear |
| `ease-in` | Ease In |
| `ease-out` | Ease Out |
| `ease-in-out` | Ease In Out (Default) |

## Customizing Theme

You can customize the available explicit animations in `WindThemeData`.
Note: The value must be a `WindAnimationType` or a custom implementation if you extend the parser.

```dart
WindTheme(
  theme: WindThemeData(
    animations: {
      'spin-slow': WindAnimationType.spinSlow, // Assuming you have added this to enum or similar
    },
  ),
  child: MyApp(),
)
```

Currently, `WindAnimationType` supports `spin`, `pulse`, `bounce`, and `ping`. For completely custom animations (keyframes), you would typically use a custom parser or `WAnimation` widget directly, as `WindThemeData` currently maps names to predefined types.

## Related Documentation

- [Hover States](./hover.md) - Interactive hover effects
- [Transforms](../styling/transform.md) - Transform utilities
- [Opacity](../styling/opacity.md) - Opacity utilities
