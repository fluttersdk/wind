---
applyTo: lib/src/parser/**
---
# Parser conventions (`lib/src/parser/`)

## Interface (every parser implements two methods)

```dart
class FooParser implements WindParserInterface {
  const FooParser();

  @override
  bool canParse(String className) =>
      className.startsWith('foo-') || className.startsWith('foo[');

  @override
  WindStyle parse(WindStyle styles, List<String>? classes, WindContext context) {
    if (classes == null) return styles;
    // ... iterate classes; return styles.copyWith(...)
    return styles;
  }
}
```

- `canParse(String className)` is O(1). Use `startsWith()` or a pre-compiled `static final RegExp`. No heavy logic.
- `parse` returns `styles.copyWith(...)` for every mutation. Never returns null. Never mutates the input list.
- The orchestrator's first-match-wins routing means `canParse` order matters: more specific prefixes register before more general ones. Registration is in `lib/src/parser/wind_parser.dart`'s `_parserMap` (a const map of const parser instances).
- `copyWith` does not fabricate an empty `BoxDecoration`. Pass `decoration:` only when setting a real visual box property (color, border, radius, shadow, gradient, image), so the downstream `decoration != null` Container gate stays honest.

## Last-class-wins semantics

Two safe patterns to implement "later token wins":

1. **Reverse iteration** with first-match-wins on each property: walk the class list backwards, set the property on the first match, break.
2. **Forward iteration with explicit reset**: like `border_parser.dart` — walk forward, on every match overwrite the property (and reset siblings to null where needed). Requires deliberate handling of partial directional properties.

Pick the pattern that fits the property family. Document the choice in a one-line comment at the iteration site when it might surprise a reader.

## Arbitrary values precede theme lookups

For every property, parse the bracket-arbitrary form (`p-[10px]`, `bg-[#ff5733]`, `text-[1.5rem]`) BEFORE the theme-scale lookup. Arbitrary values are pixel-exact; theme keys are nominal:

```dart
if (value.startsWith('[') && value.endsWith(']')) {
  return _parseArbitraryPixels(value.substring(1, value.length - 1));
}
return context.theme.getSpacing(value); // theme lookup
```

## Color opacity modifier (`/`)

Color-bearing parsers (background, text, border, ring, fill, stroke, shadow) strip the `/N` opacity suffix BEFORE matching the regex. The canonical helper:

```dart
final (cleanedClass, opacity) = parseColorOpacity(className); // utils/color_utils.dart
// then match cleanedClass against the color regex
// apply opacity via applyOpacity(color, opacity) on the resolved Color
```

This is parser-local; non-color parsers skip the opacity step.

## Cache key

`WindContext.cacheKey()` composes `className + activeBreakpoint + brightness + platform + sorted(activeStates)`. The cache lives in `WindParser._styleCache`.

Tests MUST call `WindParser.clearCache()` in `setUp()`. The cache persists between tests; skipping `clearCache` produces false-positive passes when neighbor tests prime the cache. See `.claude/rules/tests.md`.

## Short-circuits

The orchestrator stops parser iteration when `styles.isHidden == true`. This is the only built-in short-circuit; do not invent new ones inside individual parsers.

## What never goes in `lib/src/parser/`

- Widget construction — parsers return `WindStyle`, not `Widget`.
- Theme defaults — those live in `lib/src/theme/defaults/`.
- Runtime branching on platform identity beyond what `WindContext.platform` already exposes.
