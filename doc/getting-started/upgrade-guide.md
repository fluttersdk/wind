# Upgrade Guide

What changed between wind_kit versions and what to edit in your app when you upgrade.

- [Overview](#overview)
- [Moving to wind_kit](#moving-to-wind-kit)
- [1.8.x to 1.9.0](#one-eight-to-one-nine)
- [1.3.x to 1.4.0](#one-three-to-one-four)
- [1.0.x to 1.1.0](#one-zero-to-one-one)
  - [New, opt-in](#new-opt-in)
  - [Behavior changes to review](#behavior-changes)
  - [Action required](#action-required)
  - [Fixes you get for free](#free-fixes)

<a name="overview"></a>
## Overview

Wind follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html). A project pinned to `^1.0.0` resolves to the latest `1.x` automatically. Within a major version no public API is removed; a minor release can still change behaviour, flagged BREAKING (behaviour) in the changelog. This guide lists the per-version changes worth knowing about, newest first. If a section has no "Action required" entry, the upgrade is drop-in.

<a name="moving-to-wind-kit"></a>
## Moving to wind_kit

The package was renamed to `wind_kit`. To move an app over, replace the previous dependency name in `pubspec.yaml` with `wind_kit`, and replace the previous import with the new barrel:

```dart
import 'package:wind_kit/wind_kit.dart';
```

No `W*` or `Wind*` class changes, and every className token behaves as before. Do not depend on both packages in one app: each has its own `WindTheme` and `WindDebugRegistry`, so a `WDiv` from one finds no theme from the other.

<a name="one-eight-to-one-nine"></a>
## 1.8.x to 1.9.0

A minor release that changes behaviour, flagged BREAKING (behaviour) in the changelog, so a `^1.8.0` constraint picks it up on the next `pub get`.

**`tracking-*` is now em, as in Tailwind.** Letter spacing scales with the font size, so every `tracking-*` class renders differently.

**Action required for a custom `WindThemeData.tracking` map.** It is now read as em multipliers: a value written as pixels now means that many em, so convert it.

```dart
// Before: logical pixels
WindThemeData(tracking: {'tight': -1.0})

// After: a multiple of the font size (-1px on 14px text is about -0.07)
WindThemeData(tracking: {'tight': -0.07})
```

The built-in scale already holds Tailwind's values, so an app that uses only the default `tracking-*` classes needs no edit; check the few places where the tighter or wider spacing shows.

An arbitrary `tracking-[Nem]` is now em too (it was read as N pixels), and a negative arbitrary value now applies instead of being dropped.

<a name="one-three-to-one-four"></a>
## 1.3.x to 1.4.0

A minor release that changes behaviour, flagged BREAKING (behaviour) in the changelog.

**A single-line `WInput` defaults its Return key to `TextInputAction.done`** instead of `.next`. Multiline still defaults to `.newline`, and an explicit `textInputAction` still wins. Flutter implements `.next` as a move to the next focusable widget, not the next text field, so the old default could land on a button or a swatch. A form that relied on the old default gets it back per field:

```dart
WInput(
  textInputAction: TextInputAction.next,
)
```

<a name="one-zero-to-one-one"></a>
## 1.0.x to 1.1.0

A backward-compatible minor release. The headline additions are opt-in, so existing apps compile and render unchanged. One debug-only assertion and a few input behaviour changes are worth a quick scan.

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
- **Selection handles are Cupertino-style on every platform.** Previously Material-style on Android and web. The copy / cut / paste menu reads `WidgetsLocalizations`, so it works under any ancestor. Behaviour is identical; only the handle and toolbar appearance changes on Android and web.
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
