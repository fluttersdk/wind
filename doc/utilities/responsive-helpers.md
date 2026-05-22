# Responsive Helpers

Responsive helpers provide programmatic access to Wind's breakpoint system, platform detection, and screen metrics directly from your Dart code.

<x-preview path="utilities/responsive_helpers_basic" size="md" source="example/lib/pages/utilities/responsive_helpers_basic.dart"></x-preview>

- [Context Extensions](#context-extensions)
- [Helper Functions](#helper-functions)
- [Breakpoint Reference](#breakpoint-reference)
- [Platform Detection](#platform-detection)

<a name="context-extensions"></a>
## Context Extensions

Wind extends `BuildContext` with ergonomic getters to check the current screen state. These are the most common way to handle conditional logic in your `build` methods.

### Breakpoint Shortcuts

| Extension | Type | Description |
|:----------|:-----|:------------|
| `context.wIsMobile` | `bool` | Returns `true` if screen is smaller than `md` |
| `context.wIsTablet` | `bool` | Returns `true` if screen is between `md` and `lg` |
| `context.wIsDesktop` | `bool` | Returns `true` if screen is at least `lg` |
| `context.wActiveBreakpoint` | `String` | Returns current breakpoint name (`sm`, `md`, etc.) |

Let's look at an example:

```dart
@override
Widget build(BuildContext context) {
  // Use extensions for conditional layouts
  if (context.wIsMobile) {
    return MobileView();
  }

  return DesktopView();
}
```

### Manual Checks

If you need to check against a specific breakpoint name:

```dart
if (context.wScreenIsExt('xl')) {
  // Screen is extra large or larger
}
```

<a name="helper-functions"></a>
## Helper Functions

While extensions are preferred for brevity, these global functions provide the underlying logic and can be used in any part of your widget tree.

### `wScreenIs(context, name)`

Returns `true` if the current screen width is **at least** the pixel value defined for the given breakpoint.

```dart
if (wScreenIs(context, 'md')) {
  print('Tablet or larger');
}
```

### `wScreenCurrent(context)`

Returns the name of the currently active breakpoint based on the screen width.

```dart
String current = wScreenCurrent(context); // 'base', 'sm', 'md', etc.
```

### `wScreen(context, name)`

Returns the raw pixel value (`int`) for a specific breakpoint name from your theme.

```dart
int? mdValue = wScreen(context, 'md'); // 768
```

<a name="breakpoint-reference"></a>
## Breakpoint Reference

By default, Wind uses the standard Tailwind CSS breakpoint scale. You can override these in your `WindThemeData`.

| Name | Value | Range |
|:-----|:------|:------|
| `base` | `0px` | `< 640px` |
| `sm` | `640px` | `>= 640px` |
| `md` | `768px` | `>= 768px` |
| `lg` | `1024px` | `>= 1024px` |
| `xl` | `1280px` | `>= 1280px` |
| `2xl` | `1536px` | `>= 1536px` |

> [!NOTE]
> Breakpoint checks are inclusive (mobile-first). `wScreenIs(context, 'md')` is true for any width >= 768px, including `lg` and `xl` sizes.

<a name="platform-detection"></a>
## Platform Detection

Wind provides platform-specific modifiers for utility classes (e.g., `ios:p-4`), but you can also access platform information programmatically via `WindContext`.

```dart
final wind = WindContext.build(context);

if (wind.isMobile) {
  // Physical mobile device (iOS/Android)
}

print(wind.platform); // 'ios', 'android', 'web', 'macos', etc.
```

For more details on responsive styling using class names, see the [Responsive Design](/doc/core-concepts/responsive-design) guide.
