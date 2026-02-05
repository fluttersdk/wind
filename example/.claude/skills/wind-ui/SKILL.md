---
name: wind-ui
description: >
  FlutterSDK Wind framework for Flutter UIs with Tailwind-like utility classes.
  ACTIVATE when: Wind widgets (WDiv, WText, WButton, WInput, WSelect, WCheckbox, WImage, WSvg, WIcon,
  WPopover, WSpacer, WFormInput, WFormSelect, WFormMultiSelect, WFormCheckbox, WAnchor, WFormDatePicker),
  className strings (bg-*, text-*, flex, grid, p-*, m-*, rounded-*, shadow-*, overflow-*),
  responsive layouts (sm:/md:/lg:/xl:/2xl:), dark mode (dark:), interaction states (hover:/focus:/disabled:/error:/checked:),
  scrollable containers (overflow-y-auto + scrollPrimary), WindTheme configuration.
  Turkish: Flutter UI, Tailwind Flutter, className, responsive tasarım, karanlık mod, form widget.
---

# Wind Framework

Utility-first Flutter UI. Styling via `className` strings → `WindParser` → `WindStyle` → Widget tree.

## Widgets

| Widget | Purpose | Key Props |
|--------|---------|-----------|
| `WDiv` | Container/layout | `className`, `child`/`children`, `states`, `scrollPrimary` |
| `WText` | Text | `data`, `className`, `selectable` |
| `WButton` | Button | `child`, `onTap`, `isLoading`, `disabled` |
| `WInput` | Text input | `value`, `onChanged`, `type`, `placeholder` |
| `WSelect<T>` | Dropdown | `options`, `value`, `onChange`, `isMulti`, `searchable`, `onSearch`, `menuClassName` |
| `WCheckbox` | Checkbox | `value`, `onChanged`, `iconClassName` |
| `WImage` | Image | `src` (url/`asset://`), `alt`, `placeholder`, `errorBuilder` |
| `WSvg` | SVG | `src` or `WSvg.string(svgString:)` |
| `WIcon` | Icon | `icon` (IconData), `semanticLabel` |
| `WPopover` | Overlay | `triggerBuilder`, `contentBuilder`, `alignment`, `controller` |
| `WSpacer` | Spacing | `className` — lightweight SizedBox (`h-*`/`w-*`) |
| `WFormInput` | Validated input | `validator`, `label`, `hint`, `labelClassName`, `errorClassName` |
| `WFormSelect<T>` | Validated select | Same as WSelect + `validator`, `label` |
| `WFormMultiSelect<T>` | Multi-select | `values`, `onMultiChange`, `onCreateOption` |
| `WFormCheckbox` | Validated checkbox | Same as WCheckbox + `validator` |
| `WFormDatePicker` | Date picker | `value`, `onChange`, `validator`, `minDate`, `maxDate` |
| `WAnchor` | State wrapper | `onTap`, `onLongPress`, `isDisabled`, `states` |

All widgets accept `className` and `states` (Set\<String\>).

## States & Prefixes

**Interaction:** `hover:`, `focus:`, `disabled:`, `loading:`, `checked:`, `error:`, `open:`, `selected:`

**Dark mode:** `dark:bg-gray-900 dark:text-white`

**Responsive (mobile-first):** `sm:` (640), `md:` (768), `lg:` (1024), `xl:` (1280), `2xl:` (1536)

**Platform:** `mobile:`, `macos:`, `windows:`, `web:`, `ios:`, `android:`

**Custom states:**
```dart
WDiv(
  className: 'bg-white active:bg-blue-500',
  states: {'active'},  // Set<String>
)
```

WDiv auto-wraps in WAnchor when `hover:`/`focus:`/`active:` prefixes are detected.

## Common Patterns

### Layout
```dart
// Responsive row/column
WDiv(className: 'flex flex-col md:flex-row gap-4 p-6')

// Grid
WDiv(className: 'grid grid-cols-2 md:grid-cols-3 gap-4')

// Centered
WDiv(className: 'flex justify-center items-center h-full')
```

