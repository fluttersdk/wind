# WFormCheckbox

A Wind-styled checkbox that integrates with Flutter's Form validation, providing built-in support for labels, hints, and error states.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w_form_checkbox" action="CREATE" -->
<!-- Description: Basic form checkbox with validation and label -->
<x-preview path="widgets/w_form_checkbox" size="md" source="example/lib/pages/widgets/w_form_checkbox.dart"></x-preview>

```dart
WFormCheckbox(
  value: _agreeTerms,
  onChanged: (v) => setState(() => _agreeTerms = v),
  labelText: 'I agree to Terms of Service',
  className: 'w-5 h-5 rounded border checked:bg-blue-500 error:border-red-500',
  validator: (value) => value != true ? 'You must agree to terms' : null,
)
```

## Basic Usage

The `WFormCheckbox` widget wraps a `WCheckbox` with a `FormField<bool>`. This allows you to use it directly inside a `Form` widget for easy validation and state management. When validation fails, it automatically triggers the `error:` state for its utility classes.

```dart
Form(
  key: _formKey,
  child: WFormCheckbox(
    labelText: 'Newsletter',
    hint: 'We will send you updates once a week.',
    value: isSubscribed,
    onChanged: (v) => setState(() => isSubscribed = v),
    validator: (v) => v == false ? 'Required' : null,
  ),
)
```

## Constructor

```dart
WFormCheckbox({
  Key? key,
  bool value = false,
  FormFieldValidator<bool>? validator,
  FormFieldSetter<bool>? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  ValueChanged<bool>? onChanged,
  String? className,
  String? iconClassName,
  bool disabled = false,
  IconData? checkIcon,
  Set<String>? states,
  Widget? label,
  String? labelText,
  String labelClassName = 'text-sm text-gray-700',
  String? hint,
  String hintClassName = 'text-gray-500 text-xs mt-1',
  bool showError = true,
  String errorClassName = 'text-red-500 text-xs mt-1',
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `bool` | `false` | The current value of the checkbox. |
| `className` | `String?` | `null` | Wind utility classes for the checkbox container. |
| `onChanged` | `ValueChanged<bool>?` | `null` | Callback when the value changes. |
| `labelText` | `String?` | `null` | Simple text label displayed next to the checkbox. |
| `label` | `Widget?` | `null` | Custom label widget (takes precedence over `labelText`). |
| `labelClassName` | `String` | `'text-sm text-gray-700'` | Styling for the text label. |
| `hint` | `String?` | `null` | Optional hint text displayed below the checkbox. |
| `hintClassName` | `String` | `'text-gray-500 text-xs mt-1'` | Styling for the hint text. |
| `showError` | `bool` | `true` | Whether to display validation error messages. |
| `errorClassName` | `String` | `'text-red-500 text-xs mt-1'` | Styling for the error message. |
| `iconClassName` | `String?` | `null` | Utility classes for the check icon. |
| `checkIcon` | `IconData?` | `null` | Custom icon to use when checked. |
| `disabled` | `bool` | `false` | Disables the checkbox and its label interaction. |

## Layout Modes

### Label & Hint Layout

`WFormCheckbox` automatically handles the layout of the checkbox, label, and hint/error text. It uses a vertical flex container where the checkbox and label are aligned horizontally, and the hint or error is positioned below them.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w_form_checkbox_layout" action="CREATE" -->
<!-- Description: Checkbox showing label and hint positioning -->
<x-preview path="widgets/w_form_checkbox_layout" size="md" source="example/lib/pages/widgets/w_form_checkbox_layout.dart"></x-preview>

```dart
WFormCheckbox(
  labelText: 'Receive notifications',
  hint: 'Enable to get push notifications on your device.',
  className: 'w-6 h-6',
)
```

## Event Handling

The `onChanged` callback is triggered whenever the user toggles the checkbox or clicks on the associated label. Since it's a `FormField`, it also integrates with standard form lifecycle events like `onSaved` and `validator`.

```dart
WFormCheckbox(
  value: _val,
  onChanged: (newValue) {
    print('Checkbox is now: $newValue');
    setState(() => _val = newValue);
  },
  onSaved: (v) => _model.termsAccepted = v ?? false,
)
```

## State Variants

`WFormCheckbox` supports all standard Wind state prefixes. Specifically, it activates the `error:` prefix when the form field validation fails.

```dart
WFormCheckbox(
  // Base style is gray, turns blue when checked, red on error
  className: 'border-gray-300 checked:bg-blue-500 error:border-red-500',
  validator: (v) => v != true ? 'Required' : null,
)
```

## Styling Examples

### Custom Colors and Sizes

You can easily customize the appearance of the checkbox and its icon using standard Tailwind-like classes.

```dart
WFormCheckbox(
  className: 'w-8 h-8 rounded-full border-2 border-indigo-200 checked:bg-indigo-600 checked:border-transparent',
  iconClassName: 'text-white text-xl',
  labelText: 'Large Indigo Checkbox',
  labelClassName: 'text-lg font-bold text-indigo-900',
)
```

### Error State Customization

You can control how the error message appears when validation fails.

```dart
WFormCheckbox(
  labelText: 'Agree to terms',
  errorClassName: 'text-orange-600 italic font-medium mt-2',
  validator: (v) => v != true ? 'This field is mandatory!' : null,
)
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `flex-col`, `items-start`, `gap-{n}` |
| Spacing | `p-{n}`, `m-{n}`, `pt-{n}`, `pl-{n}` |
| Sizing | `w-{size}`, `h-{size}`, `aspect-square` |
| Typography | `text-{color}`, `text-{size}`, `font-{weight}`, `italic` |
| Colors | `bg-{color}`, `border-{color}`, `checked:bg-{color}` |
| Borders | `border`, `border-{width}`, `rounded`, `rounded-{size}` |
| Form | `error:{utility}`, `disabled:{utility}` |

## Customizing Theme

You can define default styles for form components in your `WindThemeData`.

```dart
WindThemeData(
  // While WFormCheckbox doesn't have a specific theme object, 
  // it respects global color and spacing scales.
  colors: {
    'primary': Colors.blue,
    'danger': Colors.red,
  },
  baseSpacingUnit: 4.0,
)
```

## Related Documentation

- [WCheckbox](./w-checkbox.md) - The base checkbox component.
- [WFormInput](./w-form-input.md) - Form-integrated text input.
- [WAnchor](./w-anchor.md) - The wrapper used for label interactivity.
- [WDiv](./w-div.md) - The container used for layout.
