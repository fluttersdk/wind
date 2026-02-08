# Text Transform

Utilities for controlling the capitalization and wrapping of text.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Whitespace & Wrapping](#whitespace--wrapping)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_transform_preview" size="md" source="example/lib/pages/typography/text_transform_preview.dart"></x-preview>

<!-- TODO: [CREATE] path="typography/text_transform_preview" action="CREATE" -->
<!-- Description: Show examples of uppercase, lowercase, capitalize, and whitespace-nowrap -->

```dart
// Uppercase
WText('Hello World', className: 'uppercase')

// Capitalize
WText('hello world', className: 'capitalize')

// Prevent wrapping
WText('Long text that should not wrap...', className: 'whitespace-nowrap')
```

<a name="basic-usage"></a>
## Basic Usage

Use `uppercase` and `lowercase` to force text casing. `capitalize` converts the first character of each word to uppercase.

```dart
WDiv(
  className: 'flex flex-col gap-4',
  children: [
    WText('uppercase text', className: 'uppercase'), // UPPERCASE TEXT
    WText('LOWERCASE TEXT', className: 'lowercase'), // lowercase text
    WText('capitalize this text', className: 'capitalize'), // Capitalize This Text
    WText('Normal Case Text', className: 'normal-case'), // Normal Case Text
  ],
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Transform | Description |
|:------|:----------|:------------|
| `uppercase` | Uppercase | Converts all text to uppercase. |
| `lowercase` | Lowercase | Converts all text to lowercase. |
| `capitalize` | Capitalize | Capitalizes the first letter of each word. |
| `normal-case` | None | Resets text transformation (useful for overrides). |

<a name="whitespace--wrapping"></a>
## Whitespace & Wrapping

Control how text handles whitespace and wrapping using `whitespace-` utilities.

<x-preview path="typography/whitespace_preview" size="md" source="example/lib/pages/typography/whitespace_preview.dart"></x-preview>

<!-- TODO: [CREATE] path="typography/whitespace_preview" action="CREATE" -->
<!-- Description: Compare whitespace-normal (default) vs whitespace-nowrap with overflow scrolling -->

```dart
// Prevent text from wrapping
WText(
  'This is a long sentence that will not wrap to the next line.',
  className: 'whitespace-nowrap',
)
```

| Class | Wrap | Description |
|:------|:-----|:------------|
| `whitespace-normal` | Yes | Allow text to wrap normally (default). |
| `whitespace-nowrap` | No | Prevent text from wrapping. |
| `text-wrap` | Yes | Alias for `whitespace-normal`. |
| `text-nowrap` | No | Alias for `whitespace-nowrap`. |
| `text-balance` | Balance | Balances text across lines for better readability. |

<a name="responsive-design"></a>
## Responsive Design

Apply transforms or whitespace rules conditionally at different breakpoints.

```dart
// Uppercase on mobile, normal case on tablet+
WText('Responsive Text', className: 'uppercase md:normal-case')

// Wrap on mobile, no-wrap on large screens
WText('Responsive Wrap', className: 'whitespace-normal lg:whitespace-nowrap')
```

<a name="dark-mode"></a>
## Dark Mode

While text transforms rarely change based on theme, you can apply them conditionally if needed.

```dart
WText('Dark Mode Text', className: 'normal-case dark:uppercase')
```

<a name="customizing-theme"></a>
## Customizing Theme

Text transform and whitespace utilities are hardcoded in the parser and **cannot be customized** via `WindThemeData`.

<a name="related-documentation"></a>
## Related Documentation

- [Text Overflow](./text-overflow.md)
- [Font Weight](./font-weight.md)
- [Letter Spacing](./letter-spacing.md)
