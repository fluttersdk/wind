# Utility-First Fundamentals

Utility-first styling is the core philosophy of Wind. Instead of building complex, nested widget trees for every design detail, you apply pre-defined utility classes directly to your widgets to compose styles.

- [Introduction](#introduction)
- [The Shift in Thinking](#the-shift-in-thinking)
- [Why Utility-First?](#why-utility-first)
- [How it Works](#how-it-works)
- [Quick Reference](#quick-reference)
- [Syntax Guide](#syntax-guide)

<a name="introduction"></a>
## Introduction

Wind translates utility strings into high-performance Flutter widget trees. This approach moves styling from the "implementation" phase into the "composition" phase, allowing you to build UIs by combining functional building blocks.

<x-preview path="core-concepts/utility_first_hero" size="md" source="example/lib/pages/core-concepts/utility_first_hero.dart"></x-preview>

```dart
WDiv(
  className: 'flex flex-col gap-4 p-6 bg-white rounded-xl shadow-lg border border-gray-100',
  children: [
    WText('Utility-First', className: 'text-2xl font-bold text-blue-600'),
    WText('Style your Flutter apps with ease.', className: 'text-gray-500'),
    WButton(
      className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg',
      child: Text('Get Started'),
    ),
  ],
)
```

<a name="the-shift-in-thinking"></a>
## The Shift in Thinking

Traditionally, styling in Flutter involves deep nesting. To create a simple card with padding and a shadow, you typically wrap widgets inside multiple containers and decorators.

Let's compare the two approaches:

### Traditional Flutter
```dart
// Standard Flutter approach
Container(
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
  child: const Text(
    "Hello World",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### Wind
```dart
// Wind approach
WDiv(
  className: "p-4 bg-white rounded-xl shadow-lg",
  child: WText(
    "Hello World",
    className: "text-lg font-bold",
  ),
)
```

By flattening the widget tree, Wind makes the UI structure more readable and significantly reduces the amount of code required to build complex interfaces.

<a name="why-utility-first"></a>
## Why Utility-First?

Adopting a utility-first workflow provides several architectural advantages:

- **Development Velocity**: Stay within your widget tree. There is no need to jump between separate files or long constructor lists to adjust styling.
- **Design Consistency**: Instead of using magic numbers, you work with a standardized scale (e.g., `p-4` for 16px). This ensures your UI remains visually aligned.
- **Improved Maintainability**: Styles are local to the widget. When you modify a `WDiv`, you see exactly what it affects without worrying about global CSS-like side effects.
- **Declarative Modifiers**: Handling responsiveness (`md:`), dark mode (`dark:`), and states (`hover:`) is handled via simple prefixes rather than conditional logic in your build methods.

<a name="how-it-works"></a>
## How it Works

Wind uses a high-performance pipeline to transform strings into native Flutter styles. This process is optimized through caching to ensure runtime overhead is minimal.

1. **Context Initialization**: `WindContext` captures the current environment, including screen size (breakpoints), brightness, and theme scales.
2. **Parsing**: The `WindParser` tokenizes the `className` string and delegates to specialized parsers for colors, spacing, borders, and more.
3. **Style Composition**: Parsers generate a `WindStyle` object—an immutable, typed representation of the requested styles.
4. **Widget Application**: `W-prefixed` widgets consume this `WindStyle` to dynamically build the optimal Flutter widget hierarchy (e.g., injecting `Padding` or `DecoratedBox` only when needed).

> [!NOTE]
> Wind implements an LRU (Least Recently Used) cache. Once a class string is parsed, subsequent renders retrieve the pre-computed style almost instantly.

<a name="quick-reference"></a>
## Quick Reference

Common utility categories and their primary classes:

| Category | Primary Classes | Description |
|:---------|:----------------|:------------|
| **Layout** | `flex`, `grid`, `block`, `hidden` | Controls positioning and visibility. |
| **Spacing** | `p-4`, `m-2`, `gap-4`, `px-6` | Manages padding, margins, and spacing between children. |
| **Sizing** | `w-full`, `h-64`, `max-w-md` | Defines explicit widths and heights. |
| **Colors** | `bg-blue-500`, `text-white` | Applies theme colors to backgrounds and text. |
| **Borders** | `border`, `rounded-lg`, `ring-2` | Configures borders, radii, and focus rings. |

<a name="syntax-guide"></a>
## Syntax Guide

Wind uses a syntax that matches Tailwind CSS, supporting standard values, arbitrary inputs, and modifiers.

| Pattern | Example | Description |
|:--------|:--------|:------------|
| **Standard** | `p-4` | A predefined value from your theme scale. |
| **Negative** | `-m-4` | Inverts a value (primarily for margins). |
| **Arbitrary** | `w-[350px]` | Uses exact values inside square brackets for one-off styles. |
| **Opacity** | `bg-blue-500/50` | Appends a percentage to a color to set alpha transparency. |
| **Modifiers** | `md:flex-row` | Conditionally applies styles based on screen size or state. |
