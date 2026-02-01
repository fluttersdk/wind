# Style Parser

Parse Wind utility classes into a WindStyle object.

## wStyle Function

Parse utility classes programmatically:

```dart
WindStyle style = wStyle(context, 'bg-red-500 p-4 rounded-lg');

// Access parsed values
Color? bgColor = style.decoration?.color;
EdgeInsets? padding = style.padding;
BorderRadius? radius = style.borderRadius;
```

## Context Extension

Use the shortcut extension:

```dart
WindStyle style = context.wStyleExt('p-4 bg-blue-500');
```

## Use Cases

### Custom Widget Styling

```dart
Widget buildCard(BuildContext context, String className) {
  final style = wStyle(context, className);
  
  return Container(
    decoration: style.decoration,
    padding: style.padding,
    child: Text('Styled card'),
  );
}
```

### Debugging

```dart
// Check what gets parsed
WindStyle style = wStyle(context, 'p-4 bg-red-500');
print('Padding: ${style.padding}');
print('Background: ${style.decoration?.color}');
```

## Function Reference

| Function | Description |
| :--- | :--- |
| `wStyle(context, className)` | Parses class string into WindStyle |
| `context.wStyleExt(className)` | Extension shortcut |

## Related

- [Responsive Helpers](./responsive-helpers.md)
- [Context Extensions](./context-extensions.md)
