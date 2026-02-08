# Debugging

- [Introduction](#introduction)
- [Enabling Debug Mode](#enabling-debug-mode)
- [Understanding the Output](#understanding-the-output)
    - [Composition Tree](#composition-tree)
    - [Final Styles](#final-styles)
    - [Build Time](#build-time)
- [How WindLogger Works](#how-windlogger-works)
- [Quick Reference](#quick-reference)
- [Common Scenarios](#common-scenarios)

<a name="introduction"></a>
## Introduction

Today, I'll show you how to peek under the hood of your Wind widgets. If you've ever wondered how your `className` string transforms into a complex Flutter widget tree, you're in the right place.

Wind includes a powerful debugging system that explains exactly what's happening during the "parsing → styling → building" pipeline. It's built directly into the core engine, so you don't need any external tools to see what's going on.

<!-- TODO: [EXAMPLE_NEEDED] path="core-concepts/debugging_basic" action="CREATE" -->
<!-- Description: Show a basic widget with the 'debug' class enabled to demonstrate logging -->
<x-preview path="core-concepts/debugging_basic" size="md" source="example/lib/pages/core-concepts/debugging_basic.dart"></x-preview>

```dart
WDiv(
  className: 'debug flex p-4 bg-blue-500 rounded-lg',
  child: WText('Debugging is active!'),
)
```

<a name="enabling-debug-mode"></a>
## Enabling Debug Mode

Let's start with the easiest way to see what's going on. You just need to add the `debug` utility class to any Wind widget's `className`. 

That's it. No global flags, no complex configuration.

```dart
// Add 'debug' anywhere in your className string
WButton(
  className: 'debug bg-red-500 hover:bg-red-600 px-4 py-2 rounded',
  onTap: () => print('Hello!'),
  child: WText('Debug Me'),
)
```

When Wind sees the `debug` class, it triggers a detailed report to your console.

> [!NOTE]
> Since `debug` is just a utility class, it only affects the specific widget you've added it to. This is great for isolating layout issues without drowning in logs from the rest of your app.

<a name="understanding-the-output"></a>
## Understanding the Output

Let's look at what actually shows up in your console. The output is structured into three main parts to give you a full picture of the widget's lifecycle.

<a name="composition-tree"></a>
### Composition Tree

The Composition Tree shows you the "Atomic Widget" stack. Because Wind translates a single `className` into multiple Flutter widgets (like `Padding`, `DecoratedBox`, `ConstrainedBox`), this tree shows you the exact order and configuration of those widgets.

```text
--- [WIND DEBUG] START: WDiv ---
--- [WIND DEBUG] Composition Tree: ---
Padding(
  padding: EdgeInsets.all(16.0),
  child:
  Container(
    decoration: BoxDecoration(
      color: Color(0xFF3B82F6), 
      borderRadius: BorderRadius.circular(8.0)
    ),
    child: ...
  )
)
```

<a name="final-styles"></a>
### Final Styles

This section shows the resolved `WindStyle` object. This is the "source of truth" after all your classes, responsive modifiers, and state-based styles have been parsed and merged.

```text
--- [WIND DEBUG] Final Styles: WindStyle(
  padding: EdgeInsets.all(16.0),
  backgroundColor: Color(0xFF3B82F6),
  borderRadius: BorderRadius.circular(8.0),
  isFlex: true,
) ---
```

<a name="build-time"></a>
### Build Time

Performance matters! Wind tells you exactly how long it took to parse the classes and build the widget tree.

```text
--- [WIND DEBUG] Build Time: 142µs ---
--- [WIND DEBUG] END: WDiv ---
```

Let's give it a shot. If you see a build time significantly higher than average (usually >1ms), it might be a sign of overly complex nesting or a large number of custom state resolutions.

<a name="how-windlogger-works"></a>
## How WindLogger Works

Behind the scenes, Wind uses a dedicated `WindLogger` service. When the `WindParser` finishes resolving a `className`, it checks if the `debug` flag is active in the resulting `WindStyle`.

If it is, the parser hands over the resolved style and the generated widget tree to the logger. The logger then formats this data into the structured report you see in your console. It uses microsecond-precision timing to ensure the performance metrics are as accurate as possible.

<a name="quick-reference"></a>
## Quick Reference

| Field | Description | Purpose |
|:------|:------------|:--------|
| `debug` | The utility class name | Enables logging for the specific widget. |
| `Composition Tree` | Pseudo-Dart widget stack | Visualizes how Flutter widgets are nested. |
| `Final Styles` | Resolved properties | Shows the final values used for styling. |
| `Build Time` | Microseconds (µs) | Measures parsing and build performance. |

<a name="common-scenarios"></a>
## Common Scenarios

But what if you need to debug something specific? Here are a few ways I use the `debug` class:

- **Layout Shifts**: Check the `Composition Tree` to see if an unexpected `Padding` or `ConstrainedBox` is pushing your elements around.
- **Color Mismatches**: Look at the `Final Styles` to see the exact ARGB value of the resolved color.
- **Responsive Issues**: Resize your window while `debug` is active. You'll see the logs re-trigger as breakpoints change, showing you the new resolved styles in real-time.

That's all. Have a nice day.
