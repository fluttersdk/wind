# Debugging

Wind includes a built-in debugging system to help you understand how your styles are being resolved and applied.

<x-preview path="layout/display" size="md"></x-preview>

## Enabling Debug Mode

By default, Wind operates silently. You can enable debug logging for any `WDiv` or `WText` in two ways:

### 1. The `debug` Utility Class

Simply add the `debug` class to your className string.

```dart
WDiv(
  className: "debug flex flex-col p-4 bg-blue-100",
  children: [
    Text("Debugging Enabled"),
  ],
)
```

This will output detailed logs to your console, showing:
- Parsed properties
- Resolution steps
- Final widget composition tree

### 2. The `WindStyle` Helper

If you are using `WindStyle` objects directly, you can set the `debug` property to `true`.

```dart
WDiv(
  style: WindStyle(
    debug: true,
    padding: EdgeInsets.all(16),
  ),
  child: Text("Debugging via Style object"),
)
```

## Understanding the Logs

When debug mode is active, `WindLogger` will print a structured report:

```
--- [WIND DEBUG] START: WDiv ---
   ClassName: 'debug flex p-4'
--- [WIND DEBUG] Composition Tree: ---
Container(
  padding: EdgeInsets.all(16.0),
  child:
  Row(children: [ ... ]),
)
--- [WIND DEBUG] Final Styles: WindStyle{...} ---
--- [WIND DEBUG] Build Time: 1245µs ---
--- [WIND DEBUG] END: WDiv ---
```
