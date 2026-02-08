# WInput

The `WInput` widget is a utility-first form input that combines React-style controlled state management with Tailwind-like styling. It replaces the standard `TextField` with a more flexible, composable alternative.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-input-main" action="CREATE" -->
<!-- Description: A standard email input with custom border and focus ring -->
<x-preview path="widgets/w-input-main" size="md" source="example/lib/pages/widgets/w_input_main.dart"></x-preview>

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

## Basic Usage

The `WInput` widget manages its internal state but can be easily controlled using the `value` and `onChanged` properties. By default, it renders as a standard text input.

```dart
WInput(
  placeholder: 'Type something...',
  className: 'w-full p-2 border rounded',
  onChanged: (val) => print(val),
)
```

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
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes for the input field |
| `placeholderClassName` | `String?` | `null` | Utility classes for styling the hint text |
| `value` | `String?` | `null` | The controlled value of the input |
| `onChanged` | `ValueChanged<String>?` | `null` | Callback when text changes |
| `type` | `InputType` | `InputType.text` | Input keyboard and behavior (`text`, `password`, `email`, `number`, `multiline`) |
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

## Layout Modes

### Multiline Input

For text areas, set the `type` to `InputType.multiline`. You can control the height using `minLines` or standard sizing classes.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-input-multiline" action="CREATE" -->
<!-- Description: A multiline text area with fixed height and scrollable content -->
<x-preview path="widgets/w-input-multiline" size="md" source="example/lib/pages/widgets/w_input_multiline.dart"></x-preview>

```dart
WInput(
  type: InputType.multiline,
  minLines: 3,
  maxLines: 5,
  className: 'w-full p-4 border rounded-xl bg-gray-50',
  placeholder: 'Enter your message...',
)
```

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

## State Variants

Wind automatically manages `focus:` and `disabled:` states. You can also trigger custom states like `error:` by passing them to the `states` property.

```dart
WInput(
  states: _hasError ? {'error'} : {},
  className: 'border border-gray-300 focus:border-blue-500 error:border-red-500',
)
```

> [!NOTE]
> `focus:` styles (like `ring-2`) are applied automatically when the field gains focus.

## Styling Examples

### Search Input with Prefix

You can use the `prefix` prop to add icons while maintaining the utility-first styling of the input.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-input-search" action="CREATE" -->
<!-- Description: A rounded search input with a magnifying glass icon -->
<x-preview path="widgets/w-input-search" size="md" source="example/lib/pages/widgets/w_input_search.dart"></x-preview>

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

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Layout | `w-{size}`, `h-{size}`, `flex-1`, `w-full` |
| Spacing | `p-{n}`, `px-{n}`, `py-{n}`, `m-{n}` |
| Typography | `text-{size}`, `font-{weight}`, `italic`, `uppercase` |
| Colors | `bg-{color}`, `text-{color}` |
| Borders | `border`, `border-{n}`, `rounded-{size}`, `border-{color}` |
| Effects | `shadow-{size}`, `opacity-{n}`, `ring-{n}`, `ring-offset-{n}` |

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

## Related Documentation

- [WFormInput](./w-form-input.md) - Form-integrated input with labels and validation.
- [WButton](./w-button.md) - Interactive button component.
- [WText](./w-text.md) - Typography component.
