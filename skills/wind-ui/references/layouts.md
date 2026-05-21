# Wind UI layout patterns

12 canonical layout recipes you will reach for repeatedly, plus the Flutter constraint rules that make them work. Pattern names are descriptive; copy-paste, then style.

## Flutter constraint reality (six rules CSS does not have)

Wind translates className into Flutter widget trees. Flutter's layout model is "constraints down, sizes up, parent sets position": every parent passes `BoxConstraints` to its children, every child reports its size up, and the parent alone decides where to place each child. This is fundamentally different from CSS box-flow.

| Rule | Symptom when violated | Fix |
|------|----------------------|-----|
| **Row children must use `flex-1`, not `w-full`** | `RenderFlex overflowed by N pixels` | `flex-1` participates in the second flex pass with a known ceiling; `w-full` tries to be 100% of an unbounded `Row` width |
| **Scrollable children must use `flex-1`, not `h-full`** | `Vertical viewport was given unbounded height` | The scrollable wants a ceiling; only `flex-1` (or explicit pixel height) gives one inside a Column |
| **`absolute` requires `relative` parent** | "Positioned widget must be a descendant of a Stack" | The `relative` token creates the Stack ancestry; without it, Positioned has nothing to position against |
| **`truncate` needs bounded width** | Text overflows past Row bounds | Wrap in `WDiv(className: 'flex-1', child: WText(..., className: 'truncate'))` |
| **Nested flex needs `min-w-0`** | Inner Column expands past `flex-1` ceiling | Add `min-w-0` to the inner flex container so it can shrink below its intrinsic content width |
| **Avoid `IntrinsicHeight` inside scrollables** | "BoxConstraints forces infinite height" OR O(N²) layout | Use `Expanded` + `SingleChildScrollView` in a Column instead; never put IntrinsicHeight in a list item builder |

The rest of this document gives you concrete recipes. Each one resolves these rules implicitly.

---

## Pattern 1: Full-page scrollable

The default for any page-level WDiv at the root of a route.

```dart
WDiv(
  className: 'w-full h-full overflow-y-auto p-4',
  scrollPrimary: true,                  // MANDATORY for iOS tap-to-top
  child: WDiv(
    className: 'flex flex-col gap-6 max-w-4xl mx-auto',
    children: [
      // ... page content
    ],
  ),
)
```

`scrollPrimary: true` is a constructor prop, not a className token. It maps to Flutter's `ScrollView.primary: true`, which lets iOS status-bar tap scroll the view to top. Without it, taps go to the nearest other primary scroll view (often nothing useful).

## Pattern 2: Centered card with max width

For login screens, modal content, single-column reading layouts.

```dart
WDiv(
  className: '''
    mx-auto max-w-md w-full
    p-6 rounded-xl
    bg-white dark:bg-gray-800
    border border-gray-200 dark:border-gray-700
    shadow-sm
  ''',
  children: [
    WText('Sign in', className: 'text-2xl font-bold text-gray-900 dark:text-white'),
    // ... form
  ],
)
```

`mx-auto` provides horizontal centering. `max-w-md` (448 px) caps the width on wide viewports.

## Pattern 3: Vertical stack with consistent gap

The 80% case for any list of widgets.

```dart
WDiv(
  className: 'flex flex-col gap-4',
  children: [item1, item2, item3],
)
```

`gap-4` = 16 px between every child. No manual spacing widgets needed.

## Pattern 4: Horizontal row with even alignment

```dart
WDiv(
  className: 'flex flex-row justify-between items-center gap-4',
  children: [
    WText('Title', className: 'text-lg font-bold text-gray-900 dark:text-white'),
    WButton(onTap: () {}, className: 'px-4 py-2 rounded-lg bg-blue-600 dark:bg-blue-700 text-white', child: const WText('Action')),
  ],
)
```

`justify-between` pushes children to opposite ends. `items-center` aligns them on the cross axis.

## Pattern 5: Responsive multi-column grid

```dart
WDiv(
  className: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4',
  children: [
    for (final item in items) Card(item: item),
  ],
)
```

