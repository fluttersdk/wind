# Transition

Utilities for controlling the transition duration and timing function of elements.

## Duration

Control the transition duration using `duration-{ms}` utilities.

| Class | Duration |
| :--- | :--- |
| `duration-75` | 75ms |
| `duration-100` | 100ms |
| `duration-150` | 150ms |
| `duration-200` | 200ms |
| `duration-300` | 300ms |
| `duration-500` | 500ms |
| `duration-700` | 700ms |
| `duration-1000` | 1000ms |

### Arbitrary Values

```dart
WDiv(className: "duration-[250ms] ...")
WDiv(className: "duration-[400] ...")
```

<x-preview path="effects/transition_duration" size="md" source="example/lib/pages/effects/transition_duration.dart"></x-preview>

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-blue-500 hover:bg-indigo-600 duration-300 px-6 py-4 rounded-xl shadow-md hover:shadow-xl',
    child: WText('300ms', className: 'text-white font-bold text-lg'),
  ),
)
```

---

## Timing Function (Ease)

Control the timing function using `ease-{curve}` utilities.

| Class | Curve |
| :--- | :--- |
| `ease-linear` | Linear |
| `ease-in` | Ease In |
| `ease-out` | Ease Out |
| `ease-in-out` | Ease In Out |

<x-preview path="effects/transition_ease" size="md" source="example/lib/pages/effects/transition_ease.dart"></x-preview>

```dart
// Each box has a different ease curve with same 700ms duration
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-emerald-500 hover:bg-emerald-700 duration-700 ease-linear w-[140px] py-5 rounded-xl',
    child: WText('Linear', className: 'text-white font-bold text-center'),
  ),
)

WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-sky-500 hover:bg-sky-700 duration-700 ease-in w-[140px] py-5 rounded-xl',
    child: WText('Ease In', className: 'text-white font-bold text-center'),
  ),
)
```

---

## Combined Examples

Real-world patterns combining duration, ease, and hover states.

<x-preview path="effects/transition_combined" size="lg" source="example/lib/pages/effects/transition_combined.dart"></x-preview>

### Button Hover Effect

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-blue-500 hover:bg-blue-700 duration-200 ease-in-out px-8 py-3 rounded-lg shadow-md hover:shadow-lg',
    child: WText('Primary', className: 'text-white font-semibold'),
  ),
)
```

### Card Hover Effect

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-white hover:bg-gray-50 shadow-md hover:shadow-2xl duration-300 ease-out p-6 rounded-2xl w-[320px]',
    children: [
      WText('Card Title', className: 'text-xl font-bold text-gray-900'),
      WDiv(className: 'h-3'),
      WText('Hover to see the shadow transition.', className: 'text-gray-500'),
    ],
  ),
)
```

### Color Palette Transitions

```dart
WDiv(
  className: 'flex flex-row gap-3',
  children: [
    _colorBox('bg-red-400 hover:bg-red-600'),
    _colorBox('bg-orange-400 hover:bg-orange-600'),
    _colorBox('bg-emerald-400 hover:bg-emerald-600'),
    // ... more colors
  ],
)

Widget _colorBox(String colorClasses) {
  return WAnchor(
    onTap: () {},
    child: WDiv(
      className: '$colorClasses duration-300 ease-in-out w-[56px] h-[56px] rounded-xl shadow-sm hover:shadow-lg',
    ),
  );
}
```

## Customizing Theme

You can customize the default values for durations and animation curves in `WindThemeData`.

### Durations

```dart
WindTheme(
  theme: WindThemeData(
    transitionDurations: {
        'fast': Duration(milliseconds: 100),
        'slow': Duration(milliseconds: 1000),
        '2000': Duration(milliseconds: 2000), // Override default or add new
    },
  ),
  child: MyApp(),
)
```

Usage: `duration-fast`, `duration-slow`.

### Curves

```dart
WindTheme(
  theme: WindThemeData(
    transitionCurves: {
        'bounce': Curves.bounceOut,
        'elastic': Curves.elasticIn,
    },
  ),
  child: MyApp(),
)
```

Usage: `ease-bounce`, `ease-elastic`.

## Related Documentation

- [Animation](./animation.md) - Explicit animation utilities
- [Hover States](./hover.md) - Interactive hover effects
- [Opacity](../styling/opacity.md) - Opacity utilities
