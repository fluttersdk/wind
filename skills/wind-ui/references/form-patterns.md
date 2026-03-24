# Wind UI v1 Form Patterns

Wind UI v1 provides a powerful, Laravel-inspired form handling system when integrated with the Magic Framework. It automatically wires up form state, handles validation errors, and provides consistent styling through utility classes.

## MagicForm Overview

The core of the form system is `MagicFormData` and `MagicForm`. They work together to manage form state and provide a validation context without needing boilerplate `TextEditingController` management.

- `MagicFormData` holds form state, automatically infers types from initial values, and manages validation and controllers internally.
- `MagicForm` wraps the form, provides the validation context, and automatically handles error state styling when a backend validation error occurs.
- `WFormInput`, `WFormSelect`, and `WFormMultiSelect` auto-wire to the form state.

## Form Setup Pattern

A standard MagicForm implementation looks like this:

```dart
class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  // 1. Initialize MagicFormData
  final MagicFormData _formData = MagicFormData({
    'name': '',
    'email': '',
  });

  @override
  void dispose() {
    // 2. Always dispose
    _formData.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // 3. Validate before submission
    if (!_formData.validate()) return;
    
    final data = _formData.data;
    // Send to API
  }

  @override
  Widget build(BuildContext context) {
    // 4. Wrap with MagicForm
    return MagicForm(
      formData: _formData,
      child: WDiv(
        className: 'flex flex-col gap-6 p-4',
        children: [
          WFormInput(
            controller: _formData['name'],
            label: 'Full Name',
            placeholder: 'John Doe',
            className: 'w-full',
          ),
          WFormInput(
            controller: _formData['email'],
            label: 'Email Address',
            placeholder: 'john@example.com',
            type: InputType.email,
            className: 'w-full',
            // Example of a custom validator, standard rules are usually handled by the controller
            validator: (val) => val?.isEmpty ?? true ? 'Email is required' : null,
          ),
          WDiv(
            className: 'flex flex-row justify-end gap-3',
            children: [
              WButton(
                onTap: _handleSubmit,
                className: 'px-4 py-2 rounded-lg bg-primary text-white hover:bg-green-600',
                child: WText('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Form Field Widgets

### WFormInput API

`WFormInput` wraps Flutter's `FormField` to provide native validation support and automatic error state styling.

```dart
WFormInput(
  // Controller syncs with MagicFormData
  controller: _formData['password'],
  
  // Basic properties
  type: InputType.password,
  placeholder: 'Enter password',
  
  // Layout and Labels
  label: 'Password',
  labelClassName: 'text-sm font-medium text-gray-700 mb-1',
  hint: 'Must be at least 8 characters',
  hintClassName: 'text-gray-500 text-xs mt-1',
  
  // Styling
  className: 'px-3 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800',
  placeholderClassName: 'text-gray-400',
  errorClassName: 'text-red-500 text-xs mt-1', // Overrides hint on error
  
  // Validation (usually handles by ValidatesRequests in MagicController)
  validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
)
```

**Common Rules Syntax (if using Magic Framework validation):**
- `'required|email'`
- `'required|min:8|max:255'`
- `'numeric'`

### WFormSelect

`WFormSelect` is used for single-item dropdown selections. It pairs perfectly with Dart Enums that implement the `selectOptions` pattern.

```dart
// Example Enum
// enum MonitorType { http, ping; List<SelectOption<MonitorType>> get selectOptions => ... }

