# WDynamic

`WDynamic` renders a Flutter widget tree from a JSON/Map configuration at runtime, with built-in action handling and form state management.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [JSON Schema](#json-schema)
- [Action Handling](#action-handling)
- [State Management](#state-management)
- [Custom Builders](#custom-builders)
- [Security](#security)
- [Error Handling](#error-handling)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/w_dynamic_basic" size="md" source="example/lib/pages/widgets/w_dynamic_basic.dart"></x-preview>

```dart
WDynamic(
  json: const {
    'type': 'WDiv',
    'props': {
      'className': 'p-6 bg-white dark:bg-gray-800 rounded-xl shadow-sm'
    },
    'children': [
      {
        'type': 'WText',
        'props': {
          'text': 'Hello from JSON!',
          'className': 'text-xl font-bold text-gray-800 dark:text-gray-100'
        }
      },
    ],
  },
)
```

## Basic Usage

The `WDynamic` widget converts JSON/Map structures into live Flutter widgets. This enables server-driven UI, dynamic form generation, and runtime-configurable layouts without rebuilding your app.

```dart
WDynamic(
  json: const {
    'type': 'WDiv',
    'props': {'className': 'flex gap-4 p-4'},
    'children': [
      {
        'type': 'WButton',
        'props': {
          'className': 'bg-blue-500 text-white px-4 py-2 rounded',
          'onTap': {'action': 'submit'},
        },
        'children': [
          {'type': 'WText', 'props': {'text': 'Submit'}}
        ],
      }
    ],
  },
  actions: {
    'submit': (args) => print('Button tapped'),
  },
)
```

## Constructor

```dart
const WDynamic({
  Key? key,
  required Map<String, dynamic> json,
  Map<String, Function> actions = const {},
  WDynamicController? controller,
  Set<String>? denyWidgets,
  Map<String, WWidgetBuilder>? builders,
  Map<String, IconData>? customIcons,
  int maxDepth = 50,
  Widget Function(String type, Object error)? onError,
  Widget Function(String type, Map<String, dynamic> props)? onUnknownWidget,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `json` | `Map<String, dynamic>` | **Required** | JSON configuration defining the widget tree. Must include `type`, optional `props` and `children`. |
| `actions` | `Map<String, Function>` | `{}` | Action handlers keyed by name. Called when interactive widgets trigger events. |
| `controller` | `WDynamicController?` | `null` | Optional controller for external state access (read/write form values). |
| `denyWidgets` | `Set<String>?` | `null` | Widget types to remove from the default whitelist. |
| `builders` | `Map<String, WWidgetBuilder>?` | `null` | Custom widget builders keyed by type name. Signature: `Widget Function(Map<String, dynamic> props, List<Widget> children)`. |
| `customIcons` | `Map<String, IconData>?` | `null` | Custom icon mappings for `WIcon` widgets. Keys are icon names used in the JSON `icon` prop, values are `IconData` instances. Extends the default Material icon map. |
| `maxDepth` | `int` | `50` | Maximum recursion depth for nested widgets. Prevents infinite loops. |
| `onError` | `Widget Function(String, Object)?` | `null` | Error handler for widget build failures. Returns a fallback widget. |
| `onUnknownWidget` | `Widget Function(String, Map)?` | `null` | Handler for unknown or denied widget types. Returns a fallback widget. |

## JSON Schema

Every widget node in the JSON structure follows this format:

```dart
{
  'type': 'WidgetType',      // Required: Wind widget, Flutter widget, or custom builder
  'props': {                 // Optional: properties passed to the widget
    'className': 'flex gap-4',
    'text': 'Hello',
    'onTap': {'action': 'handleTap', 'args': {'id': 1}},
    'id': 'username',        // Auto-tracked form state key
  },
  'children': [              // Optional: nested widget array
    { /* child node */ }
  ]
}
```

### Type Field

The `type` field determines which widget to render:

- **Wind Widgets**: `WDiv`, `WText`, `WButton`, `WInput`, `WCheckbox`, `WSelect`, `WDatePicker`, `WIcon`, `WImage`, `WSvg`, `WPopover`, `WAnchor`, `WSpacer`
- **Flutter Widgets**: `Column`, `Row`, `Center`, `SizedBox`, `Expanded`, `Container`, `Wrap`, `Stack`, `Positioned`, `Padding`, `Align`, `Opacity`, `AspectRatio`, `FittedBox`, `ClipRRect`, `Spacer`
- **Custom Widgets**: Any key from the `builders` map

### Props Field

Widget properties are passed directly to the constructor. Common props include:

```dart
{
  'type': 'WDiv',
  'props': {
    'className': 'flex gap-4 p-6 bg-white rounded-xl',  // Wind utilities
    'id': 'formContainer',                              // Auto-tracked state key
  }
}
```

```dart
{
  'type': 'WText',
  'props': {
    'text': 'Welcome!',                    // Text content
    'className': 'text-lg font-bold',      // Wind utilities
  }
}
```

```dart
{
  'type': 'WInput',
  'props': {
    'id': 'email',                         // Auto-tracked in controller state
    'placeholder': 'Enter email...',
    'className': 'border rounded-lg',
  }
}
```

### Children Field

An array of nested widget nodes. Used by layout widgets like `WDiv`, `Column`, `Row`, etc.

```dart
{
  'type': 'WDiv',
  'props': {'className': 'flex gap-2'},
  'children': [
    {'type': 'WText', 'props': {'text': 'First'}},
    {'type': 'WText', 'props': {'text': 'Second'}},
  ]
}
```

## Action Handling

Interactive widgets like `WButton` can trigger actions defined in the `actions` map. Actions are referenced in the JSON using an object format.

### Action Format

```dart
{
  'type': 'WButton',
  'props': {
    'onTap': {
      'action': 'actionName',          // Required: key from actions map
      'args': {'key': 'value'}         // Optional: arguments passed to handler
    }
  }
}
```

### Action Signatures

Actions can accept arguments only, or both arguments and state:

```dart
// Simple: (Map<String, dynamic> args)
WDynamic(
  actions: {
    'showAlert': (Map<String, dynamic> args) {
      print('Alert: ${args['message']}');
    },
  },
)
```

```dart
// With state access: (Map<String, dynamic> args, WDynamicState state)
WDynamic(
  actions: {
    'submitForm': (Map<String, dynamic> args, WDynamicState state) {
      final email = state.get('email');
      final password = state.get('password');
      print('Submitting: $email');
    },
  },
)
```

### Example

```dart
WDynamic(
  json: const {
    'type': 'WButton',
    'props': {
      'className': 'bg-blue-500 text-white px-4 py-2 rounded',
      'onTap': {
        'action': 'increment',
        'args': {'step': 1}
      },
    },
    'children': [
      {'type': 'WText', 'props': {'text': 'Tap Me'}}
    ],
  },
  actions: {
    'increment': (Map<String, dynamic> args, WDynamicState state) {
      final step = args['step'] ?? 1;
      setState(() => count += step);
    },
  },
)
```

## State Management

`WDynamic` automatically tracks form widget values using the `id` prop. Values are stored in an internal state object accessible via `WDynamicController` or action handlers.

### Auto-Tracking with ID

Any widget with an `id` prop automatically stores its value in state:

```dart
{
  'type': 'WInput',
  'props': {
    'id': 'username',              // Auto-tracked
    'placeholder': 'Username...',
  }
}
```

### Using the Controller

Create a `WDynamicController` to access state externally:

```dart
final controller = WDynamicController();

// Pre-fill values
controller.setValue('email', 'user@example.com');

// Read values
final email = controller.getValue('email');
final allValues = controller.getAll();

// Listen for changes
final dispose = controller.addListener('email', (value) {
  print('Email changed: $value');
});

// Pass to WDynamic
WDynamic(
  controller: controller,
  json: myJson,
)

// Clean up
controller.dispose();
```

### Accessing State in Actions

Action handlers receive the state object as a second parameter:

```dart
WDynamic(
  json: const {
    'type': 'WDiv',
    'children': [
      {
        'type': 'WInput',
        'props': {'id': 'name', 'placeholder': 'Your name...'}
      },
      {
        'type': 'WButton',
        'props': {
          'onTap': {'action': 'greet'},
          'className': 'bg-green-500 text-white px-4 py-2 rounded',
        },
        'children': [
          {'type': 'WText', 'props': {'text': 'Greet'}}
        ],
      }
    ],
  },
  actions: {
    'greet': (args, state) {
      final name = state.get('name') ?? 'World';
      print('Hello, $name!');
    },
  },
)
```

## Custom Builders

Extend `WDynamic` with custom widget types using the `builders` prop.

### WWidgetBuilder Signature

```dart
typedef WWidgetBuilder = Widget Function(
  Map<String, dynamic> props,
  List<Widget> children,
);
```

### Example

```dart
WDynamic(
  json: const {
    'type': 'InfoCard',
    'props': {
      'title': 'Custom Widget',
      'subtitle': 'Built with a custom builder'
    },
  },
  builders: {
    'InfoCard': (Map<String, dynamic> props, List<Widget> children) {
      return WDiv(
        className: 'p-4 bg-blue-50 rounded-xl border border-blue-200',
        child: WDiv(
          className: 'flex items-center gap-3',
          children: [
            WIcon(Icons.info, className: 'text-blue-500 text-2xl'),
            WDiv(
              className: 'flex flex-col',
              children: [
                WText(props['title'] ?? '', className: 'font-bold text-blue-800'),
                WText(props['subtitle'] ?? '', className: 'text-sm text-blue-600'),
              ],
            ),
          ],
        ),
      );
    },
  },
)
```

Custom builders have priority over default widgets. You can override built-in widgets by providing a builder with the same type name.

### Custom Icons

Map string icon names to `IconData` for use in JSON `WIcon` widget nodes. Custom icons extend (not replace) the built-in Material icon map.

```dart
WDynamic(
  json: const {
    'type': 'WDiv',
    'props': {'className': 'flex gap-4 items-center'},
    'children': [
      {
        'type': 'WIcon',
        'props': {'icon': 'heart', 'className': 'text-red-500 text-2xl'},
      },
      {
        'type': 'WIcon',
        'props': {'icon': 'star', 'className': 'text-yellow-500 text-2xl'},
      },
    ],
  },
  customIcons: {
    'heart': Icons.favorite,
    'star': Icons.star,
    'settings': Icons.settings,
  },
)
```

## Security

`WDynamic` uses a whitelist approach for security. Only explicitly allowed widget types can be rendered.

### Default Whitelist

**Wind Widgets**:
- `WDiv`, `WText`, `WButton`, `WImage`, `WIcon`, `WAnchor`, `WInput`, `WCheckbox`, `WSvg`, `WSelect`, `WPopover`, `WDatePicker`, `WSpacer`

**Flutter Widgets**:
- `Column`, `Row`, `Center`, `SizedBox`, `Expanded`, `Container`, `Wrap`, `Stack`, `Positioned`, `Padding`, `Align`, `Opacity`, `AspectRatio`, `FittedBox`, `ClipRRect`, `Spacer`

### Denying Widgets

Remove specific widget types from the whitelist:

```dart
WDynamic(
  json: myJson,
  denyWidgets: const {'WButton', 'WInput'},  // Block buttons and inputs
)
```

### Unknown Widget Handler

Provide a fallback for unknown or denied widget types:

```dart
WDynamic(
  json: myJson,
  onUnknownWidget: (String type, Map<String, dynamic> props) {
    return WDiv(
      className: 'p-2 bg-red-100 border border-red-300 rounded',
      child: WText('Unknown widget: $type', className: 'text-red-700 text-sm'),
    );
  },
)
```

## Error Handling

Handle widget build failures gracefully with the `onError` callback.

```dart
WDynamic(
  json: myJson,
  onError: (String type, Object error) {
    return WDiv(
      className: 'p-4 bg-yellow-50 border border-yellow-300 rounded',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText('Error rendering $type', className: 'font-bold text-yellow-800'),
          WText(error.toString(), className: 'text-sm text-yellow-700'),
        ],
      ),
    );
  },
)
```

### Max Depth Protection

Prevent infinite recursion with the `maxDepth` prop (default: 50):

```dart
WDynamic(
  json: deeplyNestedJson,
  maxDepth: 100,  // Allow deeper nesting
)
```

When max depth is exceeded, rendering stops and returns an empty `SizedBox.shrink()` or calls `onError` if provided.

## Related Documentation

- [WDiv](./w-div.md) - Primary layout container
- [WButton](./w-button.md) - Interactive button widget
- [WInput](./w-input.md) - Text input widget
- [WSelect](./w-select.md) - Dropdown select widget
- [State Management](../core-concepts/state-management.md) - State handling in Wind
- [Dynamic Rendering](../core-concepts/dynamic-rendering.md) - Server-driven UI concepts
