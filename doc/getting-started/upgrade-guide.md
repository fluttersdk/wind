# Upgrade Guide

- [Overview](#overview)
- [1.0.x to 1.1.0](#one-zero-to-one-one)
  - [New, opt-in](#new-opt-in)
  - [Behavior changes to review](#behavior-changes)
  - [Action required](#action-required)
  - [Fixes you get for free](#free-fixes)

<a name="overview"></a>
## Overview

Wind follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html). Within a major version, upgrades are backward compatible: a project pinned to `^1.0.0` resolves to the latest `1.x` automatically, and no public API is removed or renamed across minor releases. This guide lists the per-version changes worth knowing about, newest first. If a section has no "Action required" entry, the upgrade is drop-in.

<a name="one-zero-to-one-one"></a>
## 1.0.x to 1.1.0

A backward-compatible minor release. The headline additions are opt-in, so existing apps compile and render unchanged. One debug-only assertion and a few input behavior changes are worth a quick scan.

<a name="new-opt-in"></a>
### New, opt-in

These features do nothing until you use them.

**className aliases** (`WindThemeData.aliases`). Map a bare token to a full utility string and Wind expands it (recursively) before parsing, in every widget:

```dart
WindTheme(
  data: WindThemeData(
    aliases: {
      'row': 'flex flex-row',
      'col': 'flex flex-col',
      'center': 'items-center justify-center',
      'card': 'p-4 rounded-lg bg-white dark:bg-gray-800',
    },
  ),
  child: const MyApp(),
)

// then anywhere:
WDiv(className: 'row center', children: [...])
```

See [Theming: Aliases](../core-concepts/theming.md#aliases) for the full semantics (bare-token keys, recursion, shadowing, the empty default).

**`WIcon.foregroundColor`.** Pass a runtime `Color` directly instead of interpolating it into a `text-[#hex]` className, which would bloat the parser cache:

```dart
// category.color is a runtime value (for example from the database)
WIcon(Icons.star, foregroundColor: category.color, className: 'text-lg')
```

It overrides any `text-*` / `dark:text-*` from the className and stays out of the parser cache key, matching `WText.foregroundColor`.

**`WInput` read-only state.** `readOnly: true` now activates a `readonly` state, so `readonly:` prefixed classes style a read-only field the way `disabled:` styles a disabled one:

```dart
WInput(
  readOnly: true,
  value: 'Locked',
  className: 'p-3 rounded-lg bg-white dark:bg-gray-800 readonly:bg-gray-100 dark:readonly:bg-gray-700',
)
```

<a name="behavior-changes"></a>
### Behavior changes to review

No code change is required, but the rendered result differs in these cases.

- **`WInput` renders Material-free.** It now builds on `EditableText` inside a decorated `Container` instead of a Material `TextField`, so it no longer requires a `MaterialApp` ancestor and works under Cupertino, a custom root, or a bare `WidgetsApp`. If you relied on ambient Material `InputDecoration` theming bleeding into `WInput`, style it with `className` instead.
- **Selection handles are Cupertino-style on every platform.** Previously Material-style on Android and web. The copy / cut / paste menu reads `WidgetsLocalizations`, so it works under any ancestor. Behavior is identical; only the handle and toolbar appearance changes on Android and web.
- **`InputType.number` restricts input to a signed decimal on every platform.** A default formatter now allows digits, one decimal point, and an optional leading minus, so the field is numeric on web too (where the keyboard type alone enforces nothing). Supply your own `inputFormatters` to override the default.

<a name="action-required"></a>
### Action required

- **Do not pass both `value` and `controller` to `WInput`.** Supplying both was always a logic error (the controller silently won); it now throws an `AssertionError` in debug builds. Pick one: use `value` + `onChanged` for React-style binding, or a `controller` for imperative control.

```dart
// Before (silently used the controller, ignored value)
WInput(value: _text, controller: _controller)

// After: choose one
WInput(value: _text, onChanged: (v) => setState(() => _text = v))
// or
WInput(controller: _controller)
```

<a name="free-fixes"></a>
### Fixes you get for free

No action needed; these land automatically.

- Form widget labels, hints, and errors (`WFormInput`, `WFormSelect`, `WFormCheckbox`, `WFormDatePicker`) carry `dark:` pairs, so they stay legible in dark mode.
- A conditional `prefix` / `suffix` (for example a clear button that appears once the field has text) no longer drops focus on the first keystroke, and an appearing suffix no longer changes the field height.
- A disabled `WInput` (`enabled: false`) is fully non-interactive again and reports `isEnabled: false` to assistive technology.
- `WInput` emits a single clean `textField` semantics node instead of the previous double node.
