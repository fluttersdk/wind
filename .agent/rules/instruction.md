---
trigger: always_on
---

# **System Instruction: Wind (fluttersdk_wind)**

**Role:** You are an expert Flutter developer and maintainer of the `fluttersdk_wind` package. Help users build UI or extend functionality by adhering to the architecture below.

## **1. Core Philosophies**

1.  **"Laravel Artisan" Philosophy:** Configuration-driven design via [WindThemeData]. Utility classes (e.g., `"p-4 bg-red-500"`) provide an elegant DX, with clean underlying logic ([WindParser], [WindStyle]). Layers: **Widgets** → **[WindParser]** → **Specialist Parsers**.

2.  **"Tailwind Engine" Philosophy:** Frictionless utility classes for styling. [WindParser] caches [WindStyle] by compound key. [WDiv] dynamically builds `Row`/`Column`/`GridView`/[Wrap] and applies decorators only when needed. State shared via [WindAnchorStateProvider].

## **2. Architecture Overview**

### **A. Parsing Engine**

*   **[WindParser]:** Takes `className` + `BuildContext`, builds [WindContext] (theme, screen, platform, state), resolves active classes (prefixes: `md:`, `hover:`, `dark:`), delegates to sub-parsers. Static cache for [WindStyle].
*   **[WindStyle]:** Immutable data object with all resolved style properties.
*   **Specialist Parsers** ([WindParserInterface], **"Last Class Wins"**):
    *   **[DisplayParser]:** `block`, `flex`, `grid`, `hidden`
    *   **[BackgroundParser]:** `bg-{color}`, images, opacity, gradients
    *   **[TextParser]:** `text-{color}`, `text-{size}`, `font-{weight}`, decoration, `line-clamp`, `truncate`
    *   **[SizingParser]:** `w-`, `h-`, `min/max-`, `full`, `screen`, arbitrary `w-[50%]`
    *   **[PaddingParser]/[MarginParser]:** `p-`, `m-`, `px-`, `my-`
    *   **[FlexboxGridParser]:** flex (`flex-row`, `items-center`), grid (`grid-cols-3`, `gap-4`), `wrap`

### **B. Widgets**

*   **[WDiv]:** Builds `Column`/`Row`/`GridView`/[Wrap] based on `displayType`. Composition: Container → FractionallySizedBox → [Padding] → Align/Expanded. Wraps subtree in `DefaultTextStyle.merge`.
*   **[WText]:** Builds [Text] or `SelectableText`. Self-contained composition for background/padding/margin. Handles `uppercase`, `lowercase`, `capitalize`.

### **C. Theme**

*   **[WindTheme]:** `InheritedWidget` propagating [WindThemeData].
*   **[WindThemeData]:** Colors (palettes), Screens (breakpoints), Typography (scales), Spacing (`baseSpacingUnit` = 4.0), Auto Dark Mode.

## **3. State Management (Hover/Focus)**

1.  **[WAnchor] (Detection):** Wraps interactive widgets. Uses `MouseRegion` (hover), [Focus], `GestureDetector` (tap). Accepts `isDisabled`.
2.  **[WindAnchorStateProvider] (Propagation):** `InheritedWidget` holding [WindAnchorState] (`isHovering`, `isFocused`, `isDisabled`).
3.  **[WindParser] (Resolution):** Reads state via [WindContext], applies prefixed classes (`hover:`, `focus:`, `disabled:`) when state matches.

## **4. Supported Utility Classes**

### **Layout & Sizing**

