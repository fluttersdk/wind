# Wind UI - AI Agent Rule Set

Expert Flutter developer guide for `fluttersdk_wind`. Use Tailwind-like utility strings instead of manual Flutter styling.

## Core Widgets

### WDiv - Universal Container
```dart
WDiv(className: "flex gap-4 p-4 bg-gray-100 rounded-lg", children: [...])
WDiv(className: "p-4 bg-white shadow-md", child: WText("Single"))
```
- `child`: Single widget (block layout)  
- `children`: Multiple widgets (flex/grid/wrap) - **never use both**
- `states`: Custom states for `loading:`, `error:` prefixes

**Layout Detection:** `flex`/`flex-row`/`flex-col`→Flex, `grid`→Grid, `wrap`→Wrap, default→Block

### WText - Typography
```dart
WText("Hello", className: "text-xl text-blue-500 font-bold uppercase")
WText("Selectable", className: "text-gray-700", selectable: true)
```

### WButton - Interactive Button
```dart
WButton(
  onTap: () {}, isLoading: _loading, disabled: _disabled,
  className: "bg-blue-600 hover:bg-blue-700 disabled:opacity-50 loading:opacity-70 px-4 py-2 rounded-lg",
  child: Text("Submit"),
)
```

### WAnchor - State Wrapper (REQUIRED for hover:/focus:)
```dart
WAnchor(
  onTap: () {}, isDisabled: false, states: {'active'},
  child: WDiv(className: "bg-white hover:bg-gray-100 focus:ring-2 duration-300", children: [...]),
)
```
**CRITICAL:** `hover:` and `focus:` prefixes ONLY work when wrapped in `WAnchor` or `WButton`.

### WInput - Form Input
```dart
WInput(
  value: _email, onChanged: (v) => setState(() => _email = v),
  type: InputType.email, placeholder: "Email",
  className: "p-3 border rounded-lg focus:ring-2 focus:ring-blue-500 flex-1",
  states: _hasError ? {'error'} : null,
)
```
**InputTypes:** `text`, `password`, `email`, `number`, `multiline`

> **Note:** `flex-1` and `flex-auto` classes automatically wrap WInput with Expanded/Flexible.

### WIcon / WImage / WSvg
```dart
WIcon(Icons.star, className: "text-yellow-400 text-2xl")
WImage(src: "https://...", className: "w-full aspect-video object-cover rounded-lg")
WSvg(src: "assets/icon.svg", className: "fill-blue-500 w-6 h-6")
```

### WCheckbox
```dart
WCheckbox(
  value: isChecked, onChanged: (v) => setState(() => isChecked = v),
  className: "w-5 h-5 rounded border border-gray-300 checked:bg-blue-500",
  states: hasError ? {'error'} : null, // Custom states for error:, loading:, etc.
)
```

### WSelect - Advanced Dropdown
```dart
// Basic Single Select
WSelect<String>(
  value: _selected,
  options: [SelectOption(value: 'a', label: 'Option A', icon: Icons.star)],
  onChange: (v) => setState(() => _selected = v),
  className: "w-64 bg-white border rounded-lg p-3",
  menuClassName: "bg-white shadow-lg rounded-lg",
  placeholder: "Select option",
)

// Multi-Select
WSelect<String>(isMulti: true, values: _tags, options: tagOptions,
  onMultiChange: (v) => setState(() => _tags = v), searchable: true)

// Remote Search
WSelect<User>(searchable: true, onSearch: (q) async => await api.search(q), ...)

// Pagination
WSelect<Product>(onLoadMore: () async => await api.loadMore(_page++), hasMore: true, ...)

// Tagging (Create New)
WSelect<String>(isMulti: true, onCreateOption: (q) async => SelectOption(value: q, label: q), ...)
```