1 column on mobile, 2 from `sm:` (≥ 640 px), 3 from `lg:` (≥ 1024 px), 4 from `xl:` (≥ 1280 px). Mobile-first cascade.

## Pattern 6: Sticky header + scrollable body

The most-used multi-zone shape: header fixed, body scrolls.

```dart
WDiv(
  className: 'flex flex-col h-full',
  children: [
    // Header — fixed
    WDiv(
      className: '''
        flex flex-row justify-between items-center
        px-4 py-3
        bg-white dark:bg-gray-900
        border-b border-gray-200 dark:border-gray-700
      ''',
      children: [
        WText('App title', className: 'text-lg font-bold text-gray-900 dark:text-white'),
        WIcon(Icons.menu_outlined),
      ],
    ),
    // Body — fills remaining space and scrolls
    WDiv(
      className: 'flex-1 overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: [...content],
      ),
    ),
  ],
)
```

`flex-1` on the body claims all remaining vertical space. `h-full` on the outer flex-col gives a bounded height. `scrollPrimary: true` on the scroll child wires iOS tap-to-top.

**Never** add `IntrinsicHeight` here; the Expanded + scrollable pattern is the correct shape.

## Pattern 7: Two-column responsive form

Stack on mobile, side-by-side on tablet+.

```dart
WDiv(
  className: 'flex flex-col md:flex-row gap-6',
  children: [
    WDiv(
      className: 'flex-1 flex flex-col gap-4',
      children: [/* left column */],
    ),
    WDiv(
      className: 'flex-1 flex flex-col gap-4',
      children: [/* right column */],
    ),
  ],
)
```

`flex flex-col md:flex-row` flips direction at the md breakpoint. Both columns get `flex-1` so they share width equally on desktop.

## Pattern 8: List of items with dividers

```dart
WDiv(
  className: '''
    flex flex-col
    bg-white dark:bg-gray-800
    rounded-lg overflow-hidden
    border border-gray-200 dark:border-gray-700
  ''',
  children: [
    for (final (index, item) in items.indexed)
      WDiv(
        className: '''
          flex flex-row items-center gap-3 p-4
          hover:bg-gray-50 dark:hover:bg-gray-700
          ${index < items.length - 1 ? 'border-b border-gray-200 dark:border-gray-700' : ''}
        ''',
        children: [/* item content */],
      ),
  ],
)
```

The last-item ternary is acceptable for index-based logic (it does not branch on state). Wind has no Tailwind-equivalent `divide-y`; the explicit bottom-border per item except the last is the correct shape.

## Pattern 9: Gradient header banner

For landing pages, splash screens, marketing headers.

```dart
WDiv(
  className: '''
    p-8 rounded-2xl
    bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500
  ''',
  children: [
    WText(
      'Welcome',
      className: 'text-3xl md:text-4xl font-bold text-white',
    ),
    WText(
      'A short tagline that fits within the banner.',
      className: 'text-base text-white/80 mt-2',
    ),
  ],
)
```

Gradients always work in light mode without `dark:` pair (the gradient color tokens are absolute). Text uses opacity modifier (`/80`) for de-emphasis.

## Pattern 10: Modal/sheet with fixed header + actions, scrollable middle

```dart
WDiv(
  className: '''
    flex flex-col
    bg-white dark:bg-gray-800
    rounded-t-2xl
    h-3/4
  ''',
  children: [
    // Fixed header
    WDiv(
      className: 'px-6 py-4 border-b border-gray-200 dark:border-gray-700',
      children: [WText('Edit profile', className: 'text-lg font-bold')],
    ),
    // Scrollable body
    WDiv(
      className: 'flex-1 overflow-y-auto p-6',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: [/* form fields */],
      ),
    ),
    // Pinned actions
    WDiv(
      className: '''
        flex flex-row justify-end gap-2
        px-6 py-4 border-t border-gray-200 dark:border-gray-700
      ''',
      children: [
        WButton(onTap: () => Navigator.pop(context), className: 'px-4 py-2 rounded-lg', child: const WText('Cancel')),
        WButton(onTap: _save, className: 'px-4 py-2 rounded-lg bg-blue-600 dark:bg-blue-700 text-white', child: const WText('Save')),
      ],
    ),
  ],
)
```

