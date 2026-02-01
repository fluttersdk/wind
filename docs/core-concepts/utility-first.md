# Utility-First Fundamentals

Wind introduces a utility-first styling workflow to Flutter, inspired by the speed and flexibility of Tailwind CSS. Instead of composing deeply nested widget trees for styling, you use utility classes directly in your code.

<x-preview path="examples/basic"></x-preview>

## The Shift in Thinking

Traditionally, styling in Flutter involves composing multiple widgets. To create a card with a shadow, rounded corners, padding, and centered content, you might write:

```dart
// Traditional Flutter
Container(
  width: 200,
  height: 200,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: const Center(
    child: Text(
      "Hello World",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  ),
)
```

With Wind, you express the same intent more concisely using utility classes:

```dart
// Wind UI
WDiv(
  className: "w-48 h-48 p-4 bg-white rounded-xl shadow-lg flex items-center justify-center",
  child: WText(
    "Hello World",
    className: "text-lg font-bold text-black",
  ),
)
```

## Why "Utility-First"?

### 1. Speed & Velocity
You don't need to jump between files or scroll up to a `style` definition. You style your UI right where you build it. This leads to a much faster feedback loop and rapid prototyping.

### 2. Lower Cognitive Load
Instead of remembering dozens of widget names (`Padding`, `Align`, `Center`, `DecoratedBox`, `SizedBox`, `Opacity`...) and their specific properties, you learn a small set of composable utility classes (`p-4`, `flex`, `bg-blue`, `opacity-50`).

### 3. Consistency by Default
Wind encourages consistency. Instead of "magic numbers" (e.g., `padding: 13.0`), you use a spacing scale (`p-4` = 16px). This ensures your UI looks consistent across the entire application without strict discipline.

### 4. Responsive & Interactive
Handling different screen sizes or states like hover usually requires complex logic in Flutter (`LayoutBuilder`, `MouseRegion`, `AnimationController`). In Wind, it's just a prefix:
- **Hover:** `hover:bg-blue-600`
- **Dark Mode:** `dark:text-white`
- **Responsive:** `md:w-1/2`

## How it Works

Wind uses a **Compiler-free, Runtime Parser**. When you use `WDiv`:

1.  **Tokenization**: The string `"p-4 bg-blue-500 rounded-lg"` is split into tokens.
2.  **Parsing**: Each parser (Spacing, Color, Border, etc.) processes relevant tokens.
    - `p-4` → `EdgeInsets.all(16)`
    - `bg-blue-500` → `Color(0xFF3B82F6)`
    - `rounded-lg` → `BorderRadius.circular(8)`
3.  **Composition**: `WDiv` intelligently builds the optimal Flutter widget tree. It only adds the widgets you need.
    - If you have `p-4`, it wraps content in `Padding`.
    - If you have `flex`, it uses `Row` or `Column`.
    - If you use `w-full`, it handles layout constraints intelligently.

> **Performance Note:**
> Wind uses an LRU (Least Recently Used) cache for parsed styles. The first time a class string is used, it takes a few microseconds to parse. Subsequent uses are instantaneous (O(1) lookup), making it performant even for complex lists.

## Syntax Guide

Wind follows the Tailwind CSS syntax almost exactly:

| Concept | Syntax | Example | Description |
|---------|--------|---------|-------------|
| **Utility** | `property-value` | `p-4` | Sets padding to scale 4 (16px) |
| **Color** | `type-color-shade` | `bg-blue-500` | Sets background to blue 500 |
| **Negative** | `-property-value` | `-m-4` | Sets negative margin |
| **Arbitrary** | `property-[value]` | `w-[350px]` | Sets exact width to 350px |
| **Opacity** | `class/opacity` | `bg-red-500/50` | Sets background color with 50% opacity |
| **Important** | `!class` | `!p-0` | (Not yet supported, but planned) |

## State & Responsiveness

Wind makes handling states trivial via **variant modifiers**:

```dart
WButton(
  className: '''
    bg-blue-500 text-white p-4 rounded-lg
    hover:bg-blue-600 hover:scale-105
    active:bg-blue-700
    dark:bg-slate-800 dark:text-gray-200
    md:w-96
    transition-all duration-200
  ''',
  child: WText("Interactive Button"),
)
```

Learn more in the [State Management](./state-management.md) and [Responsive Design](./responsive-design.md) guides.