WFormSelect<MonitorType>(
  value: _selectedType,
  onChange: (val) => setState(() => _selectedType = val),
  options: MonitorType.http.selectOptions, // Use enum selectOptions pattern
  label: 'Monitor Type',
  searchable: true,
  className: 'w-full px-3 py-3 rounded-lg border border-gray-300 dark:border-gray-600',
)
```

### WFormMultiSelect

`WFormMultiSelect` handles selecting multiple options and optionally tagging/creating new options.

```dart
WFormMultiSelect<String>(
  values: _selectedTags,
  onMultiChange: (val) => setState(() => _selectedTags = val),
  options: _tagOptions,
  label: 'Tags',
  searchable: true,
  // CRITICAL: onCreateOption MUST call setState to add to options list
  onCreateOption: (String label) async {
    setState(() {
      _tagOptions.add(SelectOption(label: label, value: label));
    });
    return SelectOption(label: label, value: label);
  },
  className: 'w-full px-3 py-3 rounded-lg border border-gray-300 dark:border-gray-600',
)
```

### WKeyboardActions (iOS Numeric Keyboard)

iOS does not natively provide a "Done" button for numeric keyboards. `WKeyboardActions` wraps form inputs to add a toolbar with a Done button and navigation arrows.

```dart
final _timeoutFocus = FocusNode();

// Wrap your form or form section
WKeyboardActions(
  platform: 'ios', // Only needed on iOS
  focusNodes: [_timeoutFocus],
  child: WDiv(
    className: 'flex flex-col gap-4',
    children: [
      WFormInput(
        focusNode: _timeoutFocus, // Must attach FocusNode
        controller: _formData['timeout'],
        label: 'Timeout (seconds)',
        type: InputType.number,
        className: 'w-full px-3 py-3 rounded-lg border',
      ),
    ],
  ),
)
```

### Standalone WInput

For simple inputs that don't need form validation (e.g., a search bar), use `WInput` directly:

```dart
WInput(
  value: _searchQuery,
  onChanged: (value) => setState(() => _searchQuery = value),
  type: InputType.text,
  placeholder: 'Search...',
  className: 'flex-1 px-3 py-2 rounded-lg bg-gray-100 dark:bg-gray-800',
  placeholderClassName: 'text-gray-400',
)
```

## Form Styling Patterns

### Standard Input Styling
```dart
className: 'px-3 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800'
```
*Note: We use `py-3` to ensure adequate touch targets on mobile.*

### Error State Styling
When a form field fails validation, it automatically receives the `error` state. Use `error:` prefixed classes to style it:
```dart
className: '... error:border-red-500 error:bg-red-50 dark:error:bg-red-900/10'
```

### Search Bar Styling
```dart
className: 'flex-1 px-3 py-2 rounded-lg bg-gray-100 dark:bg-gray-800'
```

## Form Layout Patterns

### Stacked Layout (Mobile Default)
```dart
WDiv(
  className: 'flex flex-col gap-6',
  children: [ /* Form Fields */ ],
)
```

### Two-Column Layout (Desktop)
```dart
WDiv(
  className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
  children: [ /* Form Fields */ ],
)
```

### Section with Header
```dart
WDiv(
  className: 'flex flex-col gap-4',
  children: [
    WText('Settings', className: 'text-lg font-bold text-gray-900 dark:text-white'),
    // Section Fields
  ],
)
```

## Complete Examples

### 1. Login Form

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final MagicFormData _form = MagicFormData({
    'email': '',
    'password': '',
  });

  bool _isLoading = false;

  void _login() {
    if (!_form.validate()) return;
    setState(() => _isLoading = true);
    // Perform login
  }

  @override
  Widget build(BuildContext context) {
    return MagicForm(
      formData: _form,
      child: WDiv(
        className: 'flex flex-col gap-6 p-6 max-w-sm mx-auto',
        children: [
          WText('Welcome Back', className: 'text-2xl font-bold text-center mb-4'),
          WFormInput(
            controller: _form['email'],
            label: 'Email',
            type: InputType.email,
            placeholder: 'you@example.com',
            className: 'w-full px-3 py-3 rounded-lg border border-gray-300 dark:border-gray-600 error:border-red-500',
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          WFormInput(
            controller: _form['password'],
            label: 'Password',
            type: InputType.password,
            placeholder: '••••••••',
            className: 'w-full px-3 py-3 rounded-lg border border-gray-300 dark:border-gray-600 error:border-red-500',
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          WButton(
            onTap: _login,
            isLoading: _isLoading,
            className: 'w-full py-3 mt-4 rounded-lg bg-primary text-white font-medium hover:bg-green-600',
            child: WText('Log In'),
          ),
        ],
      ),
    );
  }
}
```