Three-zone Column. Top + bottom are fixed; middle has `flex-1 overflow-y-auto`.

## Pattern 11: Empty state with centered content

```dart
WDiv(
  className: 'flex flex-col items-center justify-center gap-4 h-full p-8',
  children: [
    WIcon(Icons.inbox_outlined, className: 'text-6xl text-gray-400 dark:text-gray-600'),
    WText(
      'Your inbox is empty',
      className: 'text-lg font-medium text-gray-700 dark:text-gray-300',
    ),
    WText(
      'New messages will appear here.',
      className: 'text-sm text-gray-500 dark:text-gray-400 text-center',
    ),
    WButton(
      onTap: _compose,
      className: 'mt-2 px-4 py-2 rounded-lg bg-blue-600 dark:bg-blue-700 text-white',
      child: const WText('Compose'),
    ),
  ],
)
```

Centering on both axes via `items-center justify-center` in a flex-col with bounded height.

## Pattern 12: Loading state with overlay

```dart
WDiv(
  className: 'relative',
  children: [
    // Content (dimmed when loading)
    WDiv(
      className: '${_isLoading ? "opacity-50" : ""} flex flex-col gap-4',
      children: [/* content */],
    ),
    // Overlay spinner
    if (_isLoading)
      WDiv(
        className: 'absolute inset-0 flex items-center justify-center',
        child: const CircularProgressIndicator(),
      ),
  ],
)
```

The Dart conditional in className interpolation here is acceptable: it adds a single class (`opacity-50`) when loading, no `dark:` pair needed. For richer state-driven styling, prefer `states: {'loading'}` + `loading:opacity-50` instead.

---

## Special-case patterns

### Pinning content to the bottom of a scrollable

`Spacer` and `Expanded` do not work inside `SingleChildScrollView` (they need bounded height). Wrap in `LayoutBuilder`:

```dart
LayoutBuilder(
  builder: (context, constraints) => SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: WDiv(
        className: 'flex flex-col gap-4 p-4',
        children: [
          /* top content */,
          const Spacer(),
          WText('Pinned to bottom', className: 'text-center text-gray-500'),
        ],
      ),
    ),
  ),
)
```

### Equal-height children in a Row

Use `items-stretch` to make all children match the tallest sibling on the cross axis. Inside a scrollable parent, this throws "BoxConstraints forces infinite height"; wrap in `IntrinsicHeight` if you must:

```dart
IntrinsicHeight(
  child: WDiv(
    className: 'flex flex-row items-stretch gap-4',
    children: [/* cards */],
  ),
)
```

`IntrinsicHeight` runs an extra layout pass; avoid in lists.

### Nested scrollables on the same axis

Two `ListView`s on the same axis nest poorly. Use a single `CustomScrollView` with `SliverList` delegates instead. For tabs-inside-collapsing-header, use `NestedScrollView`.

---

## Anti-patterns

| Wrong | Right |
|-------|-------|
| `flex-row` with `w-full` children | use `flex-1` |
| `overflow-y-auto h-full` inside Column | use `flex-1 overflow-y-auto` in a parent with `h-full` |
| `absolute` without `relative` parent | add `relative` to the parent's className |
| `truncate` inside Row without `flex-1` wrap | wrap text in `WDiv(className: 'flex-1', child: WText(..., className: 'truncate'))` |
| `IntrinsicHeight` inside a ListView item builder | restructure: equal-height belongs at the outer level, not per-item |
| `ListView` inside `SingleChildScrollView` with `shrinkWrap: true` | use a single `CustomScrollView` with slivers |
| `Spacer` / `Expanded` inside `SingleChildScrollView` | use `LayoutBuilder` + `ConstrainedBox(minHeight: constraints.maxHeight)` |
| Forgetting `scrollPrimary: true` on the page root | always set it on the outer scrollable WDiv |
| Hard-coded `width: 400` that exceeds typical iframe width | use `max-w-*` instead |