### Scrollable Content
```dart
// Scrollable container with max height
WDiv(
  className: 'overflow-y-auto max-h-[300px] p-4',
  child: content,
)

// Main page scroll (iOS status bar tap-to-top)
WDiv(
  className: 'overflow-y-auto flex flex-col gap-6 p-4 lg:p-6',
  scrollPrimary: true,  // Enables PrimaryScrollController integration
  children: [/* page content */],
)
```

### Card
```dart
WDiv(
  className: 'bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6 border border-gray-100 dark:border-gray-700',
  children: [
    WText('Title', className: 'text-xl font-bold text-gray-900 dark:text-white'),
    WText('Body', className: 'text-sm text-gray-600 dark:text-gray-400 mt-2'),
  ],
)
```

### Button
```dart
WButton(
  className: 'bg-primary hover:bg-green-600 text-white px-4 py-2 rounded-lg disabled:opacity-50',
  onTap: () {},
  isLoading: isSubmitting,
  child: WText('Submit'),
)
```

### Form Input
```dart
WFormInput(
  className: 'w-full px-3 py-3 rounded-lg bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 focus:border-primary focus:ring-2 focus:ring-primary/20 error:border-red-500',
  label: 'Email',
  labelClassName: 'text-sm font-medium text-gray-700 dark:text-gray-300',
  errorClassName: 'text-xs text-red-500 mt-1',
  validator: (v) => v?.contains('@') == true ? null : 'Invalid email',
)
```

### Select with Search
```dart
WSelect<String>(
  className: 'border rounded-lg px-3 py-3',
  menuClassName: 'bg-white dark:bg-gray-800 rounded-xl shadow-xl border border-gray-200 dark:border-gray-700',
  options: [SelectOption(value: 'a', label: 'Option A')],
  value: selected,
  onChange: (v) => setState(() => selected = v),
  searchable: true,
  onSearch: (query) async => await fetchOptions(query),  // Async search
)
```

### Multi-Select with Tag Creation
```dart
WFormMultiSelect<String>(
  values: _tags,
  options: _tagOptions,
  onMultiChange: (tags) => setState(() => _tags = tags),
  searchable: true,
  onCreateOption: (query) async {
    final opt = SelectOption(value: query, label: query);
    setState(() => _tagOptions.add(opt));  // MUST persist in state
    return opt;
  },
)
```

### Spacing with WSpacer
```dart
WDiv(
  className: 'flex flex-col',
  children: [
    WFormInput(...),
    const WSpacer(className: 'h-4'),  // 16px vertical gap
    WFormInput(...),
  ],
)
```

### Theme Setup
```dart
WindTheme(
  initialData: WindThemeData(
    colors: {...WindThemeData.defaultColors, 'primary': {'500': Color(0xFF009E60)}},
  ),
  child: MaterialApp(...),
)
```

Access: `WindTheme.of(context)` (controller), `WindTheme.dataOf(context)` (data), `context.windTheme.toggleTheme()`.

## Key Rules

1. **Last class wins** — later classes override earlier ones for same property
2. **Spacing scale** — N * 4px: `p-4` = 16px, `gap-2` = 8px
3. **Arbitrary values** — bracket syntax: `w-[200px]`, `text-[#FF0000]`, `aspect-[16/9]`
4. **Opacity shorthand** — `bg-red-500/50`, `text-blue-500/75`
5. **Fraction sizing** — `w-1/2`, `w-1/3`, `w-2/3`, `w-1/4`, `w-3/4`
6. **WSelect uses WPopover** — debug WPopover for dropdown issues
7. **Cache** — WindParser caches results; call `WindParser.clearCache()` in tests if needed

## Gotchas

| Issue | Solution |
|-------|----------|
| className typos silently fail | No compile errors — double-check spelling |
| `overflow-y-auto` without height | Add `max-h-*` or parent flex constraint |
| `onCreateOption` tag disappears | Must `setState(() => options.add(opt))` to persist |
| Input in same context inconsistent | All inputs must use identical padding (`py-3` everywhere) |
| Dark mode missing | Every bg/text/border needs `dark:` variant |
| WDiv auto-wrapping in WAnchor | Happens when className has `hover:`/`focus:`/`active:` |

## References

- **Utility classes:** See [references/utilities.md](references/utilities.md)
- **Theme scales:** See [references/theme.md](references/theme.md)
