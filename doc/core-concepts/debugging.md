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

Wind includes a specialized debugging system designed to peel back the abstraction of the utility-first engine. Since Wind translates a single `className` string into a complex hierarchy of Flutter widgets, the debugging tools allow you to verify the exact widget composition, resolved styles, and build performance.

The system is built directly into the core engine, requiring no external configuration or devtools extensions to inspect the "parsing → styling → building" pipeline.

<!-- TODO: [EXAMPLE_NEEDED] path="core-concepts/debugging_basic" action="CREATE" -->
<!-- Description: Show a basic widget with the 'debug' class enabled to demonstrate logging output -->
<x-preview path="core-concepts/debugging_basic" size="md" source="example/lib/pages/core-concepts/debugging_basic.dart"></x-preview>

```dart
WDiv(
  className: 'debug flex p-4 bg-blue-500 rounded-lg',
  child: WText('Debugging active'),
)
```

<a name="enabling-debug-mode"></a>
## Enabling Debug Mode

To enable debugging for a specific widget, add the `debug` utility class to its `className` string. This approach allows for targeted inspection without flooding the console with logs from unrelated widgets.

```dart
// Enabling debug for a button
WButton(
  className: 'debug bg-red-500 hover:bg-red-600 px-4 py-2 rounded',
  onTap: () => print('Action'),
  child: WText('Delete'),
)
```

When the `WindParser` encounters the `debug` class, it triggers a detailed report to the console during the widget's build phase.

> [!NOTE]
> Debug mode is scoped to the specific widget instance. It does not affect parent or child widgets unless they also include the `debug` class.

<a name="understanding-the-output"></a>
## Understanding the Output

The debug report is divided into three primary sections that represent the lifecycle of a Wind widget.

<a name="composition-tree"></a>
### Composition Tree

The Composition Tree visualizes the "Atomic Widget" stack. Because Wind often wraps your content in multiple Flutter widgets (such as `Padding`, `DecoratedBox`, or `ConstrainedBox`) to satisfy the `className` requirements, this tree shows the final structure.

```text
--- [WIND DEBUG] Composition Tree: ---
Padding(
  padding: EdgeInsets.all(16.0),
  child: 
  DecoratedBox(
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

This section displays the fully resolved `WindStyle` object. This is the final state after all utility classes, responsive modifiers (e.g., `md:`), and state variants (e.g., `hover:`) have been merged.

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

Wind measures the total time spent in the style resolution and widget building process. Metrics are provided in microseconds (µs) to ensure high-precision performance monitoring.

```text
--- [WIND DEBUG] Build Time: 142µs ---
```

Significant spikes in build time (typically >1ms) may indicate excessive class complexity or inefficient custom state resolutions.

<a name="how-windlogger-works"></a>
## How WindLogger Works

Internally, Wind leverages a `WindLogger` service. When the `WindParser` resolves a `className`, it checks for the presence of the `debug` flag in the resulting style object.

If active, the parser passes the resolved properties and the generated widget hierarchy to the logger. The logger then formats this data into a human-readable "pseudo-Dart" format. The timing is handled by a `Stopwatch` that starts when the parsing begins and stops when the widget tree is returned.

<a name="quick-reference"></a>
## Quick Reference

| Field | Purpose | Output Format |
|:------|:--------|:--------------|
| `debug` | Utility class | N/A |
| `Composition Tree` | Widget hierarchy | Pseudo-Dart code |
| `Final Styles` | Style verification | `WindStyle` properties |
| `Build Time` | Performance audit | Microseconds (µs) |

<a name="common-scenarios"></a>
## Common Scenarios

Let's look at common debugging workflows using the `debug` class:

- **Inspecting Responsive Styles**: Resize the viewport while `debug` is active. The logger will re-trigger and show the new `Final Styles` for the active breakpoint.
- **Verifying State Variants**: Hover over or focus a widget with state-based classes (like `hover:bg-blue-600`). The log will update to show the merged style.
- **Analyzing Layout Layers**: Use the `Composition Tree` to determine which utility class is responsible for a specific Flutter wrapper, helping identify unexpected padding or alignment issues.

That's all.
