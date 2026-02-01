---
name: wind-ui
description: >
  FlutterSDK Wind framework usage guide for building Flutter UIs with Tailwind-like utility classes.
  Use when writing Flutter code that uses Wind widgets (WDiv, WText, WButton, WInput, WSelect, WCheckbox,
  WImage, WSvg, WIcon, WPopover, WFormInput, WFormSelect, WFormCheckbox, WAnchor), when composing
  className strings with utility classes (bg-*, text-*, flex, grid, p-*, m-*, rounded-*, shadow-*, etc.),
  when implementing responsive layouts (sm:/md:/lg:/xl:/2xl: prefixes), dark mode (dark: prefix),
  interaction states (hover:/focus:/disabled:), or when configuring WindTheme. Also use when debugging
  Wind class parsing, creating custom themes, or building forms with Wind widgets.
---

# Wind Framework Usage

Wind is a utility-first Flutter UI framework. All styling is done via `className` strings parsed into Flutter widgets.

**Pipeline:** `className string -> WindParser -> WindStyle -> Widget tree`

## Widgets

| Widget | Purpose | Key Props |
|--------|---------|-----------|
| `WDiv` | Container/layout | `className`, `child`/`children`, `states` |
| `WText` | Text | `data`, `className`, `selectable` |
| `WButton` | Button | `child`, `onTap`, `isLoading`, `disabled`, `className` |
| `WInput` | Text input | `value`, `onChanged`, `type` (text/password/email/number/multiline), `placeholder`, `placeholderClassName` |
| `WSelect<T>` | Dropdown | `options` (List\<SelectOption\<T\>\>), `value`, `onChange`, `isMulti`, `searchable`, `menuClassName` |
| `WCheckbox` | Checkbox | `value`, `onChanged`, `iconClassName` |
| `WImage` | Image | `src` (url or `asset://path`), `alt`, `placeholder`, `errorBuilder` |
| `WSvg` | SVG | `src` or `WSvg.string(svgString:)` |
| `WIcon` | Icon | `icon` (IconData), `semanticLabel` |
| `WPopover` | Overlay | `triggerBuilder`, `contentBuilder`, `alignment` (PopoverAlignment enum), `controller` |
| `WFormInput` | Validated input | `validator`, `label`, `labelClassName`, `errorClassName`, `showError` |
| `WFormSelect<T>` | Validated select | Same as WSelect + `validator` |
| `WFormCheckbox` | Validated checkbox | Same as WCheckbox + `validator` |
| `WAnchor` | State wrapper | `onTap`, `onLongPress`, `isDisabled`, `states` |

All widgets accept `className` and `states` (Map\<String, bool\>).

## States & Prefixes

**Interaction:** `hover:`, `focus:`, `disabled:`, `loading:`, `checked:`, `error:`, `open:`, `selected:`

**Dark mode:** `dark:bg-gray-900 dark:text-white`

**Responsive (mobile-first):** `sm:` (640), `md:` (768), `lg:` (1024), `xl:` (1280), `2xl:` (1536)

**Platform:** `mobile:`, `macos:`, `windows:`, `web:`, `ios:`, `android:`

**Custom states:**
```dart
WDiv(
  className: 'bg-white active:bg-blue-500',
  states: {'active': isActive},
)
```

WDiv auto-wraps in WAnchor when hover:/focus:/disabled: prefixes are detected.

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

### Card
```dart
WDiv(
  className: 'bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200',
  children: [
    WText('Title', className: 'text-xl font-bold text-gray-900 dark:text-white'),
    WText('Body', className: 'text-sm text-gray-600 dark:text-gray-400 mt-2'),
  ],
)
```

### Button
```dart
WButton(
  className: 'bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg',
  onTap: () {},
  child: WText('Submit'),
)
```

### Form
```dart
WFormInput(
  className: 'border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 error:border-red-500',
  label: 'Email',
  labelClassName: 'text-sm font-medium text-gray-700',
  errorClassName: 'text-xs text-red-500 mt-1',
  validator: (v) => v?.contains('@') == true ? null : 'Invalid',
)
```

### Select
```dart
WSelect<String>(
  className: 'border rounded-lg px-3 py-2',
  menuClassName: 'bg-white rounded-xl shadow-xl',
  options: [SelectOption(value: 'a', label: 'Option A')],
  value: selected,
  onChange: (v) => setState(() => selected = v),
)
```

### Theme Setup
```dart
WindTheme(
  initialData: WindThemeData(
    colors: {...WindThemeData.defaultColors, 'primary': {'500': Color(0xFF6366F1)}},
  ),
  child: MaterialApp(...),
)
```

Access: `WindTheme.of(context)` (controller), `WindTheme.dataOf(context)` (data).

## Key Rules

1. **Last class wins** — later classes override earlier ones for the same property
2. **Spacing scale** — N * 4px: `p-4` = 16px, `gap-2` = 8px
3. **Arbitrary values** — bracket syntax: `w-[200px]`, `text-[#FF0000]`, `aspect-[16/9]`
4. **Opacity shorthand** — `bg-red-500/50`, `text-blue-500/75`
5. **Fraction sizing** — `w-1/2`, `w-1/3`, `w-2/3`, `w-1/4`, `w-3/4`
6. **WSelect uses WPopover** — debug WPopover for dropdown issues
7. **Cache** — WindParser caches results; invalidate in tests if needed

## References

- **Complete utility class list:** See [references/utilities.md](references/utilities.md) for all supported class names by category
- **Theme scales & defaults:** See [references/theme.md](references/theme.md) for color palette, spacing, typography, shadows, and other theme scales
