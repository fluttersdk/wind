# Responsive Design

Building interfaces that adapt to any screen size is a core requirement for modern applications. Wind makes this process declarative using a mobile-first, utility-based approach.

<!-- TODO: [EXAMPLE_NEEDED] path="core/responsive_basic" action="CREATE" -->
<!-- Description: A card that changes layout from vertical (mobile) to horizontal (desktop) with color changes at each breakpoint. -->
<x-preview path="core/responsive_basic" size="md" source="example/lib/pages/core/responsive_basic.dart"></x-preview>

```dart
// Stacked on mobile (default), horizontal on medium screens and up
WDiv(
  className: 'flex flex-col md:flex-row gap-4 p-4 bg-gray-100 md:bg-blue-50',
  children: [
    WDiv(className: 'w-full md:w-1/2 h-24 bg-blue-500'),
    WDiv(className: 'w-full md:w-1/2 h-24 bg-red-500'),
  ],
)
```

- [Mobile-First Approach](#mobile-first-approach)
- [Breakpoint Reference](#breakpoint-reference)
- [Platform Prefixes](#platform-prefixes)
- [Combining Modifiers](#combining-modifiers)
- [Customizing Breakpoints](#customizing-breakpoints)

<a name="mobile-first-approach"></a>
## Mobile-First Approach

Wind follows a mobile-first philosophy. This means that utility classes without a prefix apply to all screen sizes by default. Responsive modifiers like `md:` or `lg:` only apply when the screen width meets or exceeds the specified breakpoint.

Consider this example:

```dart
// Mobile: blue background, Desktop: green background
WDiv(className: 'bg-blue-500 lg:bg-green-500')
```

In this case, the `bg-blue-500` class is the base style. The `lg:bg-green-500` class only activates when the screen width is at least 1024px, overriding the base background color.

<a name="breakpoint-reference"></a>
## Breakpoint Reference

Wind includes five default breakpoints inspired by the standard Tailwind CSS scale.

| Prefix | Value | Description |
|:-------|:------|:------------|
| `sm` | 640px | Large phones / Small tablets |
| `md` | 768px | Tablets (Portrait) |
| `lg` | 1024px | Laptops / Tablets (Landscape) |
| `xl` | 1280px | Desktops |
| `2xl` | 1536px | Large Desktops |

> [!NOTE]
> These values represent the **minimum width** required for the modifier to take effect.

<a name="platform-prefixes"></a>
## Platform Prefixes

In addition to screen sizes, Wind supports platform-specific modifiers. These allow you to apply styles based on the operating system or environment.

| Prefix | Applies To |
|:-------|:-----------|
| `ios:` | iOS devices |
| `android:` | Android devices |
| `macos:` | macOS |
| `web:` | Web browsers |
| `mobile:` | Both iOS and Android |
| `windows:` | Windows |
| `linux:` | Linux |

Example usage:

```dart
WDiv(
  className: 'p-4 ios:p-6 android:p-2 web:p-8',
  child: WText('Platform-specific padding'),
)
```

<a name="combining-modifiers"></a>
## Combining Modifiers

You can chain multiple modifiers to create highly specific styling rules. For example, you might want a hover effect that only applies in dark mode on large screens.

```dart
WButton(
  className: 'bg-blue-500 lg:dark:hover:bg-indigo-600',
  child: WText('Submit'),
)
```

> [!WARNING]
> Modifier order is strict. Breakpoint modifiers must always come first in the chain (e.g., `lg:dark:hover:`).

<a name="customizing-breakpoints"></a>
## Customizing Breakpoints

If the default breakpoints do not match your project requirements, you can define custom screens in `WindThemeData`.

```dart
WindTheme(
  data: WindThemeData(
    screens: {
      'tablet': 600,
      'laptop': 900,
      'desktop': 1200,
    },
  ),
  child: MyApp(),
)
```

Once defined, these custom keys can be used as prefixes: `tablet:p-4`, `laptop:flex-row`, etc.

That's all.

## Related Documentation

- [Utility-First Fundamentals](./utility-first.md)
- [Theming](./theming.md)
- [Dark Mode](./dark-mode.md)
- [State Management](./state-management.md)
