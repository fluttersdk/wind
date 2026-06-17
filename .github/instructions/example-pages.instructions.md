---
applyTo: example/lib/pages/**
---
# Example page conventions (`example/lib/pages/`)

Each page demonstrates ONE widget or ONE concept thoroughly. Files are referenced by `doc/` via `<x-preview source="...">` — stable file paths matter.

## Naming

- File: `{feature_name}.dart` (snake_case). E.g., `button_basic.dart`, `w_button_centered.dart`, `installation_basic.dart`.
- Class: `{FeatureName}ExamplePage` (PascalCase). E.g., `ButtonBasicExamplePage`, `WButtonCenteredExamplePage`.

## Shape

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FooBasicExamplePage extends StatefulWidget {
  const FooBasicExamplePage({super.key});

  @override
  State<FooBasicExamplePage> createState() => _FooBasicExamplePageState();
}

class _FooBasicExamplePageState extends State<FooBasicExamplePage> {
  bool _isLoading = false;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(title: 'Basic', description: '...', children: [...]),
          _buildSection(title: 'States', description: '...', children: [...]),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: '''
        p-6 rounded-xl
        bg-gradient-to-r from-blue-500 to-purple-500
      ''',
      children: [
        WText('Page Title', className: 'text-2xl font-bold text-white'),
        WText('One-line description', className: 'text-sm text-white/80'),
      ],
    );
  }

  Widget _buildSection({required String title, required String description, required List<Widget> children}) {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(title, className: 'text-lg font-semibold text-gray-900 dark:text-white'),
        WText(description, className: 'text-sm text-gray-500 dark:text-gray-400'),
        ...children,
      ],
    );
  }
}
```

## Rules

- **Root:** `WDiv(className: 'w-full h-full overflow-y-auto p-4', scrollPrimary: true, child: ...)` — always scrollable, always `scrollPrimary: true` so iOS tap-to-top works.
- **Content wrapper:** `WDiv(className: 'flex flex-col gap-6 max-w-4xl mx-auto', children: [...])` — vertical flex with consistent gap, max-width centered.
- **Header:** gradient `WDiv` with title (`text-2xl font-bold text-white`) + description (`text-sm text-white/80`).
- **Sections:** `_buildSection(title:, description:, children:)` helper. Title `text-lg font-semibold text-gray-900 dark:text-white`. Description `text-sm text-gray-500 dark:text-gray-400`.
- **Demo rows:** for variant comparisons, helper `_buildDemoRow` or inline; show 3-5 variants per feature.
- **Interactive demos:** `StatefulWidget` + `setState`. Toggles (`bool _isLoading`), counters (`int _counter`), simulated async (`Future.delayed`). Realistic state, not lifeless static UI.
- **Realistic content:** "John Doe", "user@example.com", real product names. No Lorem ipsum.
- **One concept per page.** Splitting is preferred over cramming.

## Dark mode pairs

Every `bg-*`, `text-*`, `border-*`, `ring-*`, `fill-*`, `shadow-*` token carries a `dark:` pair in the same className. Missing dark pair is a bug:

```dart
className: '''
  bg-white dark:bg-gray-800
  text-gray-900 dark:text-gray-100
  border border-gray-200 dark:border-gray-700
''',
```

Use multi-line triple-quoted strings when className spans more than one concern. One concern per line.

## States demos

When demoing state-prefixed classes, show the className that fires the state:
```dart
WButton(
  className: 'bg-blue-500 hover:bg-blue-600 active:bg-blue-700 disabled:bg-gray-400',
  onTap: () {},
  child: WText('Hover / Press / Disable me'),
);
```

For custom states, drive via `states: {'selected'}` and use `selected:` prefixed classes.

## Pairing with `doc/`

When a doc file's `<x-preview source="example/lib/pages/foo/bar.dart">` references this page, the path is the contract — do not rename or move the file without updating every doc that references it.

## What never goes in `example/lib/pages/`

- Production logic — pure demos only.
- Network calls — pump-friendly demos only.
- Long copy that belongs in `doc/`.
