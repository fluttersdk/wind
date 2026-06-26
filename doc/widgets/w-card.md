# WCard

Surface container with optional `header` and `footer` slots. Composes a `WDiv` (flex-col) with up to three slots: an optional header above the body, the required `child` body, and an optional footer below. All styling is className-driven; no colors or spacing are baked in.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Props](#props)
- [Constructor](#constructor)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="widgets/w_card_basic" size="md" source="example/lib/pages/widgets/w_card_basic.dart"></x-preview>

```dart
WCard(
  className: 'rounded-xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 p-5',
  child: WText('Body content'),
)
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `child` | `Widget` | **Required** | The main body content of the card. |
| `header` | `Widget?` | `null` | Optional widget rendered above the body. Typical use: a title row, a card image, or a section label. |
| `footer` | `Widget?` | `null` | Optional widget rendered below the body. Typical use: action buttons or status/metadata rows. |
| `className` | `String?` | `null` | Utility classes for the outer container. When omitted, defaults to `'w-full flex flex-col'` (no colors, no spacing). |

<a name="constructor"></a>
## Constructor

```dart
WCard({
  Key? key,
  required Widget child,
  Widget? header,
  Widget? footer,
  String? className,
})
```

<a name="styling-examples"></a>
## Styling Examples

### Basic Card with Border and Shadow

```dart
WCard(
  className: '''
    rounded-xl
    bg-white dark:bg-gray-800
    border border-gray-200 dark:border-gray-700
    shadow-md
    p-5
  ''',
  child: WText('Settings content here'),
)
```

### Card with Header Slot

Add a visual header section separated by a border:

```dart
WCard(
  className: 'rounded-xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 overflow-hidden',
  header: WDiv(
    className: 'px-5 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900',
    child: WText('Recent Activity', className: 'text-sm font-semibold text-gray-700 dark:text-gray-300'),
  ),
  child: WDiv(
    className: 'px-5 py-4',
    child: WText('Activity list here'),
  ),
)
```

### Card with Header and Footer

Three-slot card with an action footer:

```dart
WCard(
  className: 'rounded-xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 overflow-hidden',
  header: WDiv(
    className: 'px-5 py-4 border-b border-gray-200 dark:border-gray-700',
    child: WText('Team Plan', className: 'text-base font-semibold text-gray-900 dark:text-white'),
  ),
  child: WDiv(
    className: 'px-5 py-4 flex flex-col gap-1',
    children: [
      WText('\$49 / month', className: 'text-2xl font-bold text-gray-900 dark:text-white'),
      WText('Up to 25 members, 100 GB storage.', className: 'text-sm text-gray-500 dark:text-gray-400'),
    ],
  ),
  footer: WDiv(
    className: 'px-5 py-4 border-t border-gray-200 dark:border-gray-700 flex flex-row justify-end',
    child: WButton(
      onTap: save,
      className: 'px-4 py-2 rounded-lg bg-blue-600 dark:bg-blue-500 hover:bg-blue-700 dark:hover:bg-blue-600',
      child: WText('Save', className: 'text-white text-sm font-medium'),
    ),
  ),
)
```

### Driven by a WindSlotRecipe

Use `WindSlotRecipe` to keep card tone variations in one place:

```dart
final card = WindSlotRecipe(
  slots: {'root': 'rounded-xl border overflow-hidden', 'header': 'px-5 py-4 border-b', 'body': 'px-5 py-4'},
  variants: {
    'tone': {
      'default':     {'root': 'bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700', 'header': 'border-gray-200 dark:border-gray-700', 'body': ''},
      'highlighted': {'root': 'bg-blue-50 dark:bg-blue-950 border-blue-200 dark:border-blue-800', 'header': 'border-blue-200 dark:border-blue-800', 'body': ''},
    },
  },
  defaultVariants: {'tone': 'default'},
);

final classes = card(variants: {'tone': 'highlighted'});
WCard(
  className: classes['root'],
  header: WDiv(className: classes['header'], child: WText('Summary')),
  child: WDiv(className: classes['body'], child: WText('Body')),
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WDiv](./w-div.md): the container `WCard` delegates all rendering to.
- [WindRecipe](../styling/wind-recipe.md): drive card tone from variant axes without repeating className strings.
- [WButton](./w-button.md): commonly used in the `footer` slot.
