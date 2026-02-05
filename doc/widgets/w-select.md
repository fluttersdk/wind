# WSelect

A utility-first dropdown select component with multi-select, tagging, and pagination support.

<x-preview path="forms/select_basic" size="md" source="example/lib/pages/forms/select_basic.dart"></x-preview>

## Basic Usage

```dart
WSelect<String>(
  value: _selected,
  options: [
    SelectOption(value: 'a', label: 'Option A'),
    SelectOption(value: 'b', label: 'Option B'),
  ],
  onChange: (value) => setState(() => _selected = value),
  className: 'w-64 bg-white border rounded-lg p-3',
  menuClassName: 'bg-white shadow-lg max-h-48',
)
```

## Multi-Select

<x-preview path="forms/select_multi" size="md" source="example/lib/pages/forms/select_multi.dart"></x-preview>

Enable multi-select mode with `isMulti: true`. Selected items appear as chips.

```dart
WSelect<String>(
  isMulti: true,
  values: _selectedTags,
  options: _tagOptions,
  onMultiChange: (values) => setState(() => _selectedTags = values),
  placeholder: 'Select tags...',
  className: 'w-80 bg-white border rounded-lg p-2 min-h-10',
)
```

## Searchable

<x-preview path="forms/select_searchable" size="md" source="example/lib/pages/forms/select_searchable.dart"></x-preview>

Add search input with `searchable: true`.

```dart
WSelect<String>(
  options: _options,
  searchable: true,
  searchPlaceholder: 'Type to search...',
  onSearch: (query) async => await api.search(query),
)
```

## Tagging (Create Options)

Allow users to create new options with `onCreateOption`.

```dart
WSelect<String>(
  isMulti: true,
  values: _tags,
  searchable: true,
  onCreateOption: (query) async {
    return SelectOption(value: query.toLowerCase(), label: query);
  },
)
```

## Pagination (Infinite Scroll)

<x-preview path="forms/select_pagination" size="md" source="example/lib/pages/forms/select_pagination.dart"></x-preview>

Load more options on scroll with `onLoadMore` and `hasMore`.

```dart
WSelect<User>(
  options: _users,
  searchable: true,
  onSearch: (query) => _fetchUsers(query, page: 1),
  onLoadMore: () => _fetchUsers(_query, page: _page + 1),
  hasMore: _hasMore,
)
```

## Active States

WSelect automatically manages these states for styling:

| State | Condition |
| :--- | :--- |
| `hover` | Mouse over the select trigger |
| `focus` | Select widget is focused |
| `open` | Dropdown menu is currently open |
| `disabled` | Widget is disabled |
| `selected` | A value is currently selected |

Use with state prefixes:

```dart
WSelect(
  className: 'border border-gray-300 open:border-blue-500 selected:bg-blue-50',
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `T?` | - | Selected value (single-select) |
| `values` | `List<T>?` | - | Selected values (multi-select) |
| `isMulti` | `bool` | `false` | Enable multi-select mode |
| `onChange` | `ValueChanged<T>?` | - | Single-select callback |
| `onMultiChange` | `ValueChanged<List<T>>?` | - | Multi-select callback |
| `options` | `List<SelectOption<T>>` | required | Available options |
| `searchable` | `bool` | `false` | Show search input |
| `searchPlaceholder` | `String` | `'Search...'` | Search placeholder |
| `onSearch` | `Future<List> Function(String)?` | - | Async search callback |
| `onCreateOption` | `Future<SelectOption> Function(String)?` | - | Create new option |
| `onLoadMore` | `Future<List> Function()?` | - | Pagination callback |
| `hasMore` | `bool` | `false` | More pages available |
| `className` | `String?` | - | Trigger styling |
| `menuClassName` | `String?` | - | Menu styling |
| `placeholder` | `String` | `'Select...'` | Placeholder text |
| `disabled` | `bool` | `false` | Disable widget |
| `states` | `Set<String>?` | - | Custom states |

## Custom Builders

| Builder | Description |
| :--- | :--- |
| `triggerBuilder` | Custom trigger (single) |
| `multiTriggerBuilder` | Custom trigger (multi) |
| `itemBuilder` | Custom option items |
| `selectedChipBuilder` | Custom chips |
| `emptyBuilder` | Custom empty state |
| `loadingBuilder` | Custom loading indicator |
| `createOptionBuilder` | Custom create button |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*`, `min-h-*` | Trigger dimensions |
| **Padding** | `p-*`, `px-*`, `py-*` | Content padding |
| **Background** | `bg-*` | Fill color |
| **Border** | `border-*`, `rounded-*` | Border style |
| **Shadow** | `shadow-*` | Drop shadow |
| **Menu** | `max-h-*` | Menu max height |
| **States** | `hover:*`, `focus:*`, `open:*` | State styling |

## Related Documentation

- [WInput](./w-input.md) - Text input widget
- [WFormCheckbox](./w-form-checkbox.md) - Form checkbox widget
