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
- [Same-Granularity Override Contract](#same-granularity-override-contract)
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
| `defaultVariants` | `Map<String, String>` | `{}` | Default selection per axis. Overridden by the `variants:` argument at call site; a `null` value clears the default. |

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

```
base ++ variant-classes(definition order) ++ matched-compound(array order) ++ caller
```

The caller's `className` / `classNames` always arrive last, so they override earlier tokens via Wind's per-family last-wins rule.

A `null` value in `variants:` clears the default for that axis (no class emitted for it), matching `tv()`'s `undefined`-clears semantics.

<a name="same-granularity-override-contract"></a>
## Same-Granularity Override Contract

Because Wind's parser resolves conflicts per-family with last-class-wins at parse time, a variant must override a base token at the **same granularity**. Mixing a shorthand and a longhand of the same family silently keeps the shorthand:

```dart
// Correct: override px-* with px-*
WindRecipe(
  base: 'px-4',
  variants: {'size': {'sm': 'px-2'}},  // overrides px-4 correctly
)

// Incorrect: base px-* vs variant p-* (same family, different granularity)
WindRecipe(
  base: 'p-4',
  variants: {'size': {'sm': 'px-2'}},  // px-2 does NOT override p-4; p-4 wins silently
)
```

In debug builds, `WindRecipe` logs a warning the first time it detects a shorthand/longhand mix.

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
