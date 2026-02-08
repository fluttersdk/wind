# Widget Documentation Template

This template provides the exact structure for documenting Wind widgets (WDiv, WText, WButton, etc.). Use this as a foundation to ensure consistency across the library.

---

# {WidgetName}

{One-two sentence description of the widget and its primary use case.}

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/{widget_name}" size="md" source="example/lib/pages/widgets/{widget_name}.dart"></x-preview>

```dart
{WidgetName}(
  className: '{common-classes}',
  child: {child-widget},
)
```

## Basic Usage

The `{WidgetName}` widget {describe primary functionality}.

```dart
{WidgetName}(
  className: 'p-4 bg-gray-100',
  child: WText('Content'),
)
```

## Constructor

```dart
{WidgetName}({
  Key? key,
  String? className,
  {other-required-params},
  {other-optional-params},
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes |
| `{prop-1}` | `{Type}` | `{default}` | {description} |

## Layout Modes

### {Mode 1} (e.g., Block, Flex, Grid)

<x-preview path="widgets/{widget}_{mode}" size="md" source="example/lib/pages/widgets/{widget}_{mode}.dart"></x-preview>

```dart
{WidgetName}(
  className: '{mode-class} {supporting-classes}',
  children: [...],
)
```

## Event Handling

```dart
{WidgetName}(
  className: '{classes}',
  on{Event}: () {
    // Handle event
  },
)
```

## State Variants

Use state prefixes for interactive styling:

```dart
{WidgetName}(
  className: '{base} hover:{hover} focus:{focus} disabled:{disabled}',
)
```

## Styling Examples

### {Style Category 1}

```dart
// {Description of this style example}
{WidgetName}(
  className: '{style-classes}',
)
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `grid`, `block`, `hidden` |
| Spacing | `p-{n}`, `m-{n}`, `gap-{n}` |
| Sizing | `w-{size}`, `h-{size}` |
| Typography | `text-{size}`, `font-{weight}` |
| Colors | `bg-{color}`, `text-{color}` |
| Borders | `border`, `rounded`, `ring` |

## Customizing Theme

```dart
WindThemeData(
  {relevant-theme-property}: {value},
)
```

## Related Documentation

- [{Related Widget}](./w-{related}.md)
- [{Related Utility}](../{category}/{utility}.md)
