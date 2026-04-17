# Responsive Decision Tree

When a layout needs to behave differently at different breakpoints, pick the **lowest-friction** tool that solves the problem. Jumping to `WBreakpoint` too early creates noisy, imperative code where a one-token prefix would do.

## Step 1: Is it purely stylistic?

If the widget tree is identical and only styles change, use **className prefixes**. No widget swap needed.

```dart
// Column on mobile, row on md+
WDiv(className: 'flex flex-col md:flex-row gap-2 md:gap-4')

// Tighter padding on small screens
WDiv(className: 'p-2 md:p-6')

// Different colors per breakpoint
WDiv(className: 'bg-gray-100 md:bg-white')
```

## Step 2: Does something need to appear or disappear?

Use **`hidden` + visibility prefixes** to swap which elements render. Same tree shape, just gated visibility.

```dart
// Mobile hamburger vs desktop nav bar
WDiv(
  className: 'flex',
  children: [
    WDiv(className: 'block md:hidden', child: const HamburgerButton()),
    WDiv(className: 'hidden md:flex gap-4', children: [/* nav links */]),
  ],
)
```

## Step 3: Do children need to reorder?

Use **`order-*` utilities** on flex children — no widget swap, no duplicate subtrees.

```dart
// Sidebar above content on mobile, beside it on md+
WDiv(
  className: 'flex flex-col md:flex-row gap-4',
  children: [
    WDiv(className: 'order-2 md:order-1', child: const Sidebar()),
    WDiv(className: 'order-1 md:order-2 flex-1', child: const Main()),
  ],
)
```

Combine with `flex-row-reverse` / `flex-col-reverse` for whole-container flips.

## Step 4: Only now — `WBreakpoint`

Reach for `WBreakpoint` when the **widget tree structure** genuinely differs:
- Different widget **types** per breakpoint (not just different classNames)
- Different **child counts** per breakpoint
- A completely different layout component per breakpoint

```dart
// Mobile: horizontally scrollable tabs. Desktop: distributed tab row.
WBreakpoint(
  base: (ctx) => const MobileScrollableTabs(),
  md: (ctx) => const DesktopDistributedTabs(),
)

// Mobile: summary card. Desktop: 3-column stat grid.
WBreakpoint(
  base: (ctx) => const SummaryCard(),
  md: (ctx) => const StatGrid(),
)
```

## Red flags that you reached too early

If your `WBreakpoint` branches look like this, go back to Step 1:

```dart
// ❌ Anti-pattern: only className differs
WBreakpoint(
  base: (_) => WDiv(className: 'flex flex-col gap-2', children: items),
  md:   (_) => WDiv(className: 'flex gap-4', children: items),
)

// ✅ Replace with:
WDiv(className: 'flex flex-col md:flex-row gap-2 md:gap-4', children: items)
```

```dart
// ❌ Anti-pattern: only one child is hidden
WBreakpoint(
  base: (_) => const Menu(),
  md:   (_) => Row(children: [const Menu(), const Banner()]),
)

// ✅ Replace with:
WDiv(
  className: 'flex',
  children: [
    const Menu(),
    WDiv(className: 'hidden md:block', child: const Banner()),
  ],
)
```

## Summary

| Situation | Tool |
|:----------|:-----|
| Style values differ | className prefix (`md:`, `lg:`) |
| Elements appear/disappear | `hidden` + visibility prefixes |
| Children reorder | `order-*`, `flex-*-reverse` |
| Widget **tree** differs | `WBreakpoint` |

Every step up costs more tokens and more cognitive load. Stop at the first one that solves the problem.
