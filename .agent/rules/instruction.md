---
trigger: always_on
---

# Wind - AI Agent Rule Set

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

### WText - Typography
```dart
WText("Hello", className: "text-xl text-blue-500 font-bold uppercase")
```

### WButton - Interactive Button
```dart
WButton(
  onTap: () {}, isLoading: _loading, disabled: _disabled,
  className: "bg-blue-600 hover:bg-blue-700 disabled:opacity-50 loading:opacity-70 px-4 py-2 rounded-lg",
  child: Text("Submit"),
)
```

### WAnchor - State Wrapper (enables hover:/focus:/disabled:)
```dart
WAnchor(
  onTap: () {},
  child: WDiv(className: "bg-white hover:bg-gray-100 focus:ring-2 duration-300", children: [...]),
)
```

### WInput - Form Input
```dart
WInput(
  value: _email, onChanged: (v) => setState(() => _email = v),
  type: InputType.email, placeholder: "Email",
  className: "p-3 border rounded-lg focus:ring-2 focus:ring-blue-500",
)
```

### Other Widgets
- `WIcon(Icons.star, className: "text-yellow-400 text-2xl")`
- `WImage(src: "url", className: "w-full aspect-video object-cover")`
- `WSvg.asset("path.svg", className: "fill-blue-500 w-6 h-6")`
- `WCheckbox(value: v, onChanged: fn, className: "checked:bg-blue-500")`

## Utility Classes

### Layout
`block` `flex` `flex-row` `flex-col` `grid` `wrap` `hidden`

### Flex/Grid
`justify-{start|end|center|between|around|evenly}` `items-{start|end|center|stretch|baseline}`  
`flex-1` `flex-none` `flex-grow` `grid-cols-{1-12}` `gap-{n}` `gap-x-{n}` `gap-y-{n}`

### Sizing
`w-{n}` `h-{n}` (n×4px) `w-full` `h-full` `w-screen` `h-screen` `w-1/2` `w-[100px]`  
`min-w-{n}` `max-w-{n}` `min-h-{n}` `max-h-{n}`

### Spacing
`p-{n}` `px-{n}` `py-{n}` `pt-{n}` `pr-{n}` `pb-{n}` `pl-{n}` `p-[10px]`  
`m-{n}` `mx-{n}` `my-{n}` `mt-{n}` `mr-{n}` `mb-{n}` `ml-{n}`

### Typography
**Sizes:** `text-{xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl}`  
**Weights:** `font-{thin|light|normal|medium|semibold|bold|extrabold|black}`  
**Family:** `font-{sans|serif|mono}`  
**Transform:** `uppercase` `lowercase` `capitalize` `italic`  
**Align:** `text-{left|center|right|justify}` `truncate` `line-clamp-{n}`  
**Decoration:** `underline` `line-through` `no-underline`

### Colors
Pattern: `{bg|text|border|ring|shadow}-{color}-{shade}` or `{...}-{color}-{shade}/{opacity}`  
**Colors:** slate, gray, zinc, neutral, stone, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose, white, black, transparent  
**Shades:** 50, 100, 200, 300, 400, 500, 600, 700, 800, 900  
**Arbitrary:** `bg-[#FF5733]` `text-[rgb(255,87,51)]`

### Borders
`border` `border-{0|2|4|8}` `border-{t|r|b|l}` `border-{color}-{shade}`  
`rounded` `rounded-{none|sm|md|lg|xl|2xl|3xl|full}`

### Effects
`shadow-{sm|DEFAULT|md|lg|xl|2xl|none}` `shadow-{color}-{shade}`  
`ring` `ring-{0|1|2|4|8}` `ring-{color}` `ring-offset-{n}` `ring-inset`  
`opacity-{0|25|50|75|100}` `opacity-[0.3]`

### Aspect Ratio
`aspect-{auto|square|video}` `aspect-[4/3]`

### Overflow
`overflow-{visible|hidden|scroll|auto}` `overflow-{x|y}-{scroll|hidden|auto}`

### Z-Index
`z-{0|10|20|30|40|50}` `z-[100]`

### Gradients
`bg-gradient-to-{t|tr|r|br|b|bl|l|tl} from-{color}-{shade} via-{color}-{shade} to-{color}-{shade}`

## State Prefixes

| Prefix | Trigger |
|--------|---------|
| `hover:` | Mouse hover (requires WAnchor) |
| `focus:` | Focus (requires WAnchor) |
| `disabled:` | disabled=true |
| `loading:` | WButton isLoading=true |
| `checked:` | WCheckbox value=true |
| `dark:` | Dark mode |
| `ios:` `android:` `web:` `mobile:` | Platform |
| `sm:` `md:` `lg:` `xl:` `2xl:` | Breakpoints (≥640/768/1024/1280/1536px) |

Custom states via `states` prop: `states: {'loading', 'error'}` → `loading:bg-gray-400 error:border-red-500`

## Animations

### Transitions (implicit)
`duration-{75|100|150|200|300|500|700|1000}` `ease-{linear|in|out|in-out}`

### Animations (explicit looping)
`animate-{spin|pulse|bounce|ping|none}`

```dart
// Smooth hover
WDiv(className: "bg-blue-500 hover:bg-blue-700 hover:scale-105 duration-300 ease-out", ...)

// Loading spinner
WIcon(Icons.refresh, className: "animate-spin text-blue-500")
```

## Theme

```dart
WindTheme(
  data: WindThemeData(
    colors: {'primary': Colors.indigo},
    brightness: Brightness.light,
  ),
  builder: (context, controller) => MaterialApp(
    theme: controller.data.toThemeData(),
    home: MyApp(),
  ),
)

// Toggle theme
context.windTheme.toggleTheme();
```

## Helpers

```dart
context.windTheme          // WindThemeController (toggle/update)
context.windThemeData      // WindThemeData (read-only)
context.wIsMobile          // bool
context.wIsDesktop         // bool
wColor(context, 'blue', 500)  // Color
wSpacing(context, 4)          // double (16.0)
```

## Best Practices

✅ **DO:**
```dart
WDiv(className: "p-4 bg-white rounded-lg shadow-md", ...)
WAnchor(onTap: fn, child: WDiv(className: "hover:bg-gray-100", ...))
```

❌ **DON'T:**
```dart
Container(padding: EdgeInsets.all(16), ...)  // Use className
WDiv(className: "hover:bg-gray-100", ...)    // hover: requires WAnchor
WDiv(child: X, children: [Y])                // Never both
```

## Debugging

Add `debug` class to see widget composition in console:
```dart
WDiv(className: "debug p-4 bg-red-500", ...)
```
