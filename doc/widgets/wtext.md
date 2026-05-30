# WText

A utility-first text widget that extends Flutter's `Text`, styling inline text through className utilities. The text content is passed as the first positional argument.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Supported Utility Classes](#supported-utility-classes)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/wtext" size="md" source="example/lib/pages/widgets/wtext.dart"></x-preview>

```dart
WText('Utility Styled Text', className: 'text-red-500 font-bold text-lg');
```

<a name="basic-usage"></a>
## Basic Usage

`WText` is the Wind equivalent of an HTML `<span>`. The text content is the first positional argument; every other parameter is named. All Flutter `Text` parameters are available, and when a parameter conflicts with a utility class, the explicitly passed parameter wins. Pass `selectable` in the className to render a `SelectableText` instead.

```dart
WText(
  'Styled Text',
  className: 'text-red-500 font-bold text-lg underline truncate max-lines-2',
);
```

<a name="constructor"></a>
## Constructor

```dart
WText(
  String data, {
  dynamic className,
  Key? key,
  TextStyle? style,
  StrutStyle? strutStyle,
  TextAlign? textAlign,
  TextDirection? textDirection,
  Locale? locale,
  bool? softWrap,
  TextOverflow? overflow,
  int? maxLines,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextHeightBehavior? textHeightBehavior,
  Color? selectionColor,
});
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:---|:---|:---|:---|
| `data` | `String` | **Required** (positional) | The text content to render. First positional argument. |
| `className` | `dynamic` | `null` | Wind utility class string applied to the text. |
| `style` | `TextStyle?` | `null` | Explicit text style; merged over and overriding utility-driven styling. |
| `strutStyle` | `StrutStyle?` | `null` | Strut style controlling minimum line height. |
| `textAlign` | `TextAlign?` | `null` | Text alignment; overrides any `text-left` / `text-center` / `text-right` / `text-justify` utility. |
| `textDirection` | `TextDirection?` | `null` | Direction in which the text flows. |
| `locale` | `Locale?` | `null` | Locale used to select region-specific glyphs. |
| `softWrap` | `bool?` | `null` | Whether the text wraps at soft line breaks; overrides overflow-derived wrapping. |
| `overflow` | `TextOverflow?` | `null` | Overflow handling; overrides any `truncate` / `text-clip` / `text-fade` utility. |
| `maxLines` | `int?` | `null` | Maximum number of lines; overrides any `max-lines-{n}` utility. |
| `semanticsLabel` | `String?` | `null` | Alternative semantics label read by accessibility tools. |
| `textWidthBasis` | `TextWidthBasis?` | `null` | How the text width is measured. |
| `textHeightBehavior` | `TextHeightBehavior?` | `null` | How leading is applied to the first and last lines. |
| `selectionColor` | `Color?` | `null` | Color of the selection highlight. |

<a name="supported-utility-classes"></a>
## Supported Utility Classes

| Class Type | Example | Documentation |
|:---|:---|:---|
| Responsive Design | `sm:text-xl`, `xs:text-sm` | [Responsive Design](../concepts/responsive-design.md) |
| Text Transform | `uppercase` | [Text Transform](../typography/text-transform.md) |
| Text Color | `text-blue-400` | [Text Color](../typography/text-color.md) |
| Font Weight | `font-bold` | [Font Weight](../typography/font-weight.md) |
| Font Size | `text-lg`, `text-[18]` | [Font Size](../typography/font-size.md) |
| Font Style | `italic` | [Font Style](../typography/font-style.md) |
| Line Height | `leading-6`, `leading-[20]` | [Line Height](../typography/line-height.md) |
| Text Decoration | `underline`, `line-through` | [Text Decoration](../typography/text-decoration.md) |
| Letter Spacing | `tracking-wide`, `tracking-[4]` | [Letter Spacing](../typography/letter-spacing.md) |
| Text Align | `text-center`, `text-justify` | [Text Align](../typography/text-align.md) |
| Padding | `p-4`, `pb-[6]` | [Padding](../spacing/padding.md) |
| Display Classes | `hide`, `show`, `sm:hide` | [Display](../layout/display.md) |

<a name="styling-examples"></a>
## Styling Examples

Utility-styled text:

```dart
WText('Utility Styled Text', className: 'text-red-500 font-bold text-lg dark:text-red-400');
```

Using explicit parameters (overrides utility classes):

```dart
WText(
  'Explicit Parameters',
  className: 'text-red-500 font-bold text-lg',
  // style overrides text-red-500 and font-bold
  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w300),
);
```

Truncated, selectable text:

```dart
WText(
  'A long line of selectable text that truncates after one line',
  className: 'selectable truncate max-lines-1 text-gray-800 dark:text-gray-200',
);
```

<a name="related-documentation"></a>
## Related Documentation
- [Text Color](../typography/text-color.md) — text color utilities.
- [Font Size](../typography/font-size.md) — font size utilities.
- [Text Align](../typography/text-align.md) — text alignment utilities.
- [WContainer](wcontainer.md) — wrap text in a styled box.
