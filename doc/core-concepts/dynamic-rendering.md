# Dynamic Rendering

Build Flutter UIs from JSON at runtime. WDynamic turns a Map structure into a live widget tree with action handling and form state management.

- [Introduction](#introduction)
- [How It Works](#how-it-works)
- [JSON Schema](#json-schema)
- [Action System](#action-system)
- [Form State Management](#form-state-management)
- [Security & Whitelisting](#security-whitelisting)
- [Custom Widget Builders](#custom-widget-builders)
- [Custom Icons](#custom-icons)
- [Error Handling](#error-handling)
- [Related Documentation](#related-documentation)

<a name="introduction"></a>
## Introduction

Dynamic rendering, also known as Server-Driven UI, allows your backend to control the structure and behavior of your Flutter interface at runtime. Instead of hard-coding widget trees in Dart, you define them in JSON and let WDynamic convert them into live widgets.

This approach unlocks powerful capabilities:

- **CMS-driven layouts** - Non-technical teams can author UI configurations through admin panels.
- **A/B testing** - Experiment with different layouts without rebuilding your app.
- **Remote configuration** - Update UI elements instantly via API responses.
- **White-label apps** - Customize entire interfaces per client from a single codebase.

**Traditional approach:**
```dart
// Hard-coded widget tree
WDiv(
  className: 'flex gap-4 p-6',
  children: [
    WButton(onTap: handleSubmit, child: WText('Submit')),
  ],
)
```

**Dynamic approach:**
```dart
// JSON-driven widget tree
WDynamic(
  json: {
    'type': 'WDiv',
    'props': {'className': 'flex gap-4 p-6'},
    'children': [
      {
        'type': 'WButton',
        'props': {
          'onTap': {'action': 'handleSubmit'},
        },
        'children': [
          {'type': 'WText', 'props': {'text': 'Submit'}}
        ],
      },
    ],
  },
  actions: {'handleSubmit': (args, state) => print('Form: ${state.getAll()}')},
)
```

<a name="how-it-works"></a>
## How It Works

<x-preview path="widgets/w_dynamic_basic" size="lg" source="example/lib/pages/widgets/w_dynamic_basic.dart"></x-preview>

WDynamic follows a simple pipeline:

```
JSON Map → WDynamicRenderer → Widget Tree
```

The renderer parses your JSON configuration, validates widget types against a security whitelist, instantiates the corresponding Flutter widgets, and wires up action callbacks. All Wind utilities (className, responsive prefixes, state modifiers) work exactly as they do in statically-defined widgets.

Here's a basic example that renders a styled container with text:

```dart
WDynamic(
  json: {
    'type': 'WDiv',
    'props': {
      'className': 'p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm',
    },
    'children': [
      {
        'type': 'WText',
        'props': {
          'text': 'Hello from JSON!',
          'className': 'text-xl font-bold text-gray-800 dark:text-white',
        },
      },
    ],
  },
)
```

The output is identical to writing the equivalent `WDiv` and `WText` widgets directly in Dart.

<a name="json-schema"></a>
## JSON Schema

Every widget definition follows a consistent three-key structure:

```json
{
  "type": "WidgetType",
  "props": { /* widget properties */ },
  "children": [ /* nested widgets */ ]
}
```

### type

The widget class name as a string. Must be present in the default whitelist or registered via custom builders.

```dart
{'type': 'WDiv'}
{'type': 'WButton'}
{'type': 'Column'}  // Flutter core widgets also supported
```

### props

A map of properties specific to the widget type. Common properties include:

| Property | Description | Example |
|:---------|:------------|:--------|
| `className` | Wind utility classes | `"flex gap-4 p-6"` |
| `text` | Text content (WText) | `"Submit Form"` |
| `placeholder` | Input placeholder (WInput) | `"Enter email..."` |
| `id` | State tracking identifier | `"username"` |
| `onTap`, `onChange`, etc. | Action bindings | `{"action": "submit", "args": {...}}` |

```dart
{
  'type': 'WInput',
  'props': {
    'id': 'email',
    'placeholder': 'user@example.com',
    'className': 'border border-gray-300 rounded-lg p-3',
    'onChange': {'action': 'validateEmail'},
  },
}
```

### children

An array of nested widget definitions. Optional for widgets like `WText` or `WIcon`.

```dart
{
  'type': 'WDiv',
  'props': {'className': 'flex flex-col gap-2'},
  'children': [
    {'type': 'WText', 'props': {'text': 'First'}},
    {'type': 'WText', 'props': {'text': 'Second'}},
  ],
}
```

<a name="action-system"></a>
## Action System

Interactive widgets (buttons, inputs, checkboxes) trigger actions via props like `onTap`, `onLongPress`, `onDoubleTap`, `onChange`, and `onChanged`. Each action prop references a named handler registered in the `actions` map.

**Supported action props:**

- `onTap` - Single tap/click (WButton, WAnchor)
- `onLongPress` - Long press gesture (WButton, WAnchor)
- `onDoubleTap` - Double tap/click (WButton, WAnchor)
- `onChange` - Value change (WInput, WCheckbox, WSelect, WDatePicker)
- `onChanged` - Alias for onChange

**JSON syntax:**

```dart
{
  'onTap': {
    'action': 'actionName',
    'args': {'key': 'value'}
  }
}
```

**Handler signature:**

Action handlers support two signatures. Wind automatically detects which one you provide:

```dart
// Simple signature (args only)
(Map<String, dynamic> args) {
  print('Action triggered with ${args['key']}');
}

// Stateful signature (args + state)
(Map<String, dynamic> args, WDynamicState state) {
  final username = state.get('username');
  print('User $username clicked ${args['button']}');
}
```

**Complete example:**

```dart
WDynamic(
  json: {
    'type': 'WButton',
    'props': {
      'className': 'bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded',
      'onTap': {'action': 'submitForm', 'args': {'formId': 'login'}},
    },
    'children': [
      {'type': 'WText', 'props': {'text': 'Login'}}
    ],
  },
  actions: {
    'submitForm': (Map<String, dynamic> args, WDynamicState state) {
      final formId = args['formId'];
      final email = state.get('email');
      final password = state.get('password');
      print('Submitting $formId: email=$email');
    },
  },
)
```

> [!NOTE]
> If an action name is not found in the `actions` map, WDynamic logs a warning and continues silently. This prevents crashes from misconfigured JSON.

<a name="form-state-management"></a>
## Form State Management

Widgets with an `id` prop automatically register their values in a shared state store. This eliminates manual state wiring for form fields.

**Auto-tracked widgets:**

- `WInput` - Tracks text value
- `WCheckbox` - Tracks boolean checked state
- `WSelect` - Tracks selected value
- `WDatePicker` - Tracks DateTime value

**Accessing state from actions:**

```dart
WDynamic(
  json: {
    'type': 'WDiv',
    'props': {'className': 'flex flex-col gap-4'},
    'children': [
      {
        'type': 'WInput',
        'props': {
          'id': 'username',  // Auto-tracked
          'placeholder': 'Enter name...',
        },
      },
      {
        'type': 'WButton',
        'props': {
          'onTap': {'action': 'greet'},
        },
        'children': [
          {'type': 'WText', 'props': {'text': 'Greet'}}
        ],
      },
    ],
  },
  actions: {
    'greet': (args, state) {
      final name = state.get('username') ?? 'Guest';
      print('Hello, $name!');
    },
  },
)
```

**External state access with WDynamicController:**

The controller API allows you to read/write form values from outside the WDynamic widget:

```dart
final controller = WDynamicController();

// Pre-fill values
controller.setValue('email', 'user@example.com');
controller.setValue('newsletter', true);

// Pass to WDynamic
WDynamic(
  json: myFormJson,
  controller: controller,
  actions: myActions,
)

// Read values externally
final email = controller.getValue('email');
final allValues = controller.getAll();  // {'email': '...', 'newsletter': true}

// Listen for changes
final dispose = controller.addListener('email', (value) {
  print('Email changed: $value');
});

// Clean up
controller.dispose();
```

**State API reference:**

| Method | Description |
|:-------|:------------|
| `getValue(id)` | Get a single value by id |
| `setValue(id, value)` | Set a value (triggers listeners) |
| `getAll()` | Get all values as a map |
| `reset()` | Clear all values |
| `addListener(id, callback)` | Listen for changes to a specific id |

<a name="security-whitelisting"></a>
## Security & Whitelisting

Because JSON can come from untrusted sources (user input, third-party APIs), WDynamic uses a **whitelist-only** security model. Only explicitly allowed widget types can render.

**Default allowed widgets:**

Wind widgets:
- `WDiv`, `WText`, `WButton`, `WImage`, `WIcon`, `WAnchor`, `WInput`, `WCheckbox`, `WSvg`, `WSelect`, `WPopover`, `WDatePicker`, `WSpacer`

Flutter core widgets:
- `Column`, `Row`, `Center`, `SizedBox`, `Expanded`, `Container`, `Wrap`, `Stack`, `Positioned`, `Padding`, `Align`, `Opacity`, `AspectRatio`, `FittedBox`, `ClipRRect`, `Spacer`

**Restricting widgets:**

Use the `denyWidgets` parameter to remove specific types from the whitelist:

```dart
WDynamic(
  json: untrustedJson,
  denyWidgets: {'WButton', 'Stack'},  // Disable buttons and stacks
)
```

Any attempt to render a denied widget will trigger the `onUnknownWidget` callback or render an empty container.

**Why whitelist-only?**

Arbitrary widget instantiation could expose dangerous APIs (file system access, network calls, etc.). The whitelist ensures that only safe, layout-focused widgets can be dynamically rendered.

<a name="custom-widget-builders"></a>
## Custom Widget Builders

Extend WDynamic with your own widget types using the `builders` parameter:

```dart
WDynamic(
  json: {
    'type': 'ProfileCard',
    'props': {
      'name': 'Alice',
      'role': 'Engineer',
      'avatar': 'https://example.com/avatar.png',
    },
  },
  builders: {
    'ProfileCard': (Map<String, dynamic> props, List<Widget> children) {
      return WDiv(
        className: 'flex items-center gap-4 p-4 bg-white rounded-lg shadow',
        children: [
          WImage(props['avatar'], className: 'w-12 h-12 rounded-full'),
          WDiv(
            className: 'flex flex-col',
            children: [
              WText(props['name'] ?? '', className: 'font-bold'),
              WText(props['role'] ?? '', className: 'text-sm text-gray-600'),
            ],
          ),
        ],
      );
    },
  },
)
```

**Builder signature:**

```dart
typedef WWidgetBuilder = Widget Function(
  Map<String, dynamic> props,
  List<Widget> children,
);
```

Custom builders receive the parsed `props` map and any resolved `children` widgets. You can extract typed values, apply conditional logic, or compose complex layouts.

> [!WARNING]
> Custom builders bypass the security whitelist. Only register builders for widgets you trust. Never pass user-provided builder functions.

## Custom Icons

For `WIcon` widgets in your JSON, you can provide custom icon mappings without building a full custom widget builder. Use the `customIcons` prop to map string names to `IconData`:

```dart
WDynamic(
  json: {
    'type': 'WIcon',
    'props': {'icon': 'myCustomIcon'},
  },
  customIcons: {
    'myCustomIcon': Icons.star,
    'myOtherIcon': Icons.favorite,
  },
)
```

This is a lightweight alternative to custom builders when you only need to extend the icon library. See [WDynamic — Custom Icons](../widgets/w-dynamic.md#custom-icons) for complete configuration details.

<a name="error-handling"></a>
## Error Handling

WDynamic provides two callbacks for handling rendering failures:

**onUnknownWidget** - Called when a widget type is not in the whitelist:

```dart
WDynamic(
  json: {'type': 'UnsafeWidget', 'props': {}},
  onUnknownWidget: (String type, Map<String, dynamic> props) {
    return WText(
      'Widget "$type" not allowed',
      className: 'text-red-500 p-2 bg-red-50 rounded',
    );
  },
)
```

**onError** - Called when a widget build throws an exception:

```dart
WDynamic(
  json: myJson,
  onError: (String type, Object error) {
    return WDiv(
      className: 'p-4 bg-red-100 border border-red-300 rounded',
      child: WText('Error rendering $type: $error'),
    );
  },
)
```

Both callbacks are optional. If not provided, WDynamic renders an empty `SizedBox.shrink()` for failures.

**Maximum depth protection:**

To prevent infinite recursion or stack overflows from deeply nested JSON, WDynamic enforces a maximum depth limit (default: 50 levels):

```dart
WDynamic(
  json: deeplyNestedJson,
  maxDepth: 100,  // Increase if needed
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WDynamic Widget](../widgets/w-dynamic.md) - Full API reference
- [State Management](./state-management.md) - Interactive states and WAnchor
- [Utility-First Fundamentals](./utility-first.md) - Wind className syntax
- [WButton](../widgets/w-button.md) - Action-driven button widget
- [WInput](../widgets/w-input.md) - Form input with state tracking
