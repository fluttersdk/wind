# Style Parser

- [Introduction](#introduction)
- [The wStyle Helper](#wstyle-helper)
- [WindParser Engine](#windparser-engine)
- [Performance & Caching](#performance-and-caching)
- [Context Extensions](#context-extensions)

<a name="introduction"></a>
## Introduction

While Wind widgets like `WDiv` and `WText` are the primary way to use utility classes, you may sometimes need to parse utility strings programmatically. The Style Parser API allows you to convert any `className` string into a structured `WindStyle` object that can be applied to standard Flutter widgets.

<x-preview path="utilities/style_parser_basic" size="md" source="example/lib/pages/utilities/style_parser_basic.dart"></x-preview>

<a name="wstyle-helper"></a>
## The wStyle Helper

The `wStyle` function is a global helper that provides the simplest way to parse utility classes on the fly.

```dart
WindStyle wStyle(BuildContext context, String className)
```

### Usage Example

This is particularly useful when building custom widgets that need to accept Wind utilities for styling:

```dart
Widget buildCustomCard(BuildContext context, {String? className}) {
  final style = wStyle(context, className ?? 'bg-white p-4 shadow-md');
  
  return Container(
    decoration: style.decoration,
    padding: style.padding,
    child: Text('Styled with WindStyle'),
  );
}
```

<a name="windparser-engine"></a>
## WindParser Engine

For more advanced scenarios, you can interface directly with `WindParser.parse`. This method allows for base style merging and manual state injection.

```dart
static WindStyle parse(
  String className,
  BuildContext context, {
  WindStyle? baseStyle,
  Set<String>? states,
})
```

### Parameters

| Parameter | Type | Description |
|:---|:---|:---|
| `className` | `String` | The utility class string to parse. |
| `context` | `BuildContext` | Used to resolve theme values, breakpoints, and platform. |
| `baseStyle` | `WindStyle?` | An optional base style to merge the new utilities into. |
| `states` | `Set<String>?` | Manual state overrides (e.g., `{'loading', 'active'}`). |

### Accessing Parsed Values

The resulting `WindStyle` object contains resolved Flutter properties:

```dart
final style = wStyle(context, 'bg-red-500 text-lg font-bold');

Color? color = style.decoration?.color; // Resolved bg-red-500
TextStyle? textStyle = style.textStyle;  // Resolved text-lg and font-bold
EdgeInsets? padding = style.padding;     // resolved p-* classes
```

<a name="performance-and-caching"></a>
## Performance & Caching

Wind uses an internal memoization system to ensure that parsing is extremely fast. The `WindParser` maintains a static cache keyed by a combination of:

1. The raw `className` string.
2. The current active breakpoint (`sm`, `md`, etc.).
3. The current brightness (Light/Dark mode).
4. The target platform (iOS/Android/Web).
5. The active interaction states (`hover`, `focus`, etc.).

> [!NOTE]
> Because of this caching, calling `wStyle` multiple times with the same parameters in a build method has negligible performance impact.

<a name="context-extensions"></a>
## Context Extensions

For cleaner syntax, Wind provides a BuildContext extension that mirrors the global helper:

```dart
// Using global helper
final style = wStyle(context, 'p-4');

// Using extension
final style = context.wStyleExt('p-4');
```

### Related Documentation

- [Context Extensions](./context-extensions.md)
- [Color Helpers](./color-helpers.md)
- [Theming Concepts](../core-concepts/theming.md)
