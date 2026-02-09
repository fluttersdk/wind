# WSelect

A highly customizable, utility-first select component that supports single selection, multi-selection, searching, and remote data fetching.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="forms/select_basic" size="md" source="example/lib/pages/forms/select_basic.dart"></x-preview>

```dart
WSelect<String>(
  value: _selected,
  options: [
    SelectOption(value: 'dart', label: 'Dart'),
    SelectOption(value: 'flutter', label: 'Flutter'),
  ],
  onChange: (value) => setState(() => _selected = value),
  className: 'w-64 bg-white border border-gray-300 rounded-lg',
)
```

## Basic Usage

The `WSelect` widget replaces the standard Material Dropdown with a utility-first approach. It manages its own open state while providing a controlled interface for selection.

```dart
WSelect<int>(
  placeholder: 'Choose a number',
  options: List.generate(5, (i) => SelectOption(value: i, label: 'Option $i')),
  onChange: (val) => print('Selected: $val'),
  className: 'bg-white border p-3 rounded-md',
)
```

## Constructor

```dart
const WSelect({
  Key? key,
  T? value,
  ValueChanged<T>? onChange,
  bool isMulti = false,
  List<T>? values,
  ValueChanged<List<T>>? onMultiChange,
  SelectedChipBuilder<T>? selectedChipBuilder,
  required List<SelectOption<T>> options,
  bool searchable = false,
  Future<List<SelectOption<T>>> Function(String)? onSearch,
  String searchPlaceholder = 'Search...',
  Future<SelectOption<T>> Function(String)? onCreateOption,
  CreateOptionBuilder? createOptionBuilder,
  Future<List<SelectOption<T>>> Function()? onLoadMore,
  bool hasMore = false,
  String? className,
  String? menuClassName,
  String placeholder = 'Select an option',
  bool disabled = false,
  double? menuWidth,
  double maxMenuHeight = 300,
  Set<String>? states,
  SelectTriggerBuilder<T>? triggerBuilder,
  MultiSelectTriggerBuilder<T>? multiTriggerBuilder,
  SelectItemBuilder<T>? itemBuilder,
  EmptyStateBuilder? emptyBuilder,
  LoadingBuilder? loadingBuilder,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Utility classes for the trigger container |
| `menuClassName` | `String?` | `null` | Utility classes for the dropdown menu |
| `options` | `List<SelectOption<T>>` | **Required** | List of items to display |
| `value` | `T?` | `null` | Selected value in single-select mode |
| `onChange` | `ValueChanged<T>?` | `null` | Callback for single selection changes |
| `isMulti` | `bool` | `false` | Enables multi-select mode |
| `values` | `List<T>?` | `null` | Selected values in multi-select mode |
| `onMultiChange` | `ValueChanged<List<T>>?` | `null` | Callback for multi-selection changes |
| `searchable` | `bool` | `false` | Shows a search input in the menu |
| `placeholder` | `String` | `'Select an option'` | Text shown when no value is selected |
| `disabled` | `bool` | `false` | Prevents interaction |
| `maxMenuHeight`| `double` | `300` | Maximum height of the dropdown list |

## Layout Modes

### Single Select
The default mode for selecting a single item. It displays the label of the selected option in the trigger.

<x-preview path="widgets/w-select_single" size="md" source="example/lib/pages/widgets/w_select_single.dart"></x-preview>

```dart
WSelect<String>(
  value: 'apple',
  options: [
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'banana', label: 'Banana'),
  ],
  onChange: (v) => print(v),
)
```

### Multi Select
Enable `isMulti: true` to allow multiple selections. By default, it displays selected items as chips.

<x-preview path="widgets/w-select_multi" size="md" source="example/lib/pages/widgets/w_select_multi.dart"></x-preview>

```dart
WSelect<String>(
  isMulti: true,
  values: ['red', 'blue'],
  options: [
    SelectOption(value: 'red', label: 'Red'),
    SelectOption(value: 'blue', label: 'Blue'),
    SelectOption(value: 'green', label: 'Green'),
  ],
  onMultiChange: (list) => print(list),
)
```

## Event Handling

`WSelect` provides callbacks for selection changes and remote interactions.

```dart
WSelect<String>(
  onChange: (value) {
    // Handle single selection
  },
  onSearch: (query) async {
    // Return list of options based on search query
    return fetchRemoteOptions(query);
  },
  onLoadMore: () async {
    // Load next page of options
    return fetchNextPage();
  },
)
```

## State Variants

`WSelect` automatically manages several states that you can style using prefixes in `className`:

- `hover:` - When the mouse is over the trigger.
- `focus:` - When the dropdown is open.
- `disabled:` - When the widget is disabled.
- `selected:` - When a value is selected.

```dart
WSelect(
  className: 'border-gray-300 hover:border-blue-500 focus:ring-2 focus:ring-blue-200',
)
```

## Styling Examples

### Searchable Select
Combine `searchable: true` with custom menu styling for a robust selection experience.

```dart
WSelect<String>(
  searchable: true,
  searchPlaceholder: 'Search countries...',
  menuClassName: 'bg-white shadow-xl rounded-xl border border-gray-100',
  options: countries,
  onChange: (val) => _country = val,
)
```

### Tagging (Create Option)
Allow users to create new options if a search yields no results.

```dart
WSelect<String>(
  searchable: true,
  onCreateOption: (query) async {
    final newOpt = SelectOption(value: query.toLowerCase(), label: query);
    // Add to your local state/database
    return newOpt;
  },
  options: existingTags,
)
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `hidden`, `w-{size}`, `h-{size}` |
| Spacing | `p-{n}`, `m-{n}`, `gap-{n}` |
| Visuals | `bg-{color}`, `border`, `rounded`, `shadow` |
| States | `hover:`, `focus:`, `disabled:`, `dark:` |
| Custom | `open:`, `selected:` |

## Customizing Theme

The default styling for `WSelect` and its chips can be influenced by the `WindThemeData`.

```dart
WindThemeData(
  colors: {
    'primary': Colors.indigo,
  },
)
```

## Related Documentation

- [WFormSelect](./w-form-select.md) - Form-integrated version with validation
- [WPopover](./w-popover.md) - The underlying overlay engine
- [WInput](./w-input.md) - Used for the internal search field
