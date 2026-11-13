# Forms

Building forms with validation. Use this file when picking between raw `W*` and `WForm*`, wiring `FormState.validate()`, handling async / server-side errors, or working around the WFormDatePicker range gotcha.

## Contents

1. [Two widget families: raw vs FormField](#1-two-widget-families-raw-vs-formfield)
2. [Standard form skeleton](#2-standard-form-skeleton)
3. [Validator signatures and AutovalidateMode](#3-validator-signatures-and-autovalidatemode)
4. [The error: state and error styling](#4-the-error-state-and-error-styling)
5. [Async / server-side validation](#5-async--server-side-validation)
6. [Submit button enable/disable patterns](#6-submit-button-enabledisable-patterns)
7. [TextEditingController vs FormField](#7-texteditingcontroller-vs-formfield)
8. [WFormDatePicker range mode gotcha](#8-wformdatepicker-range-mode-gotcha)
9. [Multi-step / wizard forms](#9-multi-step--wizard-forms)
10. [The Return key and field-to-field advance](#10-the-return-key-and-field-to-field-advance)
11. [Anti-patterns](#anti-patterns)

---

## 1. Two widget families: raw vs FormField

| Family | When | Validation | Has `Form` ancestor? |
|---|---|---|---|
| `WInput`, `WSelect`, `WCheckbox`, `WDatePicker` | Standalone fields; external state library (Riverpod / Bloc / ChangeNotifier) manages value; bespoke validation in the controller | Caller inspects value and renders error UI manually | Not required |
| `WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker` | Multi-field forms with declarative validators and batch validate/save/reset | Auto: pass `validator: String? Function(T?)?`. The widget injects `error:` state when validation fails and renders error text below the field | Required (`Form` + `GlobalKey<FormState>`) |

Both families share the same className surface and visual output. The split is purely about validation flow.

`WInput` (and by extension `WFormInput`) uses native text selection: mouse-drag selects a substring, double-click or double-tap selects a word, and tapping the box moves the cursor. Selection handles (lollipop) and the Cut / Copy / Paste toolbar are drawn by Wind itself on every platform, light or dark to match the Wind theme, with no Material or Cupertino ancestor needed. An `Overlay` ancestor is required for interactive selection; without one, typing and focus still work but all interactive selection (drag-select, double-tap, long-press, handles, and toolbar) is suppressed. Both widget families are Material-free at their core (`EditableText`), so no Material ancestor is required for the input itself.

---

## 2. Standard form skeleton

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);
    try {
      await api.login(_emailController.text, _passwordController.text);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: WDiv(
        className: 'flex flex-col gap-4 p-6 max-w-md mx-auto',
        children: [
          WFormInput(
            controller: _emailController,
            label: 'Email',
            type: InputType.email,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            className: '''
              rounded-lg p-3 border
              border-gray-300 dark:border-gray-600
              bg-white dark:bg-gray-800
              focus:ring-2 focus:ring-blue-500
              error:border-red-500
            ''',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (!value.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          WFormInput(
            controller: _passwordController,
            label: 'Password',
            type: InputType.password,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            className: '''
              rounded-lg p-3 border
              border-gray-300 dark:border-gray-600
              bg-white dark:bg-gray-800
              focus:ring-2 focus:ring-blue-500
              error:border-red-500
            ''',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (value.length < 8) return 'Min 8 characters';
              return null;
            },
          ),
          WButton(
            onTap: _isSubmitting ? null : _submit,
            isLoading: _isSubmitting,
            className: '''
              bg-blue-600 hover:bg-blue-700
              dark:bg-blue-500 dark:hover:bg-blue-600
              text-white px-6 py-3 rounded-lg
              loading:bg-blue-400 loading:opacity-50
            ''',
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
```

Discipline:
- `_formKey` lives as a `final` field on `State`; never created inside `build`.
- Controllers disposed in `dispose()`. The widget creates internal controllers when external ones are null and disposes them itself; consumers passing controllers own the lifecycle.
- Submit button blocked via `onTap: _isSubmitting ? null : _submit` and `isLoading: _isSubmitting` (`onTap: null` blocks the tap, `isLoading` activates `loading:`; neither activates `disabled:`, so style the busy state with `loading:`).
- `mounted` check before `setState` in async paths.

---

## 3. Validator signatures and AutovalidateMode

Validator signature is `String? Function(T?)?` where `T` matches the FormField's type parameter:
- `WFormInput` → `String? Function(String?)`
- `WFormSelect<T>` → `String? Function(T?)`
- `WFormMultiSelect<T>` → `String? Function(List<T>?)`
- `WFormCheckbox` → `String? Function(bool?)`
- `WFormDatePicker` → `String? Function(DateTime?)`

Return `null` for valid, return a non-empty string for invalid. The string becomes `FormFieldState.errorText` and renders below the field via the built-in error widget.

`AutovalidateMode` (Flutter enum, passed to each WForm*):

| Value | Behaviour |
|---|---|
| `disabled` (default) | Validate only on explicit `_formKey.currentState!.validate()` call |
| `always` | Validate on every rebuild, even before user interaction; shows errors immediately on mount |
| `onUserInteraction` | Validate only after the user has changed the field at least once. **Default choice for most Wind forms.** |
| `onUnfocus` | Validate when the field loses focus |
| `onUserInteractionIfError` | Validate per keystroke only when an error is already showing; quiet until first error surfaces |

`Form` itself also accepts `autovalidateMode:` to propagate to all descendants; per-field `autovalidateMode:` overrides.

---

## 4. The `error:` state and error styling

When `FormFieldState.hasError` is true (the validator returned non-null), the widget injects `'error'` into the effectiveStates set and re-parses the className with that state active.

Style your inputs to react:

```dart
WFormInput(
  validator: ...,
  className: '''
    rounded-lg p-3 border
    border-gray-300 dark:border-gray-600
    bg-white dark:bg-gray-800
    focus:ring-2 focus:ring-blue-500
    error:border-red-500
    error:ring-1 error:ring-red-500
    error:bg-red-50 dark:error:bg-red-950
  ''',
)
```

Error text renders below the field in red by default. Override via `errorClassName:` (default `'text-red-500 dark:text-red-400 text-xs mt-1'`). Suppress entirely with `showError: false` (the `error:` state styling still applies; only the text is hidden).

Label and hint render around the input. Defaults, shared by every `WForm*` widget except where noted:
- `labelClassName: 'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1'` (`WFormCheckbox` uses `'text-sm text-gray-700 dark:text-gray-300'`, since its label sits beside the box)
- `hintClassName: 'text-gray-500 dark:text-gray-400 text-xs mt-1'`

Error text takes priority over hint when both would render.

---

## 5. Async / server-side validation

Flutter's `FormField.validator` is synchronous by design (`String? Function(T?)`), and the `WForm*` widgets take no `forceErrorText`. For asynchronous validation (server-side username availability, debounced API checks), keep the server message in your own state, have the validator return it, and call `validate()` again after the async work so the `error:` state fires.

Pattern, added to the `_LoginFormState` skeleton from section 2 (`api` is your own client, with a result that carries `isOk` and `message`):

```dart
String? _serverError;

Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;
  _formKey.currentState!.save();
  setState(() {
    _serverError = null;
    _isSubmitting = true;
  });
  final submitted = _emailController.text;
  try {
    final result = await api.createAccount(submitted);
    // The user may have edited the field while the request was pending: a response for an earlier value is stale.
    if (!mounted || _emailController.text != submitted) return;
    if (!result.isOk) {
      setState(() => _serverError = result.message);  // e.g. "Email already in use"
      _formKey.currentState!.validate();               // the validator below now returns it
      return;
    }
    // success
  } finally {
    if (mounted) setState(() => _isSubmitting = false);
  }
}
```

The email field from section 2 then reads the server message in its validator:

```dart
WFormInput(
  controller: _emailController,
  label: 'Email',
  type: InputType.email,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onChanged: (_) {
    if (_serverError != null) setState(() => _serverError = null);  // clear on edit
  },
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';

    return _serverError;                // the server message, until the user edits
  },
),
```

While `_serverError` is non-null:
- The validator returns it, so `FormState.validate()` returns `false` and the `error:` state is active.
- Clear it (set to `null`) when the user edits the field; with `autovalidateMode: onUserInteraction` the next keystroke re-validates and the field stops looking invalid mid-type.
- Compare the field's current text with the value you submitted before applying a response (the `submitted` check in `_submit`), so a failure for an earlier value never lands on the one the user has since typed.

---

## 6. Submit button enable/disable patterns

Flutter intentionally has no `FormState.isValid` getter (the PR was rejected to avoid silently showing errors). Two canonical patterns:

**Pattern A: validate-on-submit (default).** Button always enabled; submit calls `validate()` which shows errors if any.

```dart
WButton(
  onTap: () {
    if (_formKey.currentState!.validate()) {
      _submit();
    }
  },
  child: const Text('Submit'),
)
```

**Pattern B: live validate + rebuild.** Use `Form(onChanged:)` to rebuild on any field change; disable the button when validation would fail.

```dart
Form(
  key: _formKey,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onChanged: () => setState(() {}),                           // rebuild on field change
  child: ...,
)

WButton(
  onTap: _formKey.currentState?.validate() == true ? _submit : null,
  disabled: _formKey.currentState?.validate() != true,
  className: 'disabled:opacity-50 ...',
  child: const Text('Submit'),
)
```

Pattern B calls `validate()` on every rebuild, which shows errors visually. Pair with per-field `autovalidateMode: AutovalidateMode.onUserInteraction` so errors appear only on touched fields.

For most cases Pattern A is correct. Reach for B only when the form's submit is high-friction (long form, expensive submit, server side-effect) and the disabled state genuinely helps.

---

## 7. TextEditingController vs FormField

`WFormInput` accepts both `controller: TextEditingController?` and `initialValue: String?`. They do not conflict: when both are passed, the controller's text seeds the field and `initialValue` is ignored. `WFormInput` has no `value` prop. A raw `WInput` is stricter: passing both `value:` and `controller:` throws `AssertionError` in debug, so use `value` + `onChanged` for controlled binding or `controller` for imperative needs, never both.

Pass a controller when:
- You need to imperatively clear the field after submit: `_emailController.clear()`.
- You need to programmatically set the value (response from an autofill / suggestion).
- You need to listen to raw text changes for character-count or dependent-field logic.
- The form lives inside a `ListView.builder` or other lazy parent where the field may be disposed and rebuilt (the controller survives independent of FormField state).

Omit the controller when:
- The field is read once on submit via `onSaved`.
- The form is short-lived (single screen).
- `initialValue` covers the initial population case.

When you pass an external controller, you own its disposal. Wind keeps the two in sync: controller text → `FormFieldState.value` through a listener, and `FormFieldState.value` → controller text in `didUpdateWidget` (which is how `FormState.reset()` clears the field).

---

## 8. WFormDatePicker range mode gotcha

`WFormDatePicker extends FormField<DateTime>`. In single mode this is fine: validator sees `DateTime?`, save writes `DateTime?`.

In range mode, the internal `_currentRange: DateRange?` state holds the full range, but the FormFieldState only carries `range.start` as its value. Consequences:

- `validator: (DateTime? start) => ...` receives only the start date. Validators cannot inspect whether the range is complete or the end date.
- `_formKey.currentState!.save()` calls `onSaved` with only the start date.
- `onRangeChanged:` callback fires with the full `DateRange`; capture it in your own state if you need the range outside the picker.

Workaround if range completeness must be validated:

```dart
DateRange? _range;

WFormDatePicker(
  mode: WDatePickerMode.range,
  initialRange: _range,
  onRangeChanged: (range) => setState(() => _range = range),
  validator: (_) => _range?.isComplete == true ? null : 'Pick an end date',
)

void _reset() {
  _formKey.currentState!.reset();      // clears the picker's own range
  setState(() => _range = null);       // and the copy the validator reads
}
```

The validator reads your own `_range`, so the form's `validate()` returns false until the end date is picked. `FormState.reset()` clears only the picker's internal range, not your copy: reset through `_reset()` (or clear `_range` wherever you call `reset()`), or the validator keeps accepting an empty picker and a submit sends the previous range.

---

## 9. Multi-step / wizard forms

`Form` keys are scoped to their `Form` ancestor. For multi-step wizards:

- One `Form` per step, each with its own `GlobalKey<FormState>`.
- Validate the active step before advancing: `if (_stepKeys[_currentStep].currentState!.validate())`.
- Accumulate values across steps in `State` (a `Map<String, dynamic> _formData = {}` or per-step typed model).
- On final submit, validate all keys: `_stepKeys.every((k) => k.currentState!.validate())`.

For very long forms inside a `ListView.builder` (each row is a field), pass each field its own `controller` and listen on each; `Form` keys still work but the lazy rebuild means individual field state lifetimes are short. Controllers survive the rebuild.

---

## 10. The Return key and field-to-field advance

`WInput` / `WFormInput` resolve `textInputAction` to `TextInputAction.done` on a single-line field and `.newline` on a multiline one when you pass nothing. So Return closes the keyboard by default.

`.next` is an opt-in, and it is worth knowing what it actually does before reaching for it: Flutter implements `.next` as `focusNode.nextFocus()`, which moves to the next focusable widget rather than the next text field. A real form's traversal order runs through buttons, colour swatches, switches and segmented controls, so one Return dismisses the keyboard (the next focusable was a button, nothing editable took focus) while the Return on the field below it jumps past three fields into a textarea. Same key, same screen, two behaviours.

Pass `.next` only where you know the following focusable is the next input, and pass it per field rather than blanket-applying it, because only the form knows its own order:

```dart
WFormInput(
  label: 'Email',
  type: InputType.email,
  textInputAction: TextInputAction.next,     // the Password field is next in tree order
),
WFormInput(
  label: 'Password',
  type: InputType.password,
  textInputAction: TextInputAction.done,     // last field: submit-shaped
),
```

When the order is not a clean run of adjacent fields, do not try to fix it with `.next`. Reach for `WKeyboardActions` instead: it renders a toolbar above the keyboard whose Previous / Next buttons walk an explicit `focusNodes` list, so the advance order is data you control rather than a side effect of widget tree layout.

**That toolbar occludes, and `viewInsets` does not know it.** It is drawn in the root overlay at `bottom: viewInsets.bottom`, so it sits on top of the keyboard: the region a focused field has to clear is the keyboard plus the bar. `WKeyboardActions` measures its own bar and publishes the height as `WKeyboardToolbarInset.of(context)`, zero when none is up. `WInput` already adds it to the clearance it asks for, so a field needs nothing; reach for it in a widget of your own that positions something against the keyboard.

---

## Anti-patterns

| Wrong | Why | Right |
|---|---|---|
| `_formKey = GlobalKey<FormState>()` inside `build` | Recreates the key on every rebuild; loses form state | Declare as `final` field on `State` |
| `controller.dispose()` outside `dispose()` | Disposal must run in `dispose()` for safe lifecycle | Move to `dispose()` |
| `validator: async (v) => await check(v)` | Validator signature is sync; async returns get dropped | Keep the server message in your own state, return it from the validator and call `validate()` again after the async check |
| `setState` after `await` without `mounted` check | Sets state on a disposed widget; runtime error | `if (!mounted) return;` before `setState` |
| Validating range completeness via WFormDatePicker validator | Validator only sees `range.start` | Capture the range in `onRangeChanged` and have the validator read your own `_range` |
| Mixing `value:` and `controller:` on the same raw `WInput` | Throws `AssertionError` in debug (`value` is ignored when a controller is set) | Pick one: `value` + `onChanged`, or `controller` |
| Calling `_formKey.currentState!.validate()` to enable a button without rebuild | `currentState` is read at button construction; stale | Use `Form(onChanged: () => setState(() {}))` (Pattern B) |
