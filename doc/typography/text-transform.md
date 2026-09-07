# Text Transform

Utilities for controlling the capitalization and wrapping of text.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
  - [Locale-aware casing](#locale-aware-casing)
- [Whitespace & Wrapping](#whitespace--wrapping)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_transform" size="md" source="example/lib/pages/typography/text_transform.dart"></x-preview>

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

Use `uppercase` and `lowercase` to force text casing. `capitalize` raises the first letter of every word and leaves the rest of the word as typed, so an acronym you passed in survives.

> [!NOTE]
> A word runs through letters, digits, underscores and apostrophes; anything else opens a new one. So `well-known issue` renders `Well-Known Issue` and `read/write` renders `Read/Write`, while `l'orange` stays `L'orange` and `3rd party` stays `3rd Party`. That is what browsers do with CSS `text-transform: capitalize`.

```dart
WDiv(
  className: 'flex flex-col gap-4',
  children: [
    WText('uppercase text', className: 'uppercase'), // UPPERCASE TEXT
    WText('LOWERCASE TEXT', className: 'lowercase'), // lowercase text
    WText('capitalize this text', className: 'capitalize'), // Capitalize This Text
    WText('the HTTP client', className: 'capitalize'), // The HTTP Client
    WText('Normal Case Text', className: 'normal-case'), // Normal Case Text
  ],
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Transform | Description |
|:------|:----------|:------------|
| `uppercase` | Uppercase | Converts all text to uppercase, under the ambient locale's rules. |
| `lowercase` | Lowercase | Converts all text to lowercase, under the ambient locale's rules. |
| `capitalize` | Capitalize | Raises the first letter of each word, under the ambient locale's rules. The rest of the word stays as typed. |
| `normal-case` | None | Resets text transformation (useful for overrides). |

<a name="locale-aware-casing"></a>
### Locale-aware casing

The three transforms above read the ambient locale through
`Localizations.maybeLocaleOf` and cast accordingly. This matters for Turkish and
Azerbaijani, which distinguish a dotted from a dotless `i`: the uppercase of `i`
is `İ` and the uppercase of `ı` is `I`, where Dart's locale-independent
`String.toUpperCase()` produces `I` for both.

```dart
// Under Locale('tr')
WText('izleyiciler', className: 'uppercase')       // İZLEYİCİLER
WText('kullanılan', className: 'uppercase')        // KULLANILAN
WText('izleyici ışıkları', className: 'capitalize') // İzleyici Işıkları

// Under Locale('en')
WText('monitors up', className: 'uppercase')       // MONITORS UP
```

**With no `Localizations` ancestor the transform falls back to
locale-independent casing.** That is the case a consumer meets without noticing:
a bare widget test, or any subtree pumped outside a `MaterialApp` / `WidgetsApp`,
casts the Dart way. Wrap the subtree in `Localizations` when a test asserts
Turkish casing.

<a name="whitespace--wrapping"></a>
## Whitespace & Wrapping

Control how text handles whitespace and wrapping using `whitespace-` utilities.

<x-preview path="typography/whitespace_preview" size="md" source="example/lib/pages/typography/whitespace_preview.dart"></x-preview>

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
