---
applyTo: '{lib/src/dynamic,test/dynamic}/**'
---
# Dynamic JSON renderer (`lib/src/dynamic/`)

`WDynamic` renders Flutter widget trees from JSON. Pieces:

- `WDynamic` — the StatefulWidget consumers use. Composes the other parts.
- `WDynamicConfig` — security + customization (denyWidgets, builders, customIcons, maxDepth, callbacks).
- `WDynamicState` — id-keyed value store + listeners (`ChangeNotifier`).
- `WDynamicController` — wraps external state; tracks `_ownsState` to gate disposal.
- `WActionHandler` — bridges JSON actions to Dart callbacks; handles `_value` injection.
- `WDynamicRenderer` — the dispatch loop; one giant switch over `type` strings.

## JSON schema

```json
{
  "type": "WText",
  "props": {
    "text": "Hello",
    "className": "text-lg",
    "id": "greeting",
    "onTap": {"action": "navigate", "args": {"route": "/home"}}
  },
  "children": [...]
}
```

- `type` (String, REQUIRED) — must be in the whitelist (`defaultWindWidgets` ∪ `defaultFlutterWidgets` ∪ `config.builders.keys`) and not in `denyWidgets`.
- `props` (Map, optional) — widget-specific. `className`, `id`, action props, and per-widget config live here.
- `children` (List, optional) — nested widget definitions.

## Security model (whitelist first)

Order of resolution in `WDynamicConfig.isAllowed(type)`:
1. `config.builders[type]` — custom builder always wins.
2. `config.denyWidgets.contains(type)` — explicit block; emits error widget.
3. Default whitelist (13 Wind widgets + 16 Flutter core).

Untrusted JSON: pass `denyWidgets` for surfaces a remote source must not invoke (e.g., `'Container'` if you don't trust raw boxes). Always set `maxDepth` (default 50) — recursion bomb mitigation.

## State binding (`id`-keyed widgets)

`WInput`, `WCheckbox`, `WSelect`, `WDatePicker` with `props.id` read initial value from `state.get(id)` and write back on change. Reactive: same `id` from another widget triggers a rebuild via `WDynamicState`'s `addIdListener`.

External vs internal state ownership:
- `WDynamic(controller: WDynamicController())` — `_ownsState = false`; the host owns disposal.
- `WDynamic(...)` no controller — `_ownsState = true`; `WDynamic` creates the state and disposes it.

## Action dispatch

JSON actions are `{action: 'name', args: {...}}` objects. Two parser variants:

- `parseAction(actionProp)` → `VoidCallback?` — for `onTap`, `onPressed`. No value injection.
- `parseValueAction<T>(actionProp, stateId)` → `ValueChanged<T>?` — for `onChange`. Updates state if `stateId` is non-null, injects the value under `_value` key, then dispatches with merged args.

Handler signatures `WActionHandler` accepts:
- `(Map<String, dynamic> args)` — most common
- `(Map<String, dynamic> args, WDynamicState state)` — when the handler needs state access

Unknown action names are silently ignored (debugPrint only). Handler exceptions are caught + logged.

## Error handling

- `depth > config.maxDepth` → red error widget "Recursion depth exceeded {maxDepth}".
- Disallowed `type` → `config.onUnknownWidget(type, props)` if provided, else red error "Widget type not allowed".
- Per-type build exception → `config.onError(type, error)` if provided, else red error with the exception text.
- Null / empty JSON → `SizedBox.shrink()`.

## Known bugs (test-documented)

- **`WSelect<String>` + null value crash.** When `WSelect` receives simple string options and no initial `value`, the renderer infers `WSelect<String>`; the state-init expects non-nullable `String` and throws `type 'Null' is not a subtype of type 'String'`. The renderer's per-type catch path swallows it and emits the red error widget. Workaround for consumers: pass map-typed options or an explicit initial value. Out-of-scope follow-up to fix renderer-side.
- **`WDatePicker.onChange` API asymmetry (not a defect).** The renderer DOES write the selected date to state before dispatch (`state.set(id, date)` then the action callback). The asymmetry is delivery: because `_buildWDatePicker` uses `parseAction(props['onChange'])` rather than `parseValueAction<DateTime>`, the `DateTime` arrives via `state.get(id)`, not via the action `args._value`. Callers read the date from state inside the handler. Inconsistent with WInput/WCheckbox/WSelect, which inject `_value`; documented for awareness.

## Custom widgets via `builders`

```dart
WDynamic(
  json: { 'type': 'CustomCard', 'props': {...}, 'children': [...] },
  builders: {
    'CustomCard': (props, children) => Card(child: Column(children: children)),
  },
);
```

Custom builders bypass the whitelist; they ARE the whitelist for their type. Use this for tenant-specific widget extensions.

## Custom icons via `customIcons`

`WIcon` inside JSON resolves icon names through `_parseIcon`. 24 built-in mappings (`home`, `star`, `person`, ...). Override or extend via `customIcons` map: `{ 'rocket': Icons.rocket_launch }`.

## What never goes in `lib/src/dynamic/`

- General widget building — that belongs in `lib/src/widgets/`.
- Parser logic — that's `lib/src/parser/`.
- Hard-coded action handlers — actions are user-injected; the renderer just dispatches.
