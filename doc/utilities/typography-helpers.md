# Typography Helpers

- [Introduction](#introduction)
- [Global Functions](#global-functions)
    - [wFontSize](#wfontsize)
    - [wFontWeight](#wfontweight)
- [BuildContext Extensions](#buildcontext-extensions)
- [Theme Scale Access](#theme-scale-access)
- [Customizing Scales](#customizing-scales)

<a name="introduction"></a>
## Introduction

Wind provides a set of helper functions and extensions to access typography values directly from your Dart code. While utility classes are the primary way to style widgets, these helpers are essential when you need to calculate dimensions, pass styles to standard Material widgets, or build custom components that respect the design system.

<a name="global-functions"></a>
## Global Functions

These functions provide a safe way to resolve typography values using the current `BuildContext`.

<a name="wfontsize"></a>
### wFontSize

The `wFontSize` function retrieves a pixel value from the theme's font size scale. It accepts the size name (e.g., 'sm', 'lg', '2xl') and returns the corresponding `double`.

```dart
double? size = wFontSize(context, 'lg'); // Returns 18.0 (default)
```

<a name="wfontweight"></a>
### wFontWeight

The `wFontWeight` function resolves a named font weight into a Flutter `FontWeight` object.

```dart
FontWeight? weight = wFontWeight(context, 'bold'); // Returns FontWeight.w700
```

Supported weight names include `thin`, `extralight`, `light`, `normal`, `medium`, `semibold`, `bold`, `extrabold`, and `black`.

<a name="buildcontext-extensions"></a>
## BuildContext Extensions

For a more ergonomic API, Wind extends `BuildContext` with shortcut methods. These are wrappers around the global functions and provide a cleaner syntax when working inside a `build` method.

```dart
// Font Size shortcut
final h1Size = context.wFontSizeExt('4xl');

// Font Weight shortcut
final strongWeight = context.wFontWeightExt('bold');
```

<a name="theme-scale-access"></a>
## Theme Scale Access

If you need to iterate over the entire scale or access specific metadata, you can retrieve the `WindThemeData` object directly from the context.

```dart
final theme = context.windThemeData;

// Access the raw scales
Map<String, double> sizes = theme.fontSizes;
Map<String, FontWeight> weights = theme.fontWeights;
Map<String, double> letterSpacing = theme.tracking;
Map<String, double> lineHeights = theme.leading;
Map<String, String> families = theme.fontFamilies;
```

This is particularly useful when building dynamic UI elements like font pickers or settings menus:

```dart
// Example: Listing all available font sizes
return ListView(
  children: context.windThemeData.fontSizes.keys.map((name) {
    return ListTile(
      title: Text('Size: $name'),
      trailing: Text('${context.wFontSizeExt(name)}px'),
    );
  }).toList(),
);
```

<a name="customizing-scales"></a>
## Customizing Scales

You can override any part of the typography system when initializing your `WindTheme`. This ensures that your custom values are available through all the helper functions described above.

```dart
WindTheme(
  data: WindThemeData(
    fontSizes: {
      'display': 120.0,
      'caption': 10.0,
    },
    fontWeights: {
      'heavy': FontWeight.w900,
    },
  ),
  child: MyApp(),
)
```

Once defined, these custom keys are accessible just like the defaults:

```dart
final displaySize = context.wFontSizeExt('display'); // 120.0
```
