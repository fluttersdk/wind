# Configuration

Wind is designed to be customizable. While it comes with a sensible default configuration (modeled after Tailwind CSS), you can override almost everything via `WindThemeData`.

## The WindTheme

The `WindTheme` widget injects your configuration into the widget tree. It is an `InheritedWidget`, meaning any Wind widget below it can access the configuration.

```dart
WindTheme(
  theme: WindThemeData(
    // Your overrides here
  ),
  child: MyApp(),
)
```

## Customizing Colors

You can define your own color palette. Simple `Color` objects are automatically converted into full `MaterialColor` swatches (50-900) by Wind.

```dart
WindThemeData(
  colors: {
    'brand': Color(0xFF6366F1), // "brand-500"
    'danger': Colors.red,       // "danger-500"
  },
)
```

Usage:
```dart
WDiv(className: "bg-brand text-white") // Uses brand-500
WDiv(className: "bg-brand-100 text-brand-900") // Uses generated shades
```

## Customizing Spacing

The entire spacing system (`p-`, `m-`, `gap-`, `w-`, `h-`) is built on the `baseSpacingUnit`. By default, this is **4.0**.

- `p-1` = 1 * 4.0 = 4px
- `p-4` = 4 * 4.0 = 16px

To change this (e.g., to an 8px grid):

```dart
WindThemeData(
  baseSpacingUnit: 8.0,
)
```

Now `p-1` is 8px, and `p-4` is 32px.

> **Note**
> You cannot currently change the multiplier logic itself (e.g., make `p-1` be 10px and `p-2` be 15px arbitrary values) without rewriting the core parser, but you can override specific container widths.

## Customizing Typography

Wind uses a standard typographic scale (`text-xs` to `text-6xl`). You can override these sizes:

```dart
WindThemeData(
  fontSizes: {
    'xs': 10.0,
    'sm': 12.0,
    'base': 16.0,
    'huge': 128.0, // Custom size
  },
)
```

Usage:
```dart
WText("Big Text", className: "text-huge")
```

For more details on all configurable options, refer to the [Theming Guide](../core-concepts/theming.md).
