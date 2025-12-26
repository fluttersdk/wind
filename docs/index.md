# Introduction

Welcome to **Wind**, a utility-first UI framework for Flutter that brings the developer experience of Tailwind CSS to Dart.

We believe that building beautiful UIs shouldn't require fighting with nested widget trees or managing complex style objects. Wind allows you to style your application using concise utility classes, while staying 100% within the Flutter ecosystem.

## Our Philosophy

Wind is built on two core philosophies that shape every decision we make:

### 1. The "Laravel Artisan" Experience
We prioritize Developer Experience (DX) above all else. Just as Laravel provides elegant tools for PHP developers, Wind provides a configuration-driven, expressive API for Flutter.
- **Widgets are robust:** They handle edge cases so you don't have to.
- **Configuration is central:** Everything is customizable via `WindThemeData`.

### 2. The "Tailwind Engine"
We love utility classes because they allow you to design directly in your markup (or in this case, your widget tree).
- **Rapid Prototyping:** Build complex layouts in seconds.
- **Consistency:** Use a predefined design system (colors, spacing, typography) to ensure visual consistency.

## Why Wind?

If you've ever felt "Widget Hell" (recursive nesting of `Padding`, `Container`, `Align`, `Center`, `DecoratedBox`...), Wind is for you.

**Before Wind:**
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [BoxShadow(blurRadius: 4)],
  ),
  child: Center(
    child: Text(
      "Hello",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)
```

**After Wind:**
```dart
WDiv(
  className: "p-4 bg-blue-500 rounded-lg shadow centered",
  child: WText("Hello", className: "text-white font-bold"),
)
```

## Getting Started

Ready to dive in? Check out the [Installation Guide](getting-started/installation.md) to add Wind to your project, or explore the [Core Concepts](core-concepts/utility-first.md) to understand how it works under the hood.
