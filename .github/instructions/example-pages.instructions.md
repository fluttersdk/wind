---
name: 'Example Page Conventions'
description: 'Structure and patterns for Wind framework demo pages in example/lib/pages/'
applyTo: 'example/lib/pages/**/*.dart'
---

# Example Pages Domain

- File name: `{feature_name}.dart` (snake_case). Class: `{FeatureName}ExamplePage`
- Extend `StatefulWidget` for interactive demos (state toggles, counters, loading simulation)
- Root widget: `WDiv(className: 'w-full h-full overflow-y-auto p-4', child: ...)` — always scrollable
- Content wrapper: `WDiv(className: 'flex flex-col gap-6', children: [_buildHeader(), ...sections])`
- Header: gradient WDiv with title (text-lg font-bold text-white) + description (text-sm)
- Use `_buildSection({title, description, children})` helper for consistent section layout
- Section title: `text-lg font-semibold text-gray-900 dark:text-white`
- Section description: `text-sm text-gray-600 dark:text-gray-400 mb-4`
- Always include dark mode variants in all className strings
- Show multiple variants of the component: basic, styled, states (hover, disabled, loading), responsive
- Include interactive state demos: `setState(() => _isLoading = !_isLoading)`
- Use realistic content — names, emails, descriptions — not "Lorem ipsum"
- Each page demonstrates ONE widget or concept thoroughly, not multiple
- These pages are referenced by `doc/` via `<x-preview>` — keep file paths stable
