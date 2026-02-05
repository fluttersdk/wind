# Text Transform

Utilities for controlling the transformation of text.

<x-preview path="typography/text_transform" size="md" source="example/lib/pages/typography/text_transform.dart"></x-preview>

## Basic Usage

Transform text case using transform utilities:

```dart
WText('uppercase', className: 'uppercase')     // UPPERCASE
WText('LOWERCASE', className: 'lowercase')     // lowercase
WText('capitalize me', className: 'capitalize') // Capitalize Me
WText('Normal Case', className: 'normal-case')  // Normal Case
```

## All Transform Classes

| Class | Description | Example |
| :--- | :--- | :--- |
| `uppercase` | Transform to uppercase | HELLO |
| `lowercase` | Transform to lowercase | hello |
| `capitalize` | Capitalize each word | Hello World |
| `normal-case` | Preserve original case | Hello World |

## Related Documentation

- [Font Weight](./font-weight.md) - Font weight utilities
- [Letter Spacing](./letter-spacing.md) - Letter spacing utilities
