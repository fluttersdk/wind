# WTabs

Controlled tabs widget. Renders a tab list and a content panel. The `selected:` state prefix activates on the currently active tab, so callers can supply tokens like `selected:border-b-2 selected:text-blue-600` through `tabClassName`. This is a fully controlled widget: `selectedIndex` is managed by the caller.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Props](#props)
- [Constructor](#constructor)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="widgets/w_tabs_basic" size="md" source="example/lib/pages/widgets/w_tabs_basic.dart"></x-preview>

```dart
WTabs(
  tabs: const ['Overview', 'Details', 'Settings'],
  selectedIndex: _selectedTab,
  onChanged: (i) => setState(() => _selectedTab = i),
  listClassName: 'flex flex-row border-b border-gray-200 dark:border-gray-700',
  tabClassName: '''
    px-4 py-2 text-sm text-gray-500 dark:text-gray-400
    selected:text-blue-600 dark:selected:text-blue-400
    selected:border-b-2 selected:border-blue-600 dark:selected:border-blue-400
  ''',
  panelClassName: 'pt-4',
  panelBuilder: (index) => _panels[index],
)
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `tabs` | `List<String>` | **Required** | The labels rendered for each tab, in display order. |
| `selectedIndex` | `int` | **Required** | Zero-based index of the currently selected tab. |
| `panelBuilder` | `Widget Function(int index)` | **Required** | Returns the panel content for the currently selected tab. |
| `onChanged` | `ValueChanged<int>?` | `null` | Called with the tapped tab's index. The caller updates `selectedIndex` in response. |
| `listClassName` | `String?` | `null` | Utility classes for the tab-list row container. Example: `'flex flex-row border-b border-gray-200 dark:border-gray-700'`. |
| `tabClassName` | `String?` | `null` | Utility classes applied to every tab's inner `WDiv`. Supports `selected:` prefixed tokens — they activate only on the selected tab. |
| `selectedTabClassName` | `String?` | `null` | Extra utility classes appended to the active tab's `WDiv` only. Applied after `tabClassName`. |
| `panelClassName` | `String?` | `null` | Utility classes for the panel wrapper `WDiv`. Example: `'pt-4'`. |

<a name="constructor"></a>
## Constructor

```dart
WTabs({
  Key? key,
  required List<String> tabs,
  required int selectedIndex,
  required Widget Function(int index) panelBuilder,
  ValueChanged<int>? onChanged,
  String? listClassName,
  String? tabClassName,
  String? selectedTabClassName,
  String? panelClassName,
})
```

<a name="styling-examples"></a>
## Styling Examples

### Underline Tabs

Classic underline style: `selected:border-b-2` on the active tab. Pair border and text colors with `dark:` variants:

```dart
WTabs(
  tabs: const ['Overview', 'Activity', 'Settings'],
  selectedIndex: _tab,
  onChanged: (i) => setState(() => _tab = i),
  listClassName: 'flex flex-row border-b border-gray-200 dark:border-gray-700',
  tabClassName: '''
    px-4 py-3 text-sm font-medium
    text-gray-500 dark:text-gray-400
    selected:text-rose-600 dark:selected:text-rose-400
    selected:border-b-2 selected:border-rose-600 dark:selected:border-rose-400
  ''',
  panelClassName: 'pt-4',
  panelBuilder: (index) => panels[index],
)
```

### Pill / Segmented Control

Background-based active tab with rounded container:

```dart
WTabs(
  tabs: const ['All', 'Open', 'Resolved'],
  selectedIndex: _tab,
  onChanged: (i) => setState(() => _tab = i),
  listClassName: 'flex flex-row gap-1 p-1 rounded-lg bg-gray-100 dark:bg-gray-800',
  tabClassName: '''
    px-3 py-1.5 rounded-md text-sm font-medium
    text-gray-600 dark:text-gray-400
    selected:bg-white dark:selected:bg-gray-700
    selected:text-gray-900 dark:selected:text-white
    selected:shadow-sm
  ''',
  panelClassName: 'pt-4',
  panelBuilder: (index) => panels[index],
)
```

### selectedTabClassName for Active-Only Tokens

Use `selectedTabClassName` to append active-only classes without `selected:` prefixes:

```dart
WTabs(
  tabs: const ['Profile', 'Security', 'Billing'],
  selectedIndex: _tab,
  onChanged: (i) => setState(() => _tab = i),
  tabClassName: 'px-4 py-2 text-sm text-gray-500 dark:text-gray-400',
  selectedTabClassName: 'text-blue-600 dark:text-blue-400 border-b-2 border-blue-600 dark:border-blue-400',
  panelBuilder: (index) => panels[index],
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WAnchor](./w-anchor.md) — each tab is wrapped in a `WAnchor` providing hover and focus state.
- [WDiv](./w-div.md) — renders the tab list and panel containers.
- [WCheckbox](./w-checkbox.md) — another controlled widget that drives state prefixes from a prop.
