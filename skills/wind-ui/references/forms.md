# Forms with Wind UI

Forms in Wind use the native Flutter `Form` + `GlobalKey<FormState>` + `WForm*` widgets. Five `FormField` wrappers cover the common surfaces: `WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker`. Each auto-injects the `error:` state-prefix when validation fails, so error styling lives in className.

## The canonical form recipe

```dart
class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _acceptedTerms = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();  // fires onSaved callbacks
    // ... call your backend with _email, _password, _acceptedTerms
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: WDiv(
        className: 'flex flex-col gap-4 p-6 max-w-md mx-auto',
        children: [
          WFormInput(
            labelText: 'Email',
            type: InputType.email,
            placeholder: 'you@example.com',
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
            onSaved: (v) => _email = v,
            className: _inputClassName,
          ),
          WFormInput(
            labelText: 'Password',
            type: InputType.password,
            validator: (v) {
              if (v == null || v.length < 8) return 'At least 8 characters';
              return null;
            },
            onSaved: (v) => _password = v,
            className: _inputClassName,
          ),
          WFormCheckbox(
            labelText: 'I accept the terms',
            value: _acceptedTerms,
            onChanged: (v) => setState(() => _acceptedTerms = v),
            validator: (v) => v == true ? null : 'You must accept the terms',
          ),
          WButton(
            onTap: _submit,
            className: '''
              bg-blue-600 dark:bg-blue-700
              hover:bg-blue-700 dark:hover:bg-blue-600
              disabled:bg-gray-400 dark:disabled:bg-gray-600
              text-white px-4 py-3 rounded-lg
            ''',
            child: const WText('Sign up'),
          ),
        ],
      ),
    );
  }

  static const _inputClassName = '''
    px-3 py-2 rounded-lg
    border border-gray-300 dark:border-gray-600
    bg-white dark:bg-gray-800
    text-gray-900 dark:text-gray-100
    focus:border-blue-500 focus:ring-2 focus:ring-blue-200
    error:border-red-500 error:ring-2 error:ring-red-200
  ''';
}
```

## Validator signature

```dart
String? Function(T? value)
```

Return `null` to pass, return an error message string to fail. Wind renders the error string below the field automatically (controllable via `showError: false`).

```dart
// Common validators:
validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
validator: (v) => (v != null && v.length < 8) ? 'Too short' : null,
validator: (v) => (v != null && !RegExp(r'^.+@.+\..+$').hasMatch(v)) ? 'Bad email' : null,

// Cross-field validators run inside onSaved or onSubmit, NOT inside the validator
// (validators run independently per field).
```

## Auto-validate modes

| Mode | When validation fires |
|------|-----------------------|
| `AutovalidateMode.disabled` (default) | Only on explicit `_formKey.currentState!.validate()` call |
| `AutovalidateMode.onUserInteraction` | After the user first interacts with the field |
| `AutovalidateMode.always` | On every rebuild |

Pass per-field via `WFormInput(autovalidateMode: ...)` or per-form via `Form(autovalidateMode: ...)`. The per-field setting wins.

## Error styling via `error:` prefix

When `state.hasError` is true, Wind injects `error` into `activeStates`. Any className token prefixed `error:` activates:

```dart
className: '''
  px-3 py-2 rounded-lg
  border border-gray-300 dark:border-gray-600
  error:border-red-500 dark:error:border-red-400
  error:ring-2 error:ring-red-200 dark:error:ring-red-900
''',
```

The error message text renders below the field automatically. Style it via `errorClassName`:

```dart
WFormInput(
  errorClassName: 'text-red-500 dark:text-red-400 text-xs mt-1',
  // ...
)
```

To hide the auto-rendered error message and render your own custom message: `showError: false`.

## Label, hint, error rendering order

```
┌─────────────────────────┐
│  Label                  │  ← labelText / label widget
├─────────────────────────┤
│                         │
│  [WInput / WSelect ...] │  ← the field itself
│                         │
├─────────────────────────┤
│  Hint OR Error          │  ← hintText (hidden when hasError); state.errorText otherwise
└─────────────────────────┘
```

Three knobs:
- `labelText` (or `label: Widget`) + `labelClassName`
- `placeholder` (inside the field)
- `hint: Widget` + `hintClassName`
- error styled via `errorClassName`; hidden via `showError: false`

## Controller lifecycle for WFormInput

If you pass `controller`, you own its disposal. If you do not, `WFormInput` creates and owns it internally.

```dart
final _emailController = TextEditingController();

@override
void dispose() {
  _emailController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return WFormInput(
    controller: _emailController,
    // form state and controller stay in sync bidirectionally:
    //   - typing into the field updates form state via state.didChange()
    //   - calling _formKey.currentState!.reset() also clears the controller
    onSaved: (v) => _email = v,
  );
}
```

For one-off forms where you don't need programmatic access to the controller, omit it.

## Focus management

