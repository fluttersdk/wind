# WDynamic (server-driven UI)

JSON node tree → Wind widget tree. Reach for this file when rendering UI from a CMS, A/B framework, remote-config service, or any source where the widget shape is decided at runtime.

For static UI, write Dart directly. WDynamic is the right reach only when remote rendering is a hard requirement (server-driven layouts, ship-blocking releases avoided, dynamic forms from API schema, etc.).

## Contents

1. [JSON node schema](#1-json-node-schema)
2. [Allowed widget types](#2-allowed-widget-types)
3. [Constructor + lifecycle](#3-constructor--lifecycle)
4. [Props mapping (no auto-rename)](#4-props-mapping-no-auto-rename)
5. [State binding by `id`](#5-state-binding-by-id)
6. [Actions](#6-actions)
7. [Custom builders and icons](#7-custom-builders-and-icons)
8. [Security model](#8-security-model)
9. [Worked examples](#9-worked-examples)
10. [Known limitations](#10-known-limitations)

---

## 1. JSON node schema

Every node is a `Map<String, dynamic>` with one required field and two optional fields:

```json
{
  "type": "WDiv",
  "props": {
    "className": "flex flex-col gap-4 p-6",
    "id": "optional-id-for-state-binding",
    "onTap": {"action": "actionName", "args": {"key": "value"}}
  },
  "children": [
    {"type": "WText", "props": {"text": "Hello"}}
  ]
}
```

- `type` (required, String): the widget type name. Must match an allowed type (§2) or a registered custom builder (§7), or the node renders an error box.
- `props` (optional, `Map<String, dynamic>`): widget constructor arguments. Keys are widget-prop names exactly (no auto-rename; see §4).
- `children` (optional, `List<Map>`): nested nodes. Recursively processed depth-first.

`Map` values are converted to `Map<String, dynamic>` recursively, and so are the `Map` items of a `List`; mixed `Map<Object?, Object?>` payloads from JSON parsers are normalised automatically. A list nested directly inside a list stays raw.

Recursion depth is capped at `maxDepth: 50` by default; deeper trees render a red error widget at the threshold node.

---

## 2. Allowed widget types

The default whitelist covers the Wind widgets and Flutter core widgets below.

**Wind widgets** (use these as the primary surface; they consume className):

`WDiv`, `WText`, `WButton`, `WImage`, `WIcon`, `WAnchor`, `WInput`, `WCheckbox`, `WSvg`, `WSelect`, `WPopover`, `WDatePicker`, `WSpacer`

**Flutter core widgets** (escape hatches for layout primitives that Wind does not wrap):

`Column`, `Row`, `Center`, `SizedBox`, `Expanded`, `Container`, `Wrap`, `Stack`, `Positioned`, `Padding`, `Align`, `Opacity`, `AspectRatio`, `FittedBox`, `ClipRRect`, `Spacer`

**Not on the whitelist:** `WBadge`, `WCard`, `WSwitch`, `WRadio`, `WTabs`, plus the `WForm*` family, `WBreakpoint`, `WDynamic` itself, and `WKeyboardActions`. A JSON node naming one of them is treated as an unknown type and renders the error box, so do not reach for them in a payload. Register a custom builder (§7) when a server-driven tree genuinely needs one, for example `builders: {'WCard': (props, children) => WCard(className: props['className'], child: children.first)}`.

Extension via `builders:` constructor param adds new types (§7); these bypass the whitelist entirely.

Restriction via `denyWidgets: Set<String>` blocks specific defaults from a payload. Useful when accepting partially-trusted JSON that should not be allowed to render text inputs, for example.

---

## 3. Constructor + lifecycle

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
  Widget Function(String type, Map<String, dynamic> props)? onUnknownWidget,  // stand-in for a blocked or unknown type
  Widget Function(String type, Object error)? onError,                        // stand-in when a build throws
})
```

State ownership:
- If `controller` is provided, `WDynamic` does not own the underlying `WDynamicState` (consumer disposes).
- If `controller` is null, `WDynamic` creates a new `WDynamicState` internally and disposes on `dispose()`.

The `actions:` map is captured at construction; updating it requires rebuilding the widget. For dynamic action sets, route through a controller and dispatch via `WDynamicState.set(id, value)` inside a handler that delegates further.

---

## 4. Props mapping (no auto-rename)

Props keys follow the Wind widget constructor parameters, with renderer-specific names where the renderer differs from the constructor. A key the renderer does not read is dropped silently, and there is no snake_case → camelCase conversion.

| Node | Keys the renderer reads |
|---|---|
| `WDiv`, `WSpacer`, `WPopover` | `className` (`WPopover`: first child is the trigger, second the content) |
| `WText` | `text` (or `value`) for the string, `className` |
| `WButton` | `onTap` (action), `disabled`, `isLoading`, `className`; the first child is the content |
| `WAnchor` | `onTap` (action) only; `className` is not read; more than one child is wrapped in a `WDiv` |
| `WImage` | `src`, `className` |
| `WIcon` | `icon` (a built-in or `customIcons` name), `className` |
| `WSvg` | `svgContent` (raw markup) or `asset` (asset path), `className`; a node with neither, or with `src`, renders the fallback image icon |
| `WInput` | `id`, `value`, `type` (`text`, `email`, `password`, `number`, `multiline` or `textarea`; anything else is `text`), `placeholder`, `onChange` (action), `className` |
| `WCheckbox` | `id`, `checked` (or `value`), `onChange` (action), `className` |
| `WSelect` | `id`, `value`, `options`, `placeholder` (required: without it the node renders the error box), `onChange` (action), `className` |
| `WDatePicker` | `id`, `value` (ISO string), `placeholder` (default `Select a date`), `onChange` (action), `className` |

The Flutter core widgets read their own keys, all optional with the Flutter default when absent:

| Node | Keys the renderer reads |
|---|---|
| `Column`, `Row` | `mainAxisSize` (`max`, else `min`), `mainAxisAlignment` (`center`, `end`, `spaceBetween`, `spaceAround`, `spaceEvenly`, also hyphenated; else `start`), `crossAxisAlignment` (`start`, `end`, `stretch`, `baseline`; else `center`) |
| `SizedBox`, `Container` | `width`, `height` (`Container` builds a `SizedBox`: it has no colour, padding or decoration keys) |
| `Expanded`, `Spacer` | `flex` |
| `Wrap` | `spacing`, `runSpacing`, `alignment` |
| `Stack` | `alignment` (`topLeft` ... `bottomRight`, also hyphenated), `fit` (`expand`, `passthrough`) |
| `Positioned` | `top`, `bottom`, `left`, `right`, `width`, `height` |
| `Padding` | `padding` (all sides) or `top` / `bottom` / `left` / `right` |
| `Align` | `alignment`, `widthFactor`, `heightFactor` |
| `Opacity`, `AspectRatio` | `opacity`, `aspectRatio` |
| `FittedBox` | `fit` (`fill`, `cover`, `fitWidth`, `fitHeight`, `none` or `scaleDown`, also hyphenated; else `contain`), `alignment` |
| `ClipRRect` | `borderRadius` (a number) |
| `Center` | none; the first child is the content (the single-child nodes use the first child) |

The value widgets read `onChange`, not `onChanged`. Use the exact names above and in the worked examples (§9).

Right:
```json
{
  "type": "WInput",
  "props": {
    "id": "email",
    "type": "email",
    "placeholder": "you@example.com",
    "className": "rounded-lg p-3 border border-gray-300 dark:border-gray-600 focus:ring-2 focus:ring-blue-500"
  }
}
```

Wrong (silent drop because `class-name` / `place_holder` do not match Dart param names):
```json
{"type": "WInput", "props": {"class-name": "...", "place_holder": "..."}}
```

For nested objects (action descriptors, option lists, callbacks), see §6 (actions) and §9 (worked examples).

---

## 5. State binding by `id`

Widgets that maintain a value (WInput, WCheckbox, WSelect, WDatePicker) bind to `WDynamicState` via a string `id` prop. The value is stored in the state's internal map; reads and writes go through `state.get(id)` / `state.set(id, value)`.

Binding flow:
1. Widget mounts → reads `state.get(id)` for initial value.
2. User interacts → the widget calls `state.set(id, value)`. The `id` alone is enough; no `onChange` is required for the value to land in the store.
3. When the node also carries an `onChange` action, it dispatches after that write, with the new value injected into its args as `_value`. `WDatePicker` is the exception: its action dispatches with no injected value, so its handler reads the date from `state.get(id)`.
4. The state's `notifyListeners()` triggers a rebuild; widgets reading the same `id` reflect the new value.

A node with neither an `id` nor an `onChange` has nowhere to put a value and gets no callback at all, which is how a display-only control is expressed in JSON.

Programmatic mutation via controller:

```dart
final controller = WDynamicController();

WDynamic(
  json: schema,
  controller: controller,
  actions: {'submit': (args, state) => api.send(state.getAll())},
);

// Elsewhere:
controller.setValue('email', 'admin@example.com');
final value = controller.getValue('email');
final allValues = controller.getAll();

controller.addListener('email', (newValue) {
  // fires when 'email' changes
});

controller.reset();   // clears all values; notifies ChangeNotifier listeners only, not the per-id addListener callbacks
controller.dispose(); // when done (only if not passed to WDynamic that owns it)
```

`WDynamicState` is a `ChangeNotifier`; you can also subscribe at the state level. Listeners scoped by id receive only their own id's changes.

---

## 6. Actions

Actions reference handlers by string name in JSON. Handler resolution is dynamic at dispatch time.

JSON form:
```json
{"action": "incrementCounter", "args": {"step": 1}}
```

Constructor:
```dart
WDynamic(
  json: schema,
  actions: {
    'incrementCounter': (Map<String, dynamic> args, WDynamicState state) {
      final current = (state.get('counter') as int?) ?? 0;
      final step = (args['step'] as int?) ?? 1;
      state.set('counter', current + step);
    },
    'submit': (args, state) => api.submit(state.getAll()),
    'open': (args) => router.go(args['route'] as String),   // `router` is your own navigator
  },
);
```

Handler signature is auto-detected in order:
1. `Function(Map<String, dynamic>, WDynamicState)`: preferred when handler needs to read or mutate state
2. `Function(Map<String, dynamic>)`: pure action with no state access
3. Fallback `Function.apply(handler, [args, state])`: for handlers with unusual signatures

Unknown action names log `WindDynamic: Unknown action "<name>", ignored.` via `debugPrint` and return null. A handler that throws synchronously is caught and logged via `debugPrint('WindDynamic: Action "<name>" error: <err>')`. An async handler's `Future` is returned unawaited, so an error it throws later is not caught: handle it inside the handler. Neither case crashes the build.

Value actions (used by WInput, WCheckbox and WSelect; WDatePicker dispatches without an injected `_value`, see §5):
- The widget's `onChange` callback is wired through `parseValueAction<T>`.
- The changed value is injected into args as `_value`.
- If the widget also has an `id` prop, `state.set(id, value)` runs before the action dispatches, so the handler sees the updated state.

Example:
```json
{
  "type": "WInput",
  "props": {
    "id": "email",
    "onChange": {"action": "validateEmail", "args": {}}
  }
}
```

Handler:
```dart
'validateEmail': (args, state) {
  final value = args['_value'] as String?;     // the new text input value
  // state.get('email') == value already (set by parseValueAction)
}
```

Async actions can return `FutureOr<void>` but the dispatcher fires-and-forgets. There is no `await` on action dispatch.

---

## 7. Custom builders and icons

### Builders

Add a custom widget type by registering a `WWidgetBuilder`:

```dart
typedef WWidgetBuilder = Widget Function(Map<String, dynamic> props, List<Widget> children);

WDynamic(
  json: schema,
  builders: {
    'MyChart': (props, children) => MyChartWidget(
      data: props['data'] as List<num>,
      color: props['color'] as String?,
    ),
    'MarkdownBlock': (props, children) => Markdown(data: props['source'] as String),
  },
);
```

Then in JSON:
```json
{"type": "MyChart", "props": {"data": [1, 2, 3, 4], "color": "#3B82F6"}}
```

Custom builders bypass the whitelist entirely. If you register `MyChart`, it renders even if added to `denyWidgets`. Build the security model around your `builders:` map (don't accept builder definitions from untrusted JSON).

### Custom icons

Add icon names, or override a built-in one (the built-in names are listed below):

```dart
WDynamic(
  json: schema,
  customIcons: {
    'app-logo': Icons.flutter_dash_outlined,       // a new name
    'star': Icons.star_outlined,                   // overrides the built-in `star`
  },
);
```

In JSON:
```json
{"type": "WIcon", "props": {"icon": "app-logo", "className": "w-8 h-8 text-blue-500 dark:text-blue-400"}}
```

Built-in icon names (default fallback): `star`, `star_outline`, `home`, `person`, `check`, `close`, `settings`, `search`, `add`, `edit`, `delete`, `favorite`, `favorite_outline`, `mail`, `menu`, `info`, `warning`, `error`, `help`, `code`, `chevron_left`, `chevron_right`, `arrow_back`, `arrow_forward`. Names are matched case-insensitively (lowercased). Unknown names fall back to `Icons.help_outline`.

The `customIcons:` map merges with the built-in defaults; user keys override. Lookup uses the lowercased icon name, so write every `customIcons` key in lowercase: a key such as `myLogo` never matches.

---

## 8. Security model

`WDynamicConfig.isAllowed(type)` runs in priority order:
1. Custom builders win (always allowed; bypass everything).
2. `denyWidgets` blocks.
3. Default whitelist allows (the Wind and Flutter core types in §2).
4. Unknown type → `onUnknownWidget` callback if provided, else a red error widget.

Threat model considerations:
- **JSON source matters.** A controlled backend rendering a known schema is safe. Untrusted client input is not; even with whitelist enforcement, props can hold dangerous data (URLs that load attacker-controlled assets via `WImage(src:)`, action names that overlap with privileged handlers).
- **`builders:` is the escape hatch.** If you don't add custom builders, the surface is bounded by the default whitelist and the action handlers you registered. Action handlers run consumer Dart code; they are the trust boundary.
- **Action argument coercion is shallow.** `args['_value'] as String?` on an `onTap` action will succeed if the JSON sends `"_value": "<script>"`, because `onTap` passes the JSON args through, and so does a `WDatePicker` `onChange`, which uses `parseAction` (a handler there reads the selected date from state). The `onChange` of `WInput`, `WCheckbox` and `WSelect` overwrites `_value` with the real value. The script tag is just a string. But an `args['url']` that a handler passes to a URL launcher opens that URL. Validate inside the handler.
- **Recursion limit prevents stack overflow.** Default `maxDepth: 50` is plenty for legitimate UI; reduce for stricter bounds when accepting third-party JSON.

---

## 9. Worked examples

### A counter

```dart
WDynamic(
  json: {
    'type': 'WDiv',
    'props': {'className': 'flex flex-col gap-4 p-6'},
    'children': [
      {
        'type': 'WText',
        'props': {
          'id': 'counter',
          'text': '0',                 // initial; updated via state binding
          'className': 'text-4xl font-bold text-gray-900 dark:text-white',
        },
      },
      {
        'type': 'WButton',
        'props': {
          'className': 'bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600 text-white px-4 py-2 rounded-lg',
          'onTap': {'action': 'increment', 'args': {'step': 1}},
        },
        'children': [
          {'type': 'WText', 'props': {'text': 'Increment'}},
        ],
      },
    ],
  },
  actions: {
    'increment': (args, state) {
      final current = int.tryParse(state.get('counter') as String? ?? '0') ?? 0;
      final step = (args['step'] as int?) ?? 1;
      state.set('counter', (current + step).toString());
    },
  },
);
```

Note: the state write rebuilds the tree, but `WText` reads only `text` (or `value`) from its props and never looks up its `id` in the state, so the displayed `0` does not change. For a reactive counter display, listen via `WDynamicController` and rebuild the JSON with the new `text`, or use a stateful Dart widget that reads state.

### A form

```dart
final controller = WDynamicController();

WDynamic(
  controller: controller,
  json: {
    'type': 'WDiv',
    'props': {'className': 'flex flex-col gap-4 p-6 max-w-md mx-auto'},
    'children': [
      {
        'type': 'WInput',
        'props': {
          'id': 'email',
          'type': 'email',
          'placeholder': 'you@example.com',
          'className': 'rounded-lg p-3 border border-gray-300 dark:border-gray-600 focus:ring-2 focus:ring-blue-500',
        },
      },
      {
        'type': 'WInput',
        'props': {
          'id': 'password',
          'type': 'password',
          'placeholder': 'Password',
          'className': 'rounded-lg p-3 border border-gray-300 dark:border-gray-600 focus:ring-2 focus:ring-blue-500',
        },
      },
      {
        'type': 'WButton',
        'props': {
          'className': 'bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600 text-white px-6 py-3 rounded-lg',
          'onTap': {'action': 'submit', 'args': {}},
        },
        'children': [{'type': 'WText', 'props': {'text': 'Sign in'}}],
      },
    ],
  },
  actions: {
    'submit': (args, state) async {
      final result = await api.login(
        state.get('email') as String? ?? '',
        state.get('password') as String? ?? '',
      );
      // ...
    },
  },
);
```

### A select with options

```dart
// A child node for the `children` list of a parent node.
const Map<String, dynamic> countrySelect = {
  'type': 'WSelect',
  'props': {
    'id': 'country',
    'placeholder': 'Pick a country',
    'options': [
      {'value': 'tr', 'label': 'Türkiye'},
      {'value': 'us', 'label': 'United States'},
      {'value': 'de', 'label': 'Germany'},
    ],
    'onChange': {'action': 'pickCountry', 'args': {}},
    'className': 'rounded-lg p-3 border border-gray-300 dark:border-gray-600',
  },
};
```

Options accept maps with `value` and `label`, or plain strings (which become both value and label). Only `value` and `label` are read from an option map: `disabled` and `icon` are dropped. `WSelect` in JSON is a single-select with no search; its `searchable`, `isMulti`, `onSearch` and similar props are not read, so register a custom builder (§7) when a payload needs them.

---

## 10. Known limitations

- **Snake-case → camelCase**: not done. JSON keys must match Dart parameter names exactly.
- **WDatePicker action signature asymmetry**: uses `parseAction()` (no `_value` injection) instead of `parseValueAction<DateTime>()`. Handlers must read the new value from `state.get(id)`, not from `args['_value']`.
- **Async actions fire-and-forget**: the dispatcher does not await. Compose action handlers carefully; for sequenced operations, store intermediate state via `state.set()` and dispatch follow-up actions explicitly.
- **No partial re-render**: when `state.set(id, value)` runs, the entire JSON tree rebuilds (it's a single `setState` in the renderer). For high-frequency state, prefer Dart with targeted listeners.
- **No subtree caching**: `WDynamic` rebuilds the whole JSON-to-widget tree on each of its own builds (every state write and every rebuild of its parent), not on every frame; the WindStyle cache still applies to the styles.
- **`WText` is not reactive to state by `id`**: it reads `text` / `value` from its props only. To display a state value reactively, listen via `WDynamicController` from a Dart widget that wraps WDynamic.
- **`WSelect` needs `placeholder`**: a node without it renders the error box, whatever its options or value.
- **Several Wind widget constructor props are not exposed**: the renderer reads only the Wind widget keys in §4, so for example `WSelect` search, `WButton` `loadingText` and `WImage` `errorBuilder` are unreachable from JSON. Register a custom builder (§7) for those.

For static UI, Dart is faster, simpler, and easier to debug. Reach for WDynamic only when the use case actually requires runtime-defined trees.