**WSelect Props:**
| Prop | Type | Description |
|------|------|-------------|
| `value` / `values` | `T?` / `List<T>?` | Selected value(s) |
| `onChange` / `onMultiChange` | Callback | Selection change |
| `isMulti` | `bool` | Enable multi-select |
| `options` | `List<SelectOption<T>>` | Available options |
| `searchable` | `bool` | Show search input |
| `onSearch` | `Future<List> Function(String)` | Remote search |
| `onLoadMore` | `Future<List> Function()` | Pagination |
| `hasMore` | `bool` | More pages available |
| `onCreateOption` | `Future<SelectOption> Function(String)` | Create new option |
| `disabled` | `bool` | Disable select |
| `className` / `menuClassName` | `String?` | Styling |
| `states` | `Set<String>?` | Custom states |

**Builders:** `triggerBuilder`, `itemBuilder`, `selectedChipBuilder`, `emptyBuilder`, `loadingBuilder`

## Form Widgets (Flutter Form Integration)

> `WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox` wrap base widgets with `FormField`. Auto-add `error` state on validation fail.

### WFormInput
```dart
WFormInput(
  controller: _emailController, // Optional - syncs with FormFieldState
  type: InputType.email, label: "Email", hint: "We won't share your email",
  className: "p-3 border rounded-lg error:border-red-500 error:ring-2",
  validator: (v) => v?.isEmpty ?? true ? "Required" : null,
)
```

### WFormSelect / WFormMultiSelect
```dart
WFormSelect<String>(
  value: _country, options: countryOptions,
  onChange: (v) => setState(() => _country = v),
  label: "Country", className: "w-64 border rounded-lg error:border-red-500",
  searchable: true, validator: (v) => v == null ? "Required" : null,
)

WFormMultiSelect<String>(
  values: _tags, options: tagOptions,
  onMultiChange: (v) => setState(() => _tags = v),
  label: "Tags", hint: "Select up to 5",
  searchable: true, onCreateOption: (q) async => SelectOption(value: q, label: q),
  validator: (v) => v?.isEmpty ?? true ? "Select at least one" : null,
)
```

### WFormCheckbox
```dart
WFormCheckbox(
  value: _agree, onChanged: (v) => setState(() => _agree = v),
  labelText: "I agree to Terms", hint: "You must accept",
  className: "w-5 h-5 error:border-red-500",
  validator: (v) => v != true ? "Must agree" : null,
)
```

**Form Common Props:** `label`/`labelText`, `hint`, `showError`, `validator`, `autovalidateMode`, `states`

## Utility Classes

### Layout
`block` `flex` `flex-row` `flex-col` `grid` `wrap` `hidden`
`justify-{start|end|center|between|around|evenly}` `items-{start|end|center|stretch|baseline}`
`flex-1` `flex-auto` `flex-none` `flex-grow` `grid-cols-{1-12}` `gap-{n}` `gap-x-{n}` `gap-y-{n}`

### Sizing
`w-{n}` `h-{n}` (n×4px) `w-full` `h-full` `w-screen` `h-screen` `w-1/2` `w-1/3` `w-[100px]`
`min-w-{n}` `max-w-{n}` `min-h-{n}` `max-h-{n}` `min-w-0` `max-w-7xl`

### Spacing
`p-{n}` `px-{n}` `py-{n}` `pt-{n}` `pr-{n}` `pb-{n}` `pl-{n}` `p-[10px]`
`m-{n}` `mx-{n}` `my-{n}` `mt-{n}` `mr-{n}` `mb-{n}` `ml-{n}` `mx-auto`

### Typography
`text-{xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl}` `font-{thin|light|normal|medium|semibold|bold|extrabold}`
`font-{sans|serif|mono}` `text-{left|center|right|justify}` `uppercase` `lowercase` `capitalize` `italic` `truncate` `line-clamp-{n}`

### Colors
`{bg|text|border|ring|shadow|fill|stroke}-{color}-{shade}` or with opacity `/{0-100}`
**Colors:** slate, gray, zinc, neutral, stone, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose, white, black, transparent
**Shades:** 50, 100, 200, 300, 400, 500, 600, 700, 800, 900
**Arbitrary:** `bg-[#FF5733]` `text-[rgb(255,87,51)]` `border-white/10`