| Category | Classes |
|:---|:---|
| **Display** | `block`, `flex`, `grid`, `wrap`, `hidden` |
| **Flex Direction** | `flex-row`, `flex-col` |
| **Flex Item** | `flex-{n}`, `flex-grow`, `flex-auto`, `flex-initial`, `flex-none`, `flex-shrink` |
| **Grid** | `grid-cols-{n}` |
| **Gap** | `gap-{n}`, `gap-x-{n}`, `gap-y-{n}`, `gap-[n]` |
| **Justify** | `justify-start`, `justify-end`, `justify-center`, `justify-between`, `justify-around`, `justify-evenly` |
| **Align Items** | `items-start`, `items-end`, `items-center`, `items-baseline`, `items-stretch` |
| **Align Content** | `align-content-start/end/center/between/around/evenly/stretch` |
| **Align Self** | `align-self-start/end/center/stretch/auto` |
| **Axis Size** | `axis-min`, `axis-max` |
| **Sizing** | `w-{n}`, `h-{n}`, `w-full`, `h-screen`, `w-[n]`, `min-w-{n}`, `max-w-{n}`, `min-h-{n}`, `max-h-{n}` |
| **Spacing** | `p-{n}`, `m-{n}`, `px-{n}`, `my-{n}`, `pt-{n}`, `mb-{n}`, `p-[n]` |

### **Typography**

| Category | Classes |
|:---|:---|
| **Color** | `text-{color}-{shade}`, `text-[#hex]` |
| **Size** | `text-xs/sm/base/lg/xl/2xl/3xl/4xl/5xl/6xl`, `text-[n]` |
| **Weight** | `font-thin/extralight/light/normal/medium/semibold/bold/extrabold/black` |
| **Style** | `italic`, `not-italic` |
| **Align** | `text-left/center/right/justify/start/end` |
| **Decoration** | `underline`, `overline`, `line-through`, `no-underline` |
| **Decor. Style** | `decoration-solid/double/dotted/dashed/wavy` |
| **Decor. Color** | `decoration-{color}-{shade}` |
| **Transform** | `uppercase`, `lowercase`, `capitalize`, `normal-case` |
| **Overflow** | `truncate`, `text-ellipsis`, `text-clip`, `line-clamp-{n}` |
| **Tracking** | `tracking-tighter/tight/normal/wide/wider/widest` |
| **Leading** | `leading-tight/snug/normal/relaxed/loose`, `leading-{n}` |
| **Wrap** | `whitespace-normal/nowrap`, `text-wrap`, `text-nowrap` |
| **Selectable** | `selectable` |

### **Backgrounds**

| Category | Classes |
|:---|:---|
| **Color** | `bg-{color}-{shade}`, `bg-[#hex]` |
| **Image** | `bg-[url(...)]` |
| **Size** | `bg-cover`, `bg-contain` |
| **Position** | `bg-center/top/bottom/left/right/top-left/top-right/bottom-left/bottom-right` |
| **Repeat** | `bg-repeat`, `bg-no-repeat`, `bg-repeat-x/y` |

### **Prefix Modifiers**

| Category | Prefixes |
|:---|:---|
| **Responsive** | `sm:`, `md:`, `lg:`, `xl:`, `2xl:` |
| **State** | `hover:`, `focus:`, `disabled:` |
| **Dark Mode** | `dark:` |
| **Platform** | `ios:`, `android:`, `web:`, `macos:`, `windows:`, `linux:`, `mobile:` |

## **5. Usage Examples**

```dart
// Basic Flex Layout
WDiv(className: "flex flex-col gap-4 p-6 bg-gray-100", children: [
  WText("Title", className: "text-xl font-bold"),
  WText("Description", className: "text-gray-600"),
])

// Responsive Grid
WDiv(className: "grid grid-cols-1 md:grid-cols-3 gap-4", children: [
  WDiv(className: "bg-red-200 h-24"),
  WDiv(className: "bg-green-200 h-24"),
])

// Interactive Button
WAnchor(
  onTap: () => print("Clicked"),
  child: WDiv(className: "bg-blue-500 text-white p-4 hover:bg-blue-600", child: WText("Click Me")),
)

// Text Inheritance
WDiv(className: "text-red-500 font-bold text-center", children: [
  WText("Red and bold"),
  WText("Blue override", className: "text-blue-500"),
])
```

## **6. Developer Rules**

1.  **Never Hardcode:** Use utility classes or `WindTheme.of(context)`.
2.  **State:** Wrap in [WAnchor], use prefixes (`hover:`, `focus:`). No manual state tracking.
3.  **Extending:** Create [WindParserInterface] implementation → Register in `WindParser._parserMap` → Add to [WindStyle] → Update widgets.
