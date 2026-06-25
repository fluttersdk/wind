# WBadge

Inline status or label pill. Composes a pill-shaped `WDiv` (rounded-full, inline-flex) around a `WText` (text-xs). All visual styling is className-driven: the caller supplies tone via `bg-*` and `text-*` tokens (with `dark:` pairs); no colors are baked in.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Props](#props)
- [Constructor](#constructor)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="widgets/w_badge_basic" size="md" source="example/lib/pages/widgets/w_badge_basic.dart"></x-preview>

```dart
WBadge(
  'Active',
  className: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-100',
)
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `label` | `String` | **Required** | The text displayed inside the badge. |
| `className` | `String?` | `null` | Caller-supplied utility classes appended after the default layout classes (`inline-flex items-center rounded-full px-2 py-0.5`). Use this to supply `bg-*`, `text-*`, and their `dark:` pairs. |

<a name="constructor"></a>
## Constructor

```dart
WBadge(
  String label, {
  Key? key,
  String? className,
})
```

`label` is a required positional parameter.

<a name="styling-examples"></a>
## Styling Examples

### Status Tones

Supply tone through `bg-*` + `text-*` + their `dark:` pairs. The default layout provides no background or text color:

```dart
// Success
WBadge('Paid', className: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-100')

// Warning
WBadge('Pending', className: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-100')

// Danger
WBadge('Error', className: 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-100')

// Neutral
WBadge('Draft', className: 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300')
```

### Inline Beside Text

`WBadge` is `inline-flex` by default, so it sits naturally beside other inline widgets in a `flex-row` container:

```dart
WDiv(
  className: 'flex flex-row items-center gap-2',
  children: [
    WText('Invoice #1042', className: 'text-base font-medium text-gray-900 dark:text-white'),
    WBadge('Paid', className: 'bg-green-100 text-green-700 dark:bg-green-900 dark:text-green-200'),
  ],
)
```

### With a WindRecipe

Use `WindRecipe` to drive tone from a variant axis instead of repeating className strings:

```dart
final badge = WindRecipe(
  base: 'inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium',
  variants: {
    'tone': {
      'success': 'bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-200',
      'warning': 'bg-yellow-100 dark:bg-yellow-900 text-yellow-800 dark:text-yellow-200',
    },
  },
  defaultVariants: {'tone': 'success'},
);

WBadge('Deployed', className: badge(variants: {'tone': 'success'}))
WBadge('Pending',  className: badge(variants: {'tone': 'warning'}))
```

<a name="related-documentation"></a>
## Related Documentation

- [WDiv](./w-div.md) — the pill container `WBadge` delegates to internally.
- [WText](./w-text.md) — the label renderer inside the badge.
- [WindRecipe](../styling/wind-recipe.md) — compose badge tone variants without repeating className strings.
