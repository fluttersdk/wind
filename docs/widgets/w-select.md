# WSelect

A utility-first dropdown select component with multi-select, tagging, and pagination support.

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

<x-preview path="forms/select_basic" size="md"></x-preview>

---

## Multi-Select

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

<x-preview path="forms/select_multi" size="md"></x-preview>

### Custom Chip Builder

```dart
selectedChipBuilder: (context, option, onRemove) => Chip(
  label: Text(option.label),
  onDeleted: onRemove,
),
```

---

## Searchable

Add search input with `searchable: true`.

```dart
WSelect<String>(
  options: _options,
  searchable: true,
  searchPlaceholder: 'Type to search...',
  onSearch: (query) async => await api.search(query),
)
```

<x-preview path="forms/select_searchable" size="md"></x-preview>

---

## Tagging (Create Options)

Allow users to create new options with `onCreateOption`.

```dart
WSelect<String>(
  isMulti: true,
  values: _tags,
  options: _tagOptions,
  searchable: true,
  onCreateOption: (query) async {
    return SelectOption(value: query.toLowerCase(), label: query);
  },
)
```

When search returns no matches, a "Create X" button appears.

<x-preview path="forms/select_pagination" size="md"></x-preview>

---

## Pagination (Infinite Scroll)

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

---

## Active States

WSelect automatically manages these states for styling:

| State | Condition |
| :--- | :--- |
| `hover` | Mouse over the select trigger |
| `focus` | Select widget is focused |
| `open` | Dropdown menu is currently open |
| `disabled` | Widget is disabled |
| `selected` | A value is currently selected |

Use with state prefixes in className:

```dart
WSelect(
  className: 'border border-gray-300 open:border-blue-500 selected:bg-blue-50',
)
```

Add custom states via `states` prop:

```dart
WSelect(
  states: {'loading', 'error'},
  className: 'border loading:opacity-50 error:border-red-500',
)
```

---

## Props Reference

| Prop | Type | Description |
|------|------|-------------|
| `value` | `T?` | Selected value (single-select) |
| `values` | `List<T>?` | Selected values (multi-select) |
| `isMulti` | `bool` | Enable multi-select mode |
| `onChange` | `ValueChanged<T>?` | Single-select callback |
| `onMultiChange` | `ValueChanged<List<T>>?` | Multi-select callback |
| `options` | `List<SelectOption<T>>` | Available options |
| `searchable` | `bool` | Show search input |
| `searchPlaceholder` | `String` | Search input placeholder |
| `onSearch` | `Future<List> Function(String)?` | Async search callback |
| `onCreateOption` | `Future<SelectOption> Function(String)?` | Create new option |
| `onLoadMore` | `Future<List> Function()?` | Pagination callback |
| `hasMore` | `bool` | More pages available |
| `className` | `String?` | Trigger styling |
| `menuClassName` | `String?` | Menu styling |
| `placeholder` | `String` | Placeholder text |
| `disabled` | `bool` | Disable widget |

### Custom Builders

| Builder | Type | Description |
|---------|------|-------------|
| `triggerBuilder` | `SelectTriggerBuilder` | Custom trigger (single) |
| `multiTriggerBuilder` | `MultiSelectTriggerBuilder` | Custom trigger (multi) |
| `itemBuilder` | `SelectItemBuilder` | Custom option items |
| `selectedChipBuilder` | `SelectedChipBuilder` | Custom chips |
| `emptyBuilder` | `EmptyStateBuilder` | Custom empty state |
| `loadingBuilder` | `LoadingBuilder` | Custom loading indicator |
| `createOptionBuilder` | `CreateOptionBuilder` | Custom create button |

---

## Styling

### Trigger Width
Use `w-*` in `className`:
```dart
className: 'w-64 bg-white border rounded-lg p-3'
```

### Menu Height
Use `max-h-*` in `menuClassName`:
```dart
menuClassName: 'bg-white shadow-lg max-h-48'
```
