# Color Helpers

Programmatic access to theme colors.

## wColor Function

Resolve colors from the theme programmatically:

```dart
// Get color by name and shade
Color blue = wColor(context, 'blue', shade: 500)!;
Color red = wColor(context, 'red', shade: 600)!;

// Shorthand with shade in name
Color green = wColor(context, 'green-400')!;

// Hex color (bypasses theme)
Color custom = wColor(context, '#FF5733')!;
```

## Dark Mode Support

Pass a dark color as fallback:

```dart
Color bgColor = wColor(
  context,
  'white',
  darkColorName: 'slate',
  darkShade: 800,
)!;
```

## Context Extension

Use the shortcut extension:

```dart
Color? blue = context.wColorExt('blue', shade: 500);
```

## Function Reference

| Function | Description |
| :--- | :--- |
| `wColor(context, name, {shade})` | Returns a theme color |
| `context.wColorExt(name, {shade})` | Extension shortcut |

## Related

- [Spacing Helpers](./spacing-helpers.md)
- [Typography Helpers](./typography-helpers.md)