### Borders & Effects
`border` `border-{0|2|4|8}` `border-{t|r|b|l}` `border-{color}` `border-dashed`
`rounded` `rounded-{none|sm|md|lg|xl|2xl|3xl|full}`
`shadow-{sm|DEFAULT|md|lg|xl|2xl|none}` `ring` `ring-{0|1|2|4|8}` `ring-{color}` `ring-offset-{n}`
`opacity-{0|25|50|75|100}` `overflow-{visible|hidden|scroll|auto}`

### Gradients
`bg-gradient-to-{t|tr|r|br|b|bl|l|tl} from-{color}-{shade} via-{color}-{shade} to-{color}-{shade}`

## State Prefixes

| Prefix | Trigger | Requires |
|--------|---------|----------|
| `hover:` | Mouse hover | WAnchor/WButton |
| `focus:` | Focus state | WAnchor/WButton |
| `disabled:` | disabled=true | - |
| `loading:` | isLoading=true | WButton |
| `checked:` | value=true | WCheckbox |
| `open:` | Menu open | WSelect |
| `error:` | Validation error | Form widgets |
| `dark:` | Dark mode | WindTheme |
| `sm:` `md:` `lg:` `xl:` `2xl:` | Breakpoints (≥640/768/1024/1280/1536px) | - |

**Custom states:** `states: {'error'}` → `error:border-red-500`

## Animations
`duration-{75|100|150|200|300|500|700|1000}` `ease-{linear|in|out|in-out}`
`animate-{spin|pulse|bounce|ping|none}`

## Real-World Patterns

### Conditional Classes
```dart
WDiv(className: "flex ${isActive ? 'border-indigo-500 text-white' : 'border-transparent text-gray-400'}", ...)
```

### Responsive Navigation
```dart
WDiv(className: "hidden sm:flex gap-x-8", children: [...])  // Desktop only
WDiv(className: "flex items-center sm:hidden", child: ...)  // Mobile only
WDiv(className: "mx-auto max-w-7xl px-4 sm:px-6 lg:px-8", child: ...)  // Responsive padding
```

### Gradient Button
```dart
WButton(onTap: () {},
  child: WDiv(className: "py-3 rounded-xl bg-gradient-to-r from-indigo-500 to-purple-500 hover:from-indigo-600 duration-300",
    child: WText("Follow")))
```

## Theme & Helpers

```dart
WindTheme(
  data: WindThemeData(colors: {'primary': Colors.indigo}, brightness: Brightness.light),
  builder: (context, controller) => MaterialApp(theme: controller.toThemeData(), home: MyApp()),
)
context.windTheme.toggleTheme(); // Toggle dark/light
```

### wColor - Global Color Resolver
```dart
wColor(context, 'blue', shade: 500)  // Color?
wColor(context, 'white', darkColorName: 'gray', darkShade: 900)  // Dark mode fallback
wColor(context, '#FF5733')  // Hex colors
wColor(context, 'primary')  // Theme colors
```

### Context Extensions
```dart
context.windTheme          // WindThemeController
context.windThemeData      // WindThemeData
context.wColorExt('blue', shade: 500)  // Color? (named parameter)
context.wSpacingExt(4)     // double (16.0)
context.wIsMobile / context.wIsDesktop / context.windIsDark  // bools
```

## Rules

✅ **DO:**
- Use `WDiv(className: ...)` instead of `Container`, `Row`, `Column`
- Wrap interactive elements with `WAnchor` for `hover:`/`focus:`
- Use string interpolation for conditional classes
- Add `duration-{n}` for smooth transitions

❌ **DON'T:**
- Use `hover:` without `WAnchor` or `WButton` wrapper
- Use both `child` and `children` in `WDiv`
- Forget to wrap app with `WindTheme`

## Debug
`WDiv(className: "debug p-4 bg-red-500", ...)` prints widget composition to console
