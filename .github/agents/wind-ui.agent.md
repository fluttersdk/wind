---
name: 'wind-ui'
description: 'Wind framework expert — className patterns, layout rules, widget composition, responsive/dark mode styling'
tools: ['read', 'edit', 'create_file', 'search', 'run_terminal_cmd']
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
| `WPopover` | Overlay | `triggerBuilder`, `contentBuilder`, `alignment`, `controller`, `offset`, `maxHeight` |
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

WDiv auto-wraps in WAnchor when `hover:`/`focus:`/`active:` prefixes are detected.

## Common Patterns

### Layout
```dart
WDiv(className: 'flex flex-col md:flex-row gap-4 p-6')
WDiv(className: 'grid grid-cols-2 md:grid-cols-3 gap-4')
WDiv(className: 'wrap gap-2', children: [...])  // Wrapping layout
WDiv(className: 'flex justify-center items-center h-full')
```

### Scrollable Content
```dart
WDiv(
  className: 'overflow-y-auto max-h-[300px] p-4',
  child: content,
)
WDiv(
  className: 'overflow-y-auto flex flex-col gap-6 p-4 lg:p-6',
  scrollPrimary: true,
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

### Theme Setup
```dart
WindTheme(
  initialData: WindThemeData(
    colors: {...WindThemeData.defaultColors, 'primary': {'500': Color(0xFF009E60)}},
  ),
  child: MaterialApp(...),
)
```

## Key Rules

1. **Last class wins** — later classes override earlier ones for same property
2. **Spacing scale** — N * 4px: `p-4` = 16px, `gap-2` = 8px
3. **Arbitrary values** — bracket syntax: `w-[200px]`, `text-[#FF0000]`
4. **Opacity shorthand** — `bg-red-500/50`, `text-blue-500/75`
5. **Cache** — WindParser caches results; call `WindParser.clearCache()` in tests

## Gotchas

| Issue | Solution |
|-------|----------|
| className typos silently fail | No compile errors — double-check spelling |
| `overflow-y-auto` without height | Add `max-h-*` or parent flex constraint |
| Dark mode missing | Every bg/text/border needs `dark:` variant |
| **`flex-wrap` is a NO-OP** | Use `wrap gap-2` instead. `flex` creates Row/Column which cannot wrap |
