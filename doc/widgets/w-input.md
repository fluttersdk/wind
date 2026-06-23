# WInput

A utility-first form input that combines React-style controlled state management with Tailwind-like styling. It renders Material-free (`EditableText` core inside a `Container`) and works under any theming ancestor: Material, Cupertino, a custom app, or a bare `WidgetsApp`. No Material ancestor required (fixes #102).

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Accessibility](#accessibility)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="forms/input_basic" size="md" source="example/lib/pages/forms/input_basic.dart"></x-preview>

```dart
WInput(
  value: _email,
  onChanged: (value) => setState(() => _email = value),
  type: InputType.email,
  placeholder: 'Enter your email',
  className: 'p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500',
  placeholderClassName: 'text-gray-400 italic',
)
```

<a name="basic-usage"></a>
## Basic Usage

Pass `value` and `onChanged` for controlled (React-style) binding. Omit both to let the field manage its own state internally. `WInput` works under any ancestor widget tree. No `MaterialApp` required.

```dart
WInput(
  placeholder: 'Type something...',
  className: 'w-full p-2 border rounded',
  onChanged: (val) => print(val),
)
```

<a name="constructor"></a>
## Constructor

```dart
const WInput({
  Key? key,
  String? value,
  ValueChanged<String>? onChanged,
  InputType type = InputType.text,
  String? className,
  String? placeholderClassName,
  String? placeholder,
  bool enabled = true,
  bool readOnly = false,
  bool autofocus = false,
  TextInputAction? textInputAction,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onEditingComplete,
  VoidCallback? onTap,
  TapRegionCallback? onTapOutside,
  int? maxLines,
  int minLines = 1,
  FocusNode? focusNode,
  TextEditingController? controller,
  Set<String>? states,
  List<TextInputFormatter>? inputFormatters,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool autocorrect = true,
  bool enableSuggestions = true,
  Widget? prefix,
  Widget? suffix,
  String? semanticLabel,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes for the input field |
| `placeholderClassName` | `String?` | `null` | Utility classes for styling the hint text |
| `value` | `String?` | `null` | The controlled value of the input |
| `onChanged` | `ValueChanged<String>?` | `null` | Callback when text changes |
| `type` | `InputType` | `InputType.text` | Input keyboard and behavior (`text`, `password`, `email`, `number`, `multiline`). `number` restricts input to a signed decimal on every platform (web included); pass `inputFormatters` to override. |
| `placeholder` | `String?` | `null` | Hint text shown when input is empty |
| `enabled` | `bool` | `true` | Whether the input is interactive |
| `readOnly` | `bool` | `false` | Whether the input is read-only |
| `autofocus` | `bool` | `false` | Autofocus on mount |
| `textInputAction` | `TextInputAction?` | `null` | Keyboard action (e.g., `.done`, `.next`) |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Callback when action button is pressed |
| `onTapOutside` | `TapRegionCallback?` | `null` | Callback when tapping outside (useful for blur) |
| `maxLines` | `int?` | `null` | Max lines for multiline input |
| `minLines` | `int` | `1` | Min lines for multiline input |
| `prefix` | `Widget?` | `null` | Widget displayed before text |
| `suffix` | `Widget?` | `null` | Widget displayed after text |
| `controller` | `TextEditingController?` | `null` | Optional external controller |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling |
| `onEditingComplete` | `VoidCallback?` | `null` | Callback fired when the user finishes editing (loses focus, presses done, etc.) |
| `onTap` | `VoidCallback?` | `null` | Callback fired when the field is tapped |
| `focusNode` | `FocusNode?` | `null` | External focus controller for programmatic focus management |
| `inputFormatters` | `List<TextInputFormatter>?` | `null` | Formatters applied as the user types (digit-only, masks, etc.) |
| `textCapitalization` | `TextCapitalization` | `TextCapitalization.none` | Auto-capitalize behavior (`none` / `sentences` / `words` / `characters`) |
| `autocorrect` | `bool` | `true` | Enable OS autocorrect suggestions |
| `enableSuggestions` | `bool` | `true` | Enable OS suggestion bar (Android) |
| `semanticLabel` | `String?` | `null` | Accessible name for the single textbox semantics node. Falls back to `placeholder` when `null`. Used by screen readers and `getByLabel`-style locators. |

<a name="layout-modes"></a>
## Layout Modes

### Multiline Input

For text areas, set the `type` to `InputType.multiline`. You can control the height using `minLines` or standard sizing classes.

<x-preview path="widgets/w_input_multiline" size="md" source="example/lib/pages/widgets/w_input_multiline.dart"></x-preview>

```dart
WInput(
  type: InputType.multiline,
  minLines: 3,
  maxLines: 5,
  className: 'w-full p-4 border rounded-xl bg-gray-50',
  placeholder: 'Enter your message...',
)
```

<a name="event-handling"></a>
## Event Handling

`WInput` provides standard callbacks for user interaction. Use `onSubmitted` for handling "Enter" or keyboard action buttons.

```dart
WInput(
  className: 'border p-2',
  textInputAction: TextInputAction.search,
  onSubmitted: (value) {
    _performSearch(value);
  },
  onTapOutside: (_) => FocusScope.of(context).unfocus(),
)
```

<a name="state-variants"></a>
## State Variants

Wind automatically manages `focus:`, `disabled:` (when `enabled: false`), and `readonly:` (when `readOnly: true`) states. You can also trigger custom states like `error:` by passing them to the `states` property.

```dart
WInput(
  states: _hasError ? {'error'} : {},
  className: 'border border-gray-300 focus:border-blue-500 error:border-red-500',
)
```

> [!NOTE]
> `focus:` styles (like `ring-2`) are applied automatically when the field gains focus.

<a name="accessibility"></a>
## Accessibility

`WInput` emits exactly **one** typeable textbox semantics node. Its accessible name is `semanticLabel` when provided, falling back to `placeholder`. This single-node shape ensures label-by-text locators (e.g., Playwright `getByLabel`, `dusk` label lookup) resolve cleanly with no duplicate accessible names.

`InputType.password` fields report `isObscured: true` in the semantics tree so screen readers announce the field as a password input.

When the field is `enabled: false`, it is non-editable and reports `isReadOnly` in the semantics tree.

> [!NOTE]
> `WInput` supports native text selection (drag-select, double-tap word, long-press) with Cupertino-style selection handles on all platforms. This keeps `WInput` cupertino-only (no `package:flutter/material.dart` import) and consistent with the rest of Wind's own look. Interactive selection requires an `Overlay` ancestor (`MaterialApp` / `CupertinoApp` / `WidgetsApp` all provide one). Under a bare root with no `Overlay` (unusual in practice), typing and focus still work, but all interactive selection (drag-select, double-tap word, long-press, the drag handles, and the toolbar) is suppressed rather than throwing.

> [!NOTE]
> **Web:** Flutter renders to a canvas (CanvasKit or Skwasm) and does not use a native browser `<input>`. Mouse drag-select, double-click word, and keyboard copy (Ctrl+C / Cmd+C) all work through Flutter's own selection layer. Right-click opens the browser's native context menu by default (not WInput's selection toolbar). Apps that want WInput's selection toolbar on right-click can call `BrowserContextMenu.disableContextMenu()` once at startup; this is an app-level opt-in and not WInput behavior. No magnifier is shown on web.

> [!WARNING]
> Passing both `value` and `controller` at the same time throws an `AssertionError` in debug mode. Use either `value` + `onChanged` (controlled) or `controller` (external), not both.

<a name="styling-examples"></a>
## Styling Examples

### Search Input with Prefix

You can use the `prefix` prop to add icons while maintaining the utility-first styling of the input.

<x-preview path="widgets/w_input_search" size="md" source="example/lib/pages/widgets/w_input_search.dart"></x-preview>

```dart
WInput(
  prefix: Icon(Icons.search, color: Colors.gray),
  className: 'pl-10 p-2 bg-gray-100 rounded-full border-transparent focus:bg-white focus:border-blue-500',
  placeholder: 'Search...',
)
```

### Password Field

Use `InputType.password` to obscure text. You can use the `suffix` prop to add a visibility toggle.

```dart
WInput(
  type: _obscure ? InputType.password : InputType.text,
  suffix: IconButton(
    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
    onPressed: () => setState(() => _obscure = !_obscure),
  ),
  className: 'p-3 border rounded',
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Layout | `w-{size}`, `h-{size}`, `flex-1`, `w-full` |
| Spacing | `p-{n}`, `px-{n}`, `py-{n}`, `m-{n}` |
| Typography | `text-{size}`, `font-{weight}`, `italic`, `uppercase` |
| Colors | `bg-{color}`, `text-{color}` |
| Borders | `border`, `border-{n}`, `rounded-{size}`, `border-{color}` |
| Effects | `shadow-{size}`, `opacity-{n}`, `ring-{n}`, `ring-offset-{n}` |

<a name="customizing-theme"></a>
## Customizing Theme

You can override the default input appearance through `WindThemeData`. This is useful for setting global border colors or padding defaults.

```dart
WindThemeData(
  colors: {
    'input-border': Colors.blueGrey,
  },
  // WInput respects global spacing units for p-x classes
  baseSpacingUnit: 4.0, 
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WFormInput](./w-form-input.md) - Form-integrated input with labels and validation.
- [WButton](./w-button.md) - Interactive button component.
- [WText](./w-text.md) - Typography component.
