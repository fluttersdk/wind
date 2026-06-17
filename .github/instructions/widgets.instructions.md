---
applyTo: lib/src/widgets/**
---
# Widget conventions (`lib/src/widgets/`)

## Canonical shape (stateless composition widgets)

The default is `StatelessWidget` + `const` constructor. Match this shape unless the widget needs lifecycle (focus, controller, overlay, animation):

```dart
class WFoo extends StatelessWidget {
  final String? className;
  final Widget? child;
  final List<Widget>? children;
  final Set<String>? states;

  const WFoo({
    super.key,                              // first param
    this.className,
    this.child,
    this.children,
    this.states,
    // ...feature props after the styling props
  }) : assert(child != null || children != null,
              'child XOR children, never both, never neither');
}
```

- `super.key` is the first positional, except `WText` where the required positional `data: String` precedes it (semantic content dominates).
- `child` XOR `children` is a hard invariant. Assert at construction.
- `className: String?` is the styling API. Parse it via `WindParser.parse(className!, context, states: activeStates)` inside `build`. Explicit Dart props (`backgroundColor`, `foregroundColor`) override the parsed style.
- `states: Set<String>?` activates `hover:` / `focus:` / `disabled:` / `loading:` / `selected:` / custom prefixed classes. Merge automatic state flags (`hover`, `focus`, etc.) into `activeStates` inside `build` before passing to the parser.

## StatefulWidget exceptions (only when warranted)

- `WInput` — manages `TextEditingController` + `FocusNode` lifecycle.
- `WSelect<T>` — overlay open/close + filter state.
- `WPopover` — overlay anchor state.
- `WDatePicker` — month navigation + range selection.
- `WKeyboardActions` — overlay toolbar visibility per focus change.
- `WindAnimationWrapper` — `AnimationController` + `vsync`.

`WFormInput` / `WFormSelect` / `WFormCheckbox` / `WFormDatePicker` extend `FormField<T>` and delegate `build` to an internal `_W{Form*}Content` stateful widget. The outer `FormField` stays `const`-constructible; lifecycle lives in `_content`.

## Debug logger (mandatory in stateless widgets)

Initialize early in `build`, after style resolution:

```dart
final logger = WindLogger(debug: styles.debug, widgetName: runtimeType.toString());
logger.logStep('ClassName', "'$className'");
logger.setCoreWidget(...);
// wrap calls between setCoreWidget and printFinalCode
logger.printFinalCode();
```

When `styles.debug == false` (the default), every logger method is a no-op — overhead is negligible. `WImage` is currently an outlier (logger initialized late); new widgets follow the canonical early-init pattern.

## WAnchor auto-wrapping

`WDiv` auto-wraps in `WAnchor` when className contains `hover:` / `focus:` / `active:`. `WButton` always wraps in `WAnchor`. State flags propagate via `WindAnchorStateProvider.of(context)` inside a `Builder`.

When a new widget needs interaction state from a className prefix, follow `WDiv`'s pattern (`_buildImpl` inside a `Builder`); do not bypass `WAnchor`.

`WButton` / `WAnchor` accept `semanticLabel: String?`, forwarded to the `Semantics` node wrapping the interactive surface. New WAnchor-based widgets expose and forward it the same way (matters for icon-only controls with no visible text).

## className multi-line

For 3+ concerns in one className, use triple-quoted strings, one concern per line, grouping `dark:` pairs beside their light variants:

```dart
className: '''
  flex flex-col gap-4
  p-6 rounded-lg
  bg-white dark:bg-gray-800
  border border-gray-200 dark:border-gray-700
  hover:shadow-lg
''',
```

## Container elision

A `Container` is emitted only when `styles.decoration != null` OR a non-empty `boxShadow` / `ringShadow` exists. Padding-only, text-only, and `shadow-none` paths must stay Container-free. `WindStyle.copyWith` must NOT fabricate an empty `BoxDecoration`, or the `decoration != null` gate breaks and every styled widget grows a needless Container.

## What never goes in `lib/src/widgets/`

- Test helpers — those live in `test/`.
- Pure parsing logic — that lives in `lib/src/parser/parsers/`.
- Theme defaults — those live in `lib/src/theme/defaults/`.