### 2. Create/Edit Form with Mixed Fields and Keyboard Actions

```dart
class MonitorCreateForm extends StatefulWidget {
  @override
  State<MonitorCreateForm> createState() => _MonitorCreateFormState();
}

class _MonitorCreateFormState extends State<MonitorCreateForm> {
  final MagicFormData _form = MagicFormData({
    'name': '',
    'url': '',
    'interval': '60',
  });
  
  MonitorType _selectedType = MonitorType.http;
  final _intervalFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // 1. Wrap entire form content with WKeyboardActions for iOS numeric inputs
    return WKeyboardActions(
      platform: 'ios',
      focusNodes: [_intervalFocus],
      child: MagicForm(
        formData: _form,
        child: WDiv(
          className: 'flex flex-col gap-6 p-4',
          children: [
            // 2. Standard Text Input
            WFormInput(
              controller: _form['name'],
              label: 'Monitor Name',
              placeholder: 'Production API',
              className: 'w-full px-3 py-3 rounded-lg border border-gray-300 error:border-red-500',
            ),
            
            // 3. Select Dropdown (using Enum selectOptions pattern)
            WFormSelect<MonitorType>(
              value: _selectedType,
              onChange: (v) => setState(() => _selectedType = v ?? MonitorType.http),
              options: MonitorType.http.selectOptions,
              label: 'Type',
              className: 'w-full px-3 py-3 rounded-lg border border-gray-300',
            ),
            
            // 4. Numeric Input requiring WKeyboardActions focus node
            WFormInput(
              controller: _form['interval'],
              focusNode: _intervalFocus, // CRITICAL: Link to WKeyboardActions
              label: 'Check Interval (seconds)',
              type: InputType.number,
              className: 'w-full px-3 py-3 rounded-lg border border-gray-300 error:border-red-500',
            ),
            
            // 5. Submit Action
            WDiv(
              className: 'flex flex-row justify-end mt-4',
              children: [
                WButton(
                  onTap: () => print('Submitting: ${_form.data}'),
                  className: 'px-6 py-2 rounded-lg bg-primary text-white hover:bg-green-600',
                  child: WText('Create Monitor'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. Settings/Filter Form (Compact)

```dart
class FilterForm extends StatefulWidget {
  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  String _status = 'all';
  List<String> _tags = [];
  final List<SelectOption<String>> _tagOptions = [
    SelectOption(label: 'Production', value: 'prod'),
    SelectOption(label: 'Staging', value: 'staging'),
  ];

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col md:flex-row gap-4 p-4 bg-gray-50 rounded-lg',
      children: [
        // Compact Select
        WFormSelect<String>(
          value: _status,
          onChange: (v) => setState(() => _status = v ?? 'all'),
          options: [
            SelectOption(label: 'All Statuses', value: 'all'),
            SelectOption(label: 'Up', value: 'up'),
            SelectOption(label: 'Down', value: 'down'),
          ],
          className: 'w-full md:w-48 px-3 py-2 rounded-lg border border-gray-200 bg-white',
        ),
        
        // Compact Multi-select with Tagging
        WFormMultiSelect<String>(
          values: _tags,
          onMultiChange: (v) => setState(() => _tags = v),
          options: _tagOptions,
          searchable: true,
          placeholder: 'Filter by tags...',
          onCreateOption: (label) async {
            setState(() {
              _tagOptions.add(SelectOption(label: label, value: label));
            });
            return SelectOption(label: label, value: label);
          },
          className: 'flex-1 px-3 py-2 rounded-lg border border-gray-200 bg-white',
        ),
      ],
    );
  }
}
```