```dart
final _emailFocus = FocusNode();
final _passwordFocus = FocusNode();

@override
void dispose() {
  _emailFocus.dispose();
  _passwordFocus.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Form(
    key: _formKey,
    child: Column(children: [
      WFormInput(
        focusNode: _emailFocus,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => _passwordFocus.requestFocus(),
        // ...
      ),
      WFormInput(
        focusNode: _passwordFocus,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        // ...
      ),
    ]),
  );
}
```

`focusNode.requestFocus()` jumps focus programmatically. `focusNode.unfocus()` dismisses the keyboard.

## Multi-line input

```dart
WFormInput(
  type: InputType.multiline,
  minLines: 4,
  maxLines: 10,
  placeholder: 'Tell us about yourself',
  className: '''
    px-3 py-2 rounded-lg
    border border-gray-300 dark:border-gray-600
    bg-white dark:bg-gray-800
  ''',
)
```

`px-3` produces exactly 12 px horizontal inset (Wind overrides `OutlineInputBorder.gapPadding: 0.0` so `px-*` is exact — Material's default label-cutout reservation is bypassed). `maxLines: null` allows unbounded growth.

## WFormSelect / WFormMultiSelect

```dart
WFormSelect<String>(
  labelText: 'Country',
  initialValue: 'us',
  options: const [
    SelectOption(value: 'us', label: 'United States'),
    SelectOption(value: 'tr', label: 'Türkiye'),
    SelectOption(value: 'de', label: 'Germany'),
  ],
  searchable: true,
  searchPlaceholder: 'Search...',
  validator: (v) => v == null ? 'Pick a country' : null,
  onSaved: (v) => _country = v,
  className: _inputClassName,
);

// Multi:
WFormMultiSelect<String>(
  labelText: 'Languages',
  initialValue: const ['en'],
  options: _languageOptions,
  validator: (vs) => (vs == null || vs.isEmpty) ? 'Pick at least one' : null,
  onSaved: (vs) => _languages = vs,
);
```

## WFormCheckbox

The custom `_WFormCheckboxState` syncs external `value` changes through `didUpdateWidget`, so:

```dart
WFormCheckbox(
  value: _acceptedTerms,                              // external state
  onChanged: (v) => setState(() => _acceptedTerms = v),
  labelText: 'I accept the terms',
  validator: (v) => v == true ? null : 'Required',
  className: 'rounded border-gray-300 dark:border-gray-600',
  iconClassName: 'text-white',
)
```

## WFormDatePicker

Single date OR range mode.

```dart
WFormDatePicker(
  labelText: 'Birthday',
  initialValue: DateTime(2000, 1, 1),
  minDate: DateTime(1900),
  maxDate: DateTime.now(),
  validator: (v) => v == null ? 'Required' : null,
  onSaved: (v) => _birthday = v,
);

// Range:
WFormDatePicker(
  mode: DatePickerMode.range,
  labelText: 'Trip dates',
  initialRange: DateRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7))),
  onRangeChanged: (range) => setState(() => _tripRange = range),
);
```

In range mode, the form state holds only the range START for simple validators. Read the full `DateRange` from your `onRangeChanged` callback or the controller-bound state.

## Accessibility (a11y)

Every form widget supports `semanticLabel` (or inherits the visible label). Screen readers and E2E test tools (`getByLabel`, `getByRole`) resolve via the label.

```dart
WFormInput(
  labelText: 'Email',                  // visible label
  semanticLabel: 'Your email address', // screen reader label (optional override)
  type: InputType.email,
)
```

For Password fields, the input automatically reports `obscured: true` to the accessibility tree.

## Submit + reset cycle

```dart
// Inside onTap of the submit button:
if (!_formKey.currentState!.validate()) {
  return; // some validators failed; errors render automatically
}
_formKey.currentState!.save();  // fires all onSaved callbacks
// at this point: _email, _password, etc. are populated; call your backend.

// Reset everything (clears controllers + form state):
_formKey.currentState!.reset();
```

## Anti-patterns

| Wrong | Right |
|-------|-------|
| Validating inside `onChanged: (v) => validator(v)` manually | Use `autovalidateMode: AutovalidateMode.onUserInteraction` |
| Setting `_email = v` inside `onChanged` and never calling `.save()` | Use `onSaved: (v) => _email = v` + `.save()` after `.validate()` |
| Reading field value through your own controller after submit | Use `onSaved` callbacks; do not parallel-track state |
| Async validators that block | Validators MUST be sync (`String?`, not `Future<String?>`); for async checks, validate on submit with a separate API call |
| Cross-field validation in one field's `validator` | Put cross-field checks in your submit handler, not in `validator` |
| Forgetting to dispose controllers/focus nodes | `addTearDown` (tests) or `dispose()` (production); leaks accumulate |
| Not pairing `error:border-red-500` with `dark:error:border-red-400` | dark-mode pair is mandatory, error states included |
| Using `enabled: false` to disable a field while keeping it in the validation set | `enabled: false` skips validation for that field; if you want disabled-but-validated, set `readOnly: true` instead |
