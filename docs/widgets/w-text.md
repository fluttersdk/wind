# WText Widget

`WText` is a utility-first wrapper around Flutter's `Text` (or `SelectableText`). It streamlines typography by accepting text utility classes directly.

## Usage

```dart
WText(
  "Hello World",
  className: "text-2xl font-bold text-gray-900 text-center",
)
```

## Selectable Text

To make text selectable, use `selectable: true`. It will build a `SelectableText` widget internally.

```dart
WText(
  "Copy me!",
  selectable: true,
  className: "text-blue-600",
)
```

## Inheritance

`WText` naturally inherits styles from parent `WDiv` (via `DefaultTextStyle`), but explicit classes on `WText` take precedence.

```dart
WDiv(
  className: "text-gray-500", // Parent style
  child: WText("I am gray"),
)

WDiv(
  className: "text-gray-500",
  child: WText("I am red", className: "text-red-500"), // Override
)
```
