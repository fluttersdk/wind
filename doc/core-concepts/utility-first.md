# Utility-First Fundamentals

- [Introduction](#introduction)
- [The Shift in Thinking](#shift)
- [Why "Utility-First"?](#why)
- [How it Works](#how-it-works)
- [Quick Reference](#quick-reference)
- [Syntax Guide](#syntax-guide)

<a name="introduction"></a>
## Introduction

Today, I'll show you how Wind brings the power of utility-first styling to Flutter. If you've ever felt that styling in Flutter is a bit too verbose or that your widget trees are getting too deep just for a bit of padding and a background color, you're in the right place.

Wind is inspired by Tailwind CSS, and its philosophy is simple: style your UI right where you build it using composable class strings.

<!-- TODO: [EXAMPLE_NEEDED] path="core-concepts/utility_first_hero" action="CREATE" -->
<!-- Description: A beautiful card showing a profile or product using various Wind utilities to demonstrate the utility-first approach. -->
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

<a name="shift"></a>
## The Shift in Thinking

Traditionally, styling in Flutter involves wrapping widgets inside other widgets. To create a simple card, you might find yourself nesting `Container`, `Padding`, `DecoratedBox`, and `Center` just to get the look you want.

Let's look at the comparison:

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

See the difference? We've flattened the widget tree and made the styling declarative and readable.

<a name="why"></a>
## Why "Utility-First"?

I often get asked why we should use strings instead of native Flutter properties. Here are the main reasons why I chose this path for Wind:

- **Speed & Velocity**: You don't need to jump between your UI and your style definitions. You stay in the flow.
- **Consistency**: Instead of using random magic numbers for spacing (is it 12? 14? 16?), you use a scale like `p-4`. This keeps your design system tight.
- **Maintainability**: When you look at a `WDiv`, you immediately see what it looks like. You don't have to hunt for where the `BoxDecoration` is defined.
- **Responsive by Default**: Handling screen sizes with `md:` and `lg:` prefixes is significantly easier than manual `MediaQuery` checks.

<a name="how-it-works"></a>
## How it Works

Under the hood, Wind uses a high-performance parsing pipeline. It's not magic—it's a structured translation from strings to Flutter styles.

Let's look at the pipeline:

1. **Context Initialization**: `WindContext` gathers your theme, current screen size, and brightness (dark mode).
2. **Parsing**: The `WindParser` splits your `className` string and passes tokens to specialized parsers (Color, Spacing, Border, etc.).
3. **Style Composition**: These parsers return a `WindStyle` object, which is a typed representation of all your styles.
4. **Widget Application**: The `W-prefixed` widgets (like `WDiv`) use this `WindStyle` to apply `Padding`, `DecoratedBox`, `Flex`, and other native Flutter widgets to the tree.

> [!NOTE]
> Wind uses an LRU cache for parsed styles. This means once a `className` is parsed, subsequent uses are nearly instantaneous!

<a name="quick-reference"></a>
## Quick Reference

Here are some of the most common utilities you'll use every day:

| Category | Classes | Description |
|:---------|:--------|:------------|
| **Layout** | `flex`, `grid`, `block`, `hidden` | Controls how children are positioned. |
| **Spacing** | `p-4`, `m-2`, `gap-4`, `px-6` | Controls padding, margin, and gaps. |
| **Sizing** | `w-full`, `h-64`, `max-w-md` | Controls width and height. |
| **Colors** | `bg-blue-500`, `text-white` | Applies theme colors to backgrounds and text. |
| **Borders** | `border`, `rounded-lg`, `ring-2` | Controls borders, corner radius, and rings. |

<a name="syntax-guide"></a>
## Syntax Guide

Wind follows the Tailwind CSS syntax almost exactly. Here’s a quick breakdown of how to write your classes:

| Prefix | Example | Description |
|:-------|:--------|:------------|
| **Standard** | `p-4` | Property and value from the theme scale. |
| **Negative** | `-m-4` | Used for negative margins. |
| **Arbitrary** | `w-[350px]` | Define exact values using square brackets. |
| **Opacity** | `bg-red-500/50` | Add a slash to any color to set its opacity. |
| **Modifiers** | `hover:`, `dark:`, `md:` | Apply styles conditionally based on state or screen size. |

That's all. Once you start using utility classes, you'll find it hard to go back to the traditional way of styling. Have a nice day!
