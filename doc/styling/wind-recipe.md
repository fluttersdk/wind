# WindRecipe

A `tv()` (tailwind-variants) equivalent for Wind. Composes a className from a `base`, a set of `variants` (one axis per key, each mapping a value to a className), optional `compoundVariants` (multi-condition rules), and `defaultVariants` (the selection applied when an axis is not passed by the caller).

`WindSlotRecipe` extends the same model to multi-part components: instead of a single string, each call returns a `Map<String, String>` of slot-name to className.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Props: WindRecipe](#props-windrecipe)
- [Props: WindSlotRecipe](#props-windslotrecipe)
- [Constructor: WindRecipe](#constructor-windrecipe)
- [Constructor: WindSlotRecipe](#constructor-windslotrecipe)
- [Resolution Order](#resolution-order)
- [Override Contract](#override-contract)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="styling/wind_recipe_basic" size="md" source="example/lib/pages/styling/wind_recipe_basic.dart"></x-preview>

```dart
final button = WindRecipe(
  base: 'inline-flex items-center rounded-lg font-medium',
  variants: {
    'intent': {
      'primary': 'bg-blue-600 dark:bg-blue-500 text-white',
      'ghost':   'bg-transparent text-blue-600 dark:text-blue-400',
    },
    'size': {
      'sm': 'px-3 py-1.5 text-sm',
      'md': 'px-4 py-2 text-base',
    },
  },
  defaultVariants: {'intent': 'primary', 'size': 'md'},
);

// Full defaults: "inline-flex items-center rounded-lg font-medium bg-blue-600 dark:bg-blue-500 text-white px-4 py-2 text-base"
button()

// Override intent, keep size default:
button(variants: {'intent': 'ghost'})

// Append extra classes:
button(className: 'w-full')
```

<a name="props-windrecipe"></a>
## Props: WindRecipe

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `base` | `String` | `''` | Always-applied className. |
| `variants` | `Map<String, Map<String, String>>` | `{}` | Variant axes: axis -> (value -> className). Iteration order fixes emission order. |
| `compoundVariants` | `List<WindCompoundVariant>` | `[]` | Multi-condition rules applied in list order after variant classes. |
| `defaultVariants` | `Map<String, String>` | `{}` | Default selection per axis. Overridden by the `variants:` argument at call site; a `null` there clears the default, while `defaultVariants` itself holds strings only. |

**Call signature** (`WindRecipe` is callable):

| Param | Type | Default | Description |
|:------|:-----|:--------|:------------|
| `variants` | `Map<String, String?>?` | `null` | Caller's axis selections. `null` for an axis clears its default (no class emitted). Unknown axis throws `ArgumentError`. |
| `className` | `String?` | `null` | Extra caller className appended last. |

<a name="props-windslotrecipe"></a>
## Props: WindSlotRecipe

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `slots` | `Map<String, String>` | `{}` | Base className per slot. Slot identity comes from these keys. |
| `variants` | `Map<String, Map<String, Map<String, String>>>` | `{}` | Variant axes: axis -> (value -> (slot -> className)). |
| `compoundVariants` | `List<WindSlotCompoundVariant>` | `[]` | Multi-condition rules applied per slot in list order. |
| `defaultVariants` | `Map<String, String>` | `{}` | Default selection per axis. |

**Call signature** (`WindSlotRecipe` is callable):

| Param | Type | Default | Description |
|:------|:-----|:--------|:------------|
| `variants` | `Map<String, String?>?` | `null` | Caller's axis selections. Unknown axis throws `ArgumentError`. |
| `classNames` | `Map<String, String>?` | `null` | Extra caller className per slot, appended last for that slot. |

<a name="constructor-windrecipe"></a>
## Constructor: WindRecipe

```dart
WindRecipe({
  String base = '',
  Map<String, Map<String, String>> variants = const {},
  List<WindCompoundVariant> compoundVariants = const [],
  Map<String, String> defaultVariants = const {},
})
```

`WindCompoundVariant` constructor:

```dart
WindCompoundVariant({
  required Map<String, Object> conditions,
  required String className,
})
```

A condition value is a `String` (exact match) or `List<String>` (OR match).

<a name="constructor-windslotrecipe"></a>
## Constructor: WindSlotRecipe

```dart
WindSlotRecipe({
  Map<String, String> slots = const {},
  Map<String, Map<String, Map<String, String>>> variants = const {},
  List<WindSlotCompoundVariant> compoundVariants = const [],
  Map<String, String> defaultVariants = const {},
})
```

`WindSlotCompoundVariant` constructor:

```dart
WindSlotCompoundVariant({
  required Map<String, Object> conditions,
  required Map<String, String> classNames,
})
```

<a name="resolution-order"></a>
## Resolution Order

Every call resolves in this strict order: no dedupe, no sort, no twMerge:

```text
base ++ variant-classes(definition order) ++ matched-compound(array order) ++ caller
```

The caller's `className` / `classNames` always arrive last, so they override earlier tokens via Wind's per-family last-wins rule.

A `null` value in `variants:` clears the default for that axis (no class emitted for it), matching `tv()`'s `undefined`-clears semantics.

### The Caller-Append Contract (No twMerge)

`WindRecipe` and `WindSlotRecipe` only APPEND the caller's `className` / `classNames`; they never dedupe, sort, or resolve a conflict themselves. A caller passing a className that conflicts with the base (e.g. `WindRecipe(base: 'w-1/2')(className: 'w-full')`) gets both tokens in the emitted string, in that order: `'w-1/2 w-full'`.

The conflict is resolved one layer down, when the string reaches `WindParser`: `WindParser.findAndGroupClasses` groups same-family classes together WITHOUT deduping, and each parser (e.g. `SizingParser.parse`) resolves them with last-class-wins. So the appended `w-full` wins over the base `w-1/2` at parse time, not at recipe-call time. There is intentionally no Dart port of `tailwind-merge`: wind's parse-time per-family last-wins already achieves the same outcome for every token family the parsers understand, which is why `WindRecipe` deliberately only appends (see the no-twMerge rationale in the `WindRecipe` doc comment in `lib/src/recipe/wind_recipe.dart`).

This is verified by `test/recipe/wind_recipe_test.dart` (proves the append, order preserved) and `test/parser/parsers/sizing_parser_test.dart` (proves the appended `w-full` resolves to the winning style).

Note: the className-REPLACE anti-pattern (a component treating an incoming `className` as a full recipe bypass instead of appending it) is a consumer-component bug, not a wind defect; wind's own recipes always append. When it appears, it lives in a downstream consumer's component layer, outside this package.

<a name="override-contract"></a>
## Override Contract

A recipe emits the base first and the variants after it, and the parser resolves conflicts per family with last-class-wins, so a variant overrides the base. How far the override reaches depends on the family:

| Family | A longhand after a shorthand | Result |
|:-------|:-----------------------------|:-------|
| Padding, margin, inset | `p-4` then `px-2` | Composes per side: 8 on the left and right, 16 on the top and bottom. |
| Border radius | `rounded-lg` then `rounded-t-none` | Does not compose: every corner becomes square. |
| Border width | `border-2` then `border-t-4` | Does not compose: only the top border is kept. |

```dart
// Padding composes: the variant changes only the horizontal sides.
WindRecipe(
  base: 'p-4',
  variants: {'size': {'sm': 'px-2'}},
)

// Radius and border width do not: the variant restates every corner and side.
WindRecipe(
  base: 'rounded-lg border-2',
  variants: {'shape': {'pill': 'rounded-full border-4', 'flat': 'rounded-none border-0'}},
)
```

In debug builds, `WindRecipe` logs a warning the first time it sees a shorthand and a longhand of one family in the same recipe; for padding, margin and inset the result still composes per side, as in the table.

<a name="styling-examples"></a>
## Styling Examples

### Button with Compound Variants

Compound variants contribute a className only when every condition is satisfied:

```dart
final button = WindRecipe(
  base: 'inline-flex items-center rounded-lg font-medium',
  variants: {
    'intent': {
      'primary': 'bg-blue-600 dark:bg-blue-500 text-white',
      'destructive': 'bg-red-600 dark:bg-red-500 text-white',
    },
    'size': {'sm': 'px-3 py-1.5 text-sm', 'lg': 'px-6 py-3 text-lg'},
  },
  compoundVariants: [
    WindCompoundVariant(
      // Activates when intent is 'primary' OR 'destructive', AND size is 'lg'.
      conditions: {'intent': ['primary', 'destructive'], 'size': 'lg'},
      className: 'shadow-lg',
    ),
  ],
  defaultVariants: {'intent': 'primary', 'size': 'sm'},
);
```

### Multi-Slot Card Recipe

```dart
final card = WindSlotRecipe(
  slots: {
    'root':   'rounded-xl border overflow-hidden',
    'header': 'px-5 py-4 border-b',
    'body':   'px-5 py-4',
  },
  variants: {
    'tone': {
      'default': {
        'root':   'bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700',
        'header': 'border-gray-200 dark:border-gray-700',
        'body':   '',
      },
      'highlighted': {
        'root':   'bg-blue-50 dark:bg-blue-950 border-blue-200 dark:border-blue-800',
        'header': 'border-blue-200 dark:border-blue-800',
        'body':   '',
      },
    },
  },
  defaultVariants: {'tone': 'default'},
);

final classes = card(variants: {'tone': 'highlighted'});
WCard(
  className: classes['root'],
  header: WDiv(className: classes['header'], child: WText('Summary')),
  child:  WDiv(className: classes['body'],   child: WText('Body')),
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WBadge](../widgets/w-badge.md): a natural fit for a `WindRecipe` badge tone axis.
- [WCard](../widgets/w-card.md): pairs with `WindSlotRecipe` for multi-slot card variants.
- [WButton](../widgets/w-button.md): commonly driven by a `WindRecipe` for intent + size axes.
