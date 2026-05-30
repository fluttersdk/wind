# Display (Visibility)

Control widget visibility with `hide` and `show` utility classes, with optional responsive breakpoint prefixes.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How It Works](#how-it-works)
- [Responsive Display](#responsive-display)
- [Helper Functions](#helper-functions)
- [Related Documentation](#related-documentation)

<x-preview path="layout/display" size="md" source="example/lib/pages/layout/display.dart"></x-preview>

```dart
WFlexContainer(
  className: 'flex-col bg-gray-100 h-64 justify-center items-center gap-4',
  children: [
    WFlexible(
      className: 'hide lg:show',
      child: WText('Visible on large and larger screens'),
    ),
    WFlexible(
      className: 'hide md:show',
      child: WText('Visible on medium and larger screens'),
    ),
    WFlexible(
      className: 'show md:hide',
      child: WText('Visible on only small screens'),
    ),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

Apply `hide` to a widget's `className` to hide it unconditionally. Apply `show` to force it visible.
Combine with a breakpoint prefix to make the behavior screen-size-conditional.

```dart
WContainer(
  className: 'hide',
  child: WText('This widget is hidden'),
);

WContainer(
  className: 'show',
  child: WText('This widget is visible'),
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description |
| :--- | :--- |
| `hide` | Hides the widget (replaces it with `SizedBox.shrink()`) |
| `show` | Forces the widget to be visible |

Responsive prefix syntax: `<breakpoint>:<class>` — for example `md:hide`, `lg:show`.

<a name="how-it-works"></a>
## How It Works

Wind's `DisplayParser` reads the `className` string. When a `hide` token is matched (and any breakpoint
condition is satisfied), the widget is replaced with `SizedBox.shrink()`. The `show` token overrides
a previous `hide` on the same widget.

This behavior is built into:

- `WText`
- `WFlexible`
- `WContainer`
- `WCard`

<a name="responsive-display"></a>
## Responsive Display

Prefix any display class with a breakpoint to apply it only at that screen width and above.

| Breakpoint | Min-width |
| :--- | :--- |
| `sm:` | 640 px |
| `md:` | 768 px |
| `lg:` | 1024 px |
| `xl:` | 1280 px |
| `2xl:` | 1536 px |

```dart
// Visible only on small screens; hidden on medium and above.
WFlexible(
  className: 'show md:hide',
  child: WText('Mobile only'),
);

// Hidden by default; shown on large screens and above.
WFlexible(
  className: 'hide lg:show',
  child: WText('Desktop only'),
);
```

<a name="helper-functions"></a>
## Helper Functions

Wind exposes Dart helpers for imperative visibility logic.

### `wScreen`

Returns `true` if the current screen width is at or above the given breakpoint.

```dart
wScreen(context, 'md') // true on medium and larger screens
```

### `wScreenOnly`

Returns `true` only when the screen width falls within the exact range of the given breakpoint.

```dart
wScreenOnly(context, 'sm') // true only on small screens
```

### `wAnyScreenOnly`

Returns `true` when the screen matches any of the provided breakpoints exclusively.

```dart
wAnyScreenOnly(context, ['sm', 'md']) // true on small or medium only
```

<a name="related-documentation"></a>
## Related Documentation

- [Responsive Design](../concepts/responsive-design.md) — breakpoint system and screen-size utilities
- [WContainer](../widgets/wcontainer.md) — container widget supporting display classes
- [WFlexible](../widgets/wflexible.md) — flex child widget supporting display classes
- [WText](../widgets/wtext.md) — text widget supporting display classes
