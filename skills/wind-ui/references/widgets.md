# Wind UI Widget Reference

Wind UI provides a comprehensive set of utility-first widgets. These widgets apply Tailwind-like string classes into native Flutter layouts, using "Intelligent Composition" to create the optimal widget tree.

## Table of Contents
- [WDiv](#wdiv) - Core Layout Container
- [WDiv Composition Logic](#wdiv-composition-logic)
- [WText](#wtext) - Typography
- [WButton](#wbutton) - Interactive Button
- [WInput](#winput) - Text Input
- [WSelect](#wselect) - Single & Multi-Select Dropdown
- [WCheckbox](#wcheckbox) - Checkbox
- [WIcon](#wicon) - Icon Wrapper
- [WImage](#wimage) - Network & Asset Images
- [WSvg](#wsvg) - SVG Images
- [WPopover](#wpopover) - Popovers & Tooltips
- [WAnchor](#wanchor) - Interaction State Wrapper
- [Form Field Wrappers](#form-field-wrappers)
  - [WFormInput](#wforminput)
  - [WFormSelect](#wformselect)
  - [WFormMultiSelect](#wformmultiselect)
  - [WFormCheckbox](#wformcheckbox)

---

## WDiv

**Purpose:** The fundamental building block of Wind. Dynamically constructs the most efficient widget tree based on the provided utility classes.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| className | String? | null | Utility class string |
| child | Widget? | null | Single child (exclusive with children) |
| children | List<Widget>? | null | Multiple children (exclusive with child) |
| style | WindStyle? | null | Base explicit style |
| states | Set<String>? | null | Custom state triggers e.g., {'loading', 'active'} |
| scrollPrimary | bool | false | Link to PrimaryScrollController (iOS tap-to-top) |

**Flutter Constraint Notes:**
- **w-full vs flex-1:** In a horizontal flex layout (Row), `w-full` causes a RenderFlex overflow. Use `flex-1` instead to fill remaining space.
- **overflow-y-auto:** Translates to `SingleChildScrollView`. It MUST have a bounded height parent. If placed directly inside a Column, wrap it in an `Expanded` (or `flex-1`).
- **scrollPrimary:** Set `scrollPrimary: true` to enable tap-to-scroll-top on iOS and desktop scrollbar integration when using `overflow-y-auto`.
- **flex-wrap is NO-OP:** `Row` and `Column` CANNOT wrap in Flutter. Use `className: 'wrap'` instead.

**Examples:**
```dart
// Basic layout
WDiv(
  className: "flex flex-col gap-4 p-4 bg-white rounded-lg",
  children: [
    WText("Item 1"),
    WText("Item 2"),
  ],
)

// Scrollable area
WDiv(
  className: "flex-1 overflow-y-auto",
  scrollPrimary: true, // For iOS
  child: WText("Long content here..."),
)
```

### WDiv Intelligent Composition

WDiv intelligently selects the core Flutter widget based on the `className`:

| className contains | Core Flutter widget | Key behavior |
|-------------------|---------------------|--------------|
| `flex flex-col` | `Column` | |
| `flex` or `flex flex-row` | `Row` | |
| `wrap` or `grid` | `Wrap` | `grid` acts like wrap with equal widths |
| `overflow-y-auto` | `SingleChildScrollView` | Vertical. MUST have bounded height parent. |
| `overflow-x-auto` | `SingleChildScrollView` | Horizontal. |
| `hidden` | `SizedBox.shrink()` | Short-circuits build entirely. |
| none of above | `Column` or `Container` | `Column` for `children`, `Container` for `child`. |

* **Auto-WAnchor:** WDiv automatically wraps itself in a `WAnchor` if `className` contains `hover:`, `focus:`, or `active:`.
* **Auto-Flexible:** In a `Row`, if space distribution (`justify-between`, `space-around`, `space-evenly`) OR `overflow-hidden` is present, WDiv automatically wraps non-flex children in `Flexible` to prevent overflows (mimicking CSS `flex-shrink: 1`).
* **child vs children:** These are mutually exclusive. Providing both throws an assertion error.

---

## WText

**Purpose:** Core typography component. Separates typography styles from layout styles.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| data | String | required | The text string to display |
| className | String? | null | Utility class string |
| style | WindStyle? | null | Explicit base style |
| textStyle | TextStyle? | null | Flutter native TextStyle override |
| selectable | bool | false | If true, renders `SelectableText` |
| states | Set<String>? | null | Custom state triggers |

**Flutter Constraint Notes:**
- **truncate:** Translates to `TextOverflow.ellipsis` with `maxLines: 1`. Inside a Row, a `WText` with `truncate` MUST be wrapped in an `Expanded` (e.g., `WDiv(className: 'flex-1')`) or have a fixed width. Otherwise, it takes infinite width and overflows.

**Examples:**
```dart
WText(
  'Hello World',
  className: 'text-xl font-bold text-blue-500 text-center uppercase p-4',
)

// Truncated in a row
WDiv(
  className: 'flex items-center gap-2',
  children: [
    WIcon(Icons.person),
    WDiv(
      className: 'flex-1', // Required for truncate
      child: WText('Very long name...', className: 'truncate'),
    ),
  ],
)
```

---

## WButton

**Purpose:** Interactive button with built-in loading states and state management.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| child | Widget | required | Content when not loading |
| onTap | VoidCallback? | null | Tap handler |
| onLongPress | VoidCallback? | null | Long press handler |
| onDoubleTap | VoidCallback? | null | Double tap handler |
| isLoading | bool | false | Shows spinner, disables interaction, activates `loading:` |
| disabled | bool | false | Disables interaction, activates `disabled:` |
| className | String? | null | Utility class string |
| loadingText | String? | null | Optional text beside spinner |
| loadingWidget | Widget? | null | Custom spinner override |
| loadingSize | double | 20 | Size of default spinner |
| loadingColor | Color? | null | Color of spinner. Falls back to text color, then auto-computes contrast via W3C luminance when no color is resolvable. |
| states | Set<String>? | null | Custom state triggers |

**Flutter Constraint Notes:**
- `WButton` uses `Container` under the hood. To make it expand to fill its parent horizontally, use `w-full` in its `className`.

**When to use WButton vs WAnchor:**
- Use **WButton** for standard UI actions, forms, and dialogs where you need built-in loading states and standard button sizing.
- Use **WAnchor** when you need to make arbitrary widgets interactive (like entire cards, list items, or custom layouts) or when you only need to trigger hover/focus styling without button semantics.

**Examples:**
```dart
WButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  loadingText: 'Saving...',
  className: '''
    bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 
    text-white px-4 py-2 rounded-lg 
    loading:opacity-75 transition-all
  ''',
  child: WText('Save Changes'),
)
```

---

## WInput

**Purpose:** A utility-first text input component for raw value binding.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| value | String? | null | Controlled value |
| onChanged | ValueChanged<String>?| null | Value change callback |
| type | InputType | .text | `.text`, `.password`, `.email`, `.number`, `.multiline` |
| className | String? | null | Styling for input wrapper and text |
| placeholderClassName | String?| null | Styling for placeholder |
| placeholder | String? | null | Placeholder text |
| enabled | bool | true | If false, activates `disabled:` |
| readOnly | bool | false | Makes input read-only |
| autofocus | bool | false | Focus on mount |
| textInputAction | TextInputAction?| null | Keyboard action button |
| onSubmitted | ValueChanged<String>?| null | Action button tap handler |
| maxLines | int? | null | Maximum lines (`null` = unlimited) |
| minLines | int | 1 | Minimum lines |
| controller | TextEditingController?| null | Explicit controller (overrides value) |
| prefix / suffix | Widget? | null | Prefix/Suffix icons |

**When to use WInput vs WFormInput:**
- Use **WInput** for standalone inputs, simple state binding, or search bars outside of a `Form`.
- Use **WFormInput** when inside a Flutter `Form` widget, when you need validation logic, or when you want automatic error message display and `error:` styling.

**Examples:**
```dart
WInput(
  value: _searchQuery,
  onChanged: (val) => setState(() => _searchQuery = val),
  placeholder: 'Search...',
  className: 'w-full p-3 rounded-lg border border-gray-300 focus:ring-2 focus:border-blue-500',
  prefix: WIcon(Icons.search, className: 'text-gray-400'),
)
```

---

## WSelect

**Purpose:** Utility-first dropdown for single or multi-selection with search and async support.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| value | T? | null | Single: Selected value |
| onChange | ValueChanged<T>?| null | Single: Selection callback |
| isMulti | bool | false | Enables multi-select mode |
| values | List<T>? | null | Multi: Selected values |
| onMultiChange | ValueChanged<List<T>>?| null | Multi: Selection callback |
| options | List<SelectOption<T>>| required | Available options |
| searchable | bool | false | Shows search input |
| onSearch | Future<List<SelectOption<T>>> Function(String)?| null | Async search callback |
| onCreateOption | Future<SelectOption<T>> Function(String)?| null | Callback to create new option |
| onLoadMore | Future<List<SelectOption<T>>> Function()?| null | Pagination callback |
| hasMore | bool | false | Enables pagination |
| className | String? | null | Trigger styling |
| menuClassName | String? | null | Dropdown menu styling |

**Special Behaviors:**
- **Single vs Multi:** Use `value` + `onChange` for single select. Set `isMulti: true` and use `values` + `onMultiChange` for multi-select.
- **onCreateOption:** Used for tagging/creating new items. You MUST handle the state in the parent widget to call `setState` and add the newly created option to your `options` list.
- **Search:** Set `searchable: true` for local filtering. Provide `onSearch` for async remote filtering.

**Flutter Constraint Notes:**
- The menu width defaults to the trigger width. Use `menuWidth` or `w-*` in `menuClassName` to override.
- The `maxMenuHeight` defaults to 300. Use `constraints: BoxConstraints(...)` via `menuClassName` or the explicit prop to adjust.

**Examples:**
```dart
// Multi-select with tagging
WSelect<String>(
  isMulti: true,
  searchable: true,
  values: _selectedTags,
  options: _availableTags,
  onMultiChange: (v) => setState(() => _selectedTags = v),
  onCreateOption: (query) async {
    final newOption = SelectOption(value: query, label: query);
    setState(() => _availableTags.add(newOption)); // REQUIRED
    return newOption;
  },
  className: 'w-full p-2 border rounded-lg',
)
```

---

## WCheckbox

**Purpose:** A fully styled custom checkbox that bypasses native widget limitations.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| value | bool | required | Checked state |
| onChanged | ValueChanged<bool>?| null | State change callback |
| className | String? | null | Checkbox styling (`w-* h-*` required) |
| iconClassName | String? | null | Styling for the check icon |
| disabled | bool | false | Disables interaction |
| checkIcon | IconData? | null | Custom check icon |

**Examples:**
```dart
WCheckbox(
  value: _agreed,
  onChanged: (v) => setState(() => _agreed = v),
  className: '''
    w-5 h-5 rounded border border-gray-300 
    checked:bg-blue-500 checked:border-transparent 
    disabled:opacity-50 transition-colors
  ''',
)
```

---

## WIcon

**Purpose:** Wraps Flutter's `Icon` widget with utility class support. Inherits color and size from parent `WDiv`.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| icon | IconData | required | The icon to display |
| className | String? | null | Sizing and coloring (`text-xl`, `text-red-500`) |
| states | Set<String>? | null | Custom state triggers |

**Examples:**
```dart
WIcon(
  Icons.settings,
  className: 'text-2xl text-gray-500 hover:text-gray-900 transition-colors',
)
```

---

## WImage

**Purpose:** Network and asset images with utility class styling (sizing, object-fit, borders).

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| src | String? | null | Network URL or `asset://...` |
| image | ImageProvider?| null | Explicit ImageProvider |
| alt | String? | null | Accessibility label |
| className | String? | null | Styling (`object-cover`, `aspect-video`) |
| placeholder | Widget? | null | Loading widget |
| errorBuilder | ImageErrorBuilder?| null | Custom error widget builder |

**Examples:**
```dart
WImage(
  src: 'asset://assets/images/profile.png',
  className: 'w-16 h-16 rounded-full object-cover border-2 border-white shadow-md',
)
```

---

## WSvg

**Purpose:** Renders SVG assets or strings with utility class support for filling and stroking.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| src | String? | null | Asset path |
| svgString | String? | null | Raw SVG string (use `WSvg.string(...)`) |
| className | String? | null | Styling (`fill-red-500`, `stroke-blue-500`) |

**Preserve Original Colors:**
Use `preserve-colors` in className to skip all ColorFilter processing. The SVG renders with its original embedded colors. Ideal for QR codes, multi-color logos, and branded illustrations.

```dart
WSvg(
  src: 'assets/logo-colored.svg',
  className: 'w-32 h-32 preserve-colors',
)
```

**Examples:**
```dart
WSvg(
  src: 'assets/icons/logo.svg',
  className: 'w-8 h-8 fill-blue-600',
)
```

---

## WDynamic

**Purpose:** Renders a Flutter widget tree from JSON/Map at runtime with action handling and form state management.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| json | Map<String, dynamic> | required | JSON widget tree definition |
| actions | Map<String, Function> | {} | Action handlers keyed by name |
| controller | WDynamicController? | null | External state access |
| denyWidgets | Set<String>? | null | Widget types to block |
| builders | Map<String, WWidgetBuilder>? | null | Custom widget builders |
| customIcons | Map<String, IconData>? | null | Custom icon name → IconData mappings |
| maxDepth | int | 50 | Max recursion depth |
| onError | Widget Function(String, Object)? | null | Error fallback builder |
| onUnknownWidget | Widget Function(String, Map)? | null | Unknown widget fallback |

**JSON Schema:**
```dart
{
  'type': 'WDiv',           // Widget type (Wind, Flutter, or custom)
  'props': {'className': 'flex gap-4'},  // Widget properties
  'children': [...]          // Nested widgets
}
```

**Action Handling:**
```dart
WDynamic(
  json: myJson,
  actions: {
    'submit': (Map<String, dynamic> args, WDynamicState state) {
      final email = state.get('email');
      print('Submitting: $email');
    },
  },
)
```

**Supported Widgets:**
- Wind: WDiv, WText, WButton, WInput, WCheckbox, WSelect, WDatePicker, WIcon, WImage, WSvg, WPopover, WAnchor, WSpacer
- Flutter: Column, Row, Center, SizedBox, Expanded, Container, Wrap, Stack, Positioned, Padding, Align, Opacity, AspectRatio, FittedBox, ClipRRect, Spacer

---

## WPopover

**Purpose:** Flexible popover component for dropdowns, tooltips, and overlay menus.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| triggerBuilder| PopoverTriggerBuilder| required | `(BuildContext context, bool isOpen, bool isHovering) => Widget` |
| contentBuilder| PopoverContentBuilder| required | `(BuildContext context, VoidCallback close) => Widget` |
| alignment | PopoverAlignment| .bottomLeft | Position relative to trigger |
| className | String? | null | Overlay container styling |
| autoFlip | bool | true | Prevent off-screen rendering |
| offset | Offset | Offset(0, 4) | Gap between trigger and overlay |

**Examples:**
```dart
WPopover(
  alignment: PopoverAlignment.bottomRight,
  className: 'w-48 bg-white border border-gray-100 rounded-lg shadow-xl',
  triggerBuilder: (context, isOpen, isHovering) => WButton(
    child: WText('Options'),
  ),
  contentBuilder: (context, close) => WDiv(
    className: 'flex flex-col p-2',
    children: [
      WButton(onTap: close, className: 'p-2 text-left hover:bg-gray-50', child: WText('Edit')),
      WButton(onTap: close, className: 'p-2 text-left text-red-500 hover:bg-red-50', child: WText('Delete')),
    ],
  ),
)
```

---

## WAnchor

**Purpose:** The foundational state wrapper. Detects hover, focus, and gestures, propagating state down to all descendant widgets via `WindAnchorStateProvider`.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| child | Widget | required | The interactive area |
| onTap | VoidCallback? | null | Tap handler |
| onLongPress | VoidCallback? | null | Long press handler |
| onDoubleTap | VoidCallback? | null | Double tap handler |
| isDisabled | bool | false | Disables interaction and hover states |
| states | Set<String>? | null | Custom state triggers |

**When to use:** Use `WAnchor` when you want to make a custom layout interactive and react to `hover:` or `focus:` classes, but you don't need `WButton`'s loading states or button semantics. WDiv will automatically wrap itself in a WAnchor if you use interactive states in its className.

**Examples:**
```dart
WAnchor(
  onTap: () => _openDetails(),
  child: WDiv(
    className: 'p-4 bg-white rounded-xl shadow hover:shadow-md hover:bg-gray-50 transition-all cursor-pointer',
    child: WText('Interactive Card'),
  ),
)
```

---

## Form Field Wrappers

These widgets extend Flutter's `FormField` and are designed to be used inside a `Form` widget. They automatically handle validation, error states (`error:` prefixed classes), and labels. The key difference from their base counterparts is they sync state with the `FormFieldState` and display validation errors.

### WFormInput
Wraps `WInput`.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| controller | TextEditingController?| null | External controller |
| validator | FormFieldValidator<String>?| null | Validation logic |
| label | String? | null | Text label above input |
| hint | String? | null | Hint text below input |
| showError | bool | true | Show error text below input |

```dart
WFormInput(
  controller: _emailController,
  type: InputType.email,
  label: 'Email',
  className: 'p-3 border rounded-lg error:border-red-500',
  validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
)
```

### WFormSelect
Wraps `WSelect` (single-select mode).

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| value | T? | null | Initial value |
| options | List<SelectOption<T>>| required | Available options |
| validator | FormFieldValidator<T>?| null | Validation logic |

### WFormMultiSelect
Wraps `WSelect` (multi-select mode with `isMulti: true`).

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| values | List<T>? | null | Initial values |
| options | List<SelectOption<T>>| required | Available options |
| validator | FormFieldValidator<List<T>>?| null | Validation logic |

### WFormCheckbox
Wraps `WCheckbox`.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| value | bool | false | Initial value |
| labelText | String? | null | Label text displayed next to checkbox |
| validator | FormFieldValidator<bool>?| null | Validation logic |

```dart
WFormCheckbox(
  value: _agreeTerms,
  onChanged: (v) => setState(() => _agreeTerms = v),
  labelText: 'I agree to Terms of Service',
  className: 'w-5 h-5 rounded border checked:bg-blue-500 error:border-red-500',
  validator: (value) => value != true ? 'You must agree to terms' : null,
)
```

---

## WDatePicker

**Purpose:** Utility-first date picker with single and range selection modes. Uses `WPopover` for overlay.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| mode | DatePickerMode | .single | `.single` or `.range` |
| value | DateTime? | null | Selected date (single mode) |
| range | DateRange? | null | Selected range (range mode) |
| onChanged | ValueChanged<DateTime>? | null | Single date selection callback |
| onRangeChanged | ValueChanged<DateRange>? | null | Range selection callback |
| minDate | DateTime? | null | Earliest selectable date |
| maxDate | DateTime? | null | Latest selectable date |
| className | String? | null | Trigger container styling |
| placeholder | String | 'Select date' | Placeholder text |
| disabled | bool | false | Disables interaction |
| states | Set<String> | {} | Custom state triggers |
| displayFormat | DateDisplayFormat? | null | Custom `(DateTime) => String` formatter |

**DateRange:** `DateRange(start: DateTime, end: DateTime?)` — `isComplete` is true when both dates set.

**Examples:**
```dart
// Single date
WDatePicker(
  value: _selectedDate,
  onChanged: (date) => setState(() => _selectedDate = date),
  className: 'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800',
  placeholder: 'Pick a date',
)

// Date range
WDatePicker(
  mode: DatePickerMode.range,
  range: _dateRange,
  onRangeChanged: (range) => setState(() => _dateRange = range),
  className: 'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg',
  minDate: DateTime.now(),
  maxDate: DateTime.now().add(const Duration(days: 365)),
)
```

### WFormDatePicker
Wraps `WDatePicker` with `FormField<DateTime>` for form validation.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| initialValue | DateTime? | null | Initial selected date |
| initialRange | DateRange? | null | Initial range (range mode) |
| mode | DatePickerMode | .single | Selection mode |
| label | String? | null | Label text above picker |
| validator | FormFieldValidator<DateTime>? | null | Validation logic |
| className | String? | null | Trigger styling |

```dart
WFormDatePicker(
  label: 'Start Date',
  initialValue: DateTime.now(),
  className: 'w-full p-3 border border-gray-300 rounded-lg error:border-red-500',
  validator: (value) => value == null ? 'Date is required' : null,
  onChanged: (date) => print('Selected: $date'),
)
```

---

## WSpacer

**Purpose:** Lightweight spacing widget. Renders as a single `SizedBox` — no decoration, no composition overhead. Use instead of `WDiv` when you only need spacing.

**Constructor:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| className | String? | null | Only `h-{n}` and `w-{n}` tokens are used; all other classes are ignored |

**Why WSpacer over WDiv:**
- **Lighter:** No decoration, shadows, or layout composition
- **Semantic:** Clearly communicates spacing intent
- **Efficient:** Renders as single SizedBox (no builder overhead)
- **`const`-able:** `const WSpacer(className: 'h-4')` is valid

**Examples:**
```dart
// Vertical spacing in a Column (replaces SizedBox(height: 16))
WDiv(
  className: 'flex flex-col',
  children: [
    WFormInput(controller: _formData['name'], label: 'Name'),
    const WSpacer(className: 'h-4'), // 16px gap
    WFormInput(controller: _formData['email'], label: 'Email'),
  ],
)

// Horizontal spacing in a Row (replaces SizedBox(width: 8))
WDiv(
  className: 'flex flex-row items-center',
  children: [
    WIcon(Icons.info_outlined),
    const WSpacer(className: 'w-2'), // 8px gap
    WText('Info message'),
  ],
)

// Responsive spacing
WSpacer(className: 'h-4 md:h-6 lg:h-8')
```

**When to use WSpacer vs gap-{n}:**
- Use `gap-{n}` on parent `WDiv` for **uniform** spacing between all children
- Use `WSpacer` for **variable** spacing (e.g., different gaps between different sections)
