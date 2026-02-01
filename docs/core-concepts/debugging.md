# Debugging

Wind includes a built-in debugging system to help you understand how your styles are being resolved and the widget composition tree.

## Enabling Debug Mode

Add the `debug` utility class to any Wind widget's className to enable detailed logging:

```dart
WDiv(
  className: 'debug flex flex-col p-4 bg-blue-100',
  children: [
    WText('Debugging Enabled'),
  ],
)
```

This works on all Wind widgets: `WDiv`, `WText`, `WButton`, `WImage`, `WIcon`, etc.

## What Gets Logged

When debug mode is active, `WindLogger` prints a structured report showing:

1. **Composition Tree**: The widget wrapper stack in pseudo-Dart format
2. **Final Styles**: All resolved `WindStyle` properties
3. **Build Time**: Performance metrics in microseconds

### Example Output

```text
--- [WIND DEBUG] START: WDiv ---
--- [WIND DEBUG] Composition Tree: ---
Padding(
  padding: EdgeInsets.all(16.0),
  child:
  Container(
    decoration: BoxDecoration(color: Color(0xFFDBEAFE)),
    child:
    Column(
      children: [...],
    ),
  )
)
--- [WIND DEBUG] Final Styles: WindStyle{padding: EdgeInsets.all(16.0), ...} ---
--- [WIND DEBUG] Build Time: 450µs ---
--- [WIND DEBUG] END: WDiv ---
```

## Alternative: WindStyle Property

If you're using `WindStyle` objects directly, set the `debug` property:

```dart
final styles = WindParser.parse('flex p-4 bg-blue-100', context);

WDiv(
  style: styles.copyWith(debug: true),
  child: Text('Debug via style'),
)
```

## Common Debugging Scenarios

### Layout Issues

When elements aren't positioned correctly:

```dart
WDiv(
  className: 'debug flex justify-center items-center w-full h-64',
  children: [WText('Center me')],
)

// Check the logs for:
// - MainAxisAlignment and CrossAxisAlignment values
// - Width/Height constraints
// - Flex direction
```

### Spacing Problems

When padding/margin looks wrong:

```dart
WDiv(
  className: 'debug p-4 m-2 bg-red-100',
  child: WText('Check spacing'),
)

// The log will show EdgeInsets values:
// padding: EdgeInsets.all(16.0)
// margin: EdgeInsets.all(8.0)
```

### Color Resolution

When colors don't match expectations:

```dart
WDiv(
  className: 'debug bg-primary-500 text-white',
  child: WText('Check colors'),
)

// Look for:
// decoration: BoxDecoration(color: Color(0xFF...))
// color (text): Color(0xFFFFFFFF)
```

## Performance Tips

- Debug mode adds overhead - use only during development
- The build time metric helps identify slow style parsing
- Wind uses an LRU cache, so repeated classNames are faster after first parse

## Related Documentation

- [Utility-First Fundamentals](./utility-first.md) - Core concepts
- [Theming](./theming.md) - Color and spacing configuration
