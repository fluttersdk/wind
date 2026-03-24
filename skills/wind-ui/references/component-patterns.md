# Wind UI v1 - Production Component Patterns

Quick reference for common UI components built with Wind UI classNames. These patterns are extracted from real production applications and follow mobile-first touch target and spacing rules.

## Quick Reference

| Component | Key className pattern |
|-----------|----------------------|
| Card (flat) | `bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700` |
| Card (elevated) | `bg-white dark:bg-gray-800 rounded-2xl shadow-md` |
| Primary button | `bg-primary hover:bg-green-600 text-white py-3 px-4 rounded-lg font-medium text-sm` |
| Secondary button | `border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 text-gray-700 dark:text-gray-300 py-3 px-4 rounded-lg font-medium text-sm` |
| Ghost/icon button | `p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400` |
| Danger button | `bg-red-500 hover:bg-red-600 text-white py-3 px-4 rounded-lg font-medium text-sm` |
| Status badge | `inline-flex items-center gap-1 px-2 py-1 rounded-full bg-green-100 dark:bg-green-900/30 text-xs font-medium text-green-700 dark:text-green-400` |
| List item (row) | `flex flex-row items-center gap-3 px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-800/50` |
| Inline Alert | `flex flex-row items-start gap-3 p-4 rounded-xl bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800` |
| Skeleton line | `h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse` |
| Badge overlay | `relative` parent + `absolute top-0 right-0` child |
| Pulsing status dot | `w-2 h-2 rounded-full bg-green-500 animate-pulse` |

---

## Detailed Patterns

### 1. Card — Flat
Standard container for grouping content visually without elevation.
```dart
WDiv(
  className: 'bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden',
  children: [
    // Optional card header
    WDiv(
      className: 'px-4 lg:px-6 py-4 border-b border-gray-100 dark:border-gray-700 flex flex-row items-center justify-between',
      children: [
        WText('Section Title', className: 'text-xs font-bold uppercase tracking-wide text-gray-500 dark:text-gray-400'),
        // Header actions go here
      ]
    ),
    // Card body
    WDiv(
      className: 'p-4 lg:p-6',
      children: [ /* content */ ],
    ),
  ],
)
```

### 2. Card — Elevated (with shadow)
Used when a card needs to visually float above other content.
```dart
WDiv(
  className: 'bg-white dark:bg-gray-800 rounded-2xl shadow-md p-5',
  child: /* content */,
)
```

### 3. Card — Interactive (tappable)
A card that acts as a large touch target, usually for navigation.
```dart
WButton(
  onTap: () => /* navigate */,
  className: 'w-full bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 hover:border-primary/50 hover:shadow-md transition duration-200 text-left',
  child: WDiv(className: 'p-4', child: /* content */),
)
```

### 4. Stat/Metric Card
Used in dashboards to show key performance indicators.
```dart
WDiv(
  className: 'bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-5 flex flex-col gap-2',
  children: [
    WText('24', className: 'text-4xl font-bold text-gray-900 dark:text-white'),
    WText('Total Monitors', className: 'text-sm text-gray-500 dark:text-gray-400'),
    // Optional trend indicator
    WDiv(
      className: 'flex flex-row items-center gap-1',
      children: [
        WIcon(Icons.trending_up_outlined, className: 'text-green-500 text-sm'),
        WText('+3 this week', className: 'text-xs text-green-600 dark:text-green-400'),
      ],
    ),
  ],
)
```

### 5. Primary Button
The main call to action on a page or form. Minimum 44px height for touch targets via `py-3`.
```dart
WButton(
  onTap: () {},
  isLoading: _isLoading,
  className: 'bg-primary hover:bg-green-600 disabled:bg-primary/50 loading:bg-primary/75 text-white py-3 px-4 rounded-lg font-medium text-sm',
  child: WDiv(
    className: 'flex flex-row items-center justify-center gap-2',
    children: [
      WIcon(Icons.add_outlined, className: 'text-white text-base'),
      WText('Create Monitor'),
    ],
  ),
)
```

### 6. Secondary/Ghost Button
Alternative actions. Has border but no background fill by default.
```dart
WButton(
  onTap: () {},
  className: 'border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 text-gray-700 dark:text-gray-300 py-3 px-4 rounded-lg font-medium text-sm',
  child: WText('Cancel'),
)
```

### 7. Icon Button (Ghost)
Used for actions that don't need text labels (like close, more options, etc). Needs padding for touch target size.
```dart
WButton(
  onTap: () {},
  className: 'p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400 transition-colors',
  child: WIcon(Icons.more_vert_outlined),
)
```

### 8. Danger/Destructive Button
Used for actions that delete or permanently alter data.
```dart
WButton(
  onTap: () {},
  className: 'bg-red-500 hover:bg-red-600 text-white py-3 px-4 rounded-lg font-medium text-sm',
  child: WText('Delete'),
)
```

### 9. Status Badge
Small visual indicator for state (active, pending, error).
```dart
// Active (Green)
WDiv(
  className: 'inline-flex items-center gap-1 px-2 py-1 rounded-full bg-green-100 dark:bg-green-900/30',
  children: [
    WDiv(className: 'w-1.5 h-1.5 rounded-full bg-green-500'),
    WText('Active', className: 'text-xs font-medium text-green-700 dark:text-green-400'),
  ],
)
// For other states, swap 'green' for 'yellow', 'red', 'blue', or 'gray'
```

### 10. Empty State
Used when a list or page has no data to display.
```dart
WDiv(
  className: 'flex flex-col items-center justify-center py-12 gap-4',
  children: [
    WIcon(Icons.monitor_heart_outlined, className: 'text-gray-300 dark:text-gray-600 text-6xl'),
    WText('No monitors yet', className: 'text-lg font-semibold text-gray-900 dark:text-white'),
    WText('Create your first monitor to get started', className: 'text-sm text-gray-500 dark:text-gray-400 text-center'),
    WButton(
      onTap: () {},
      className: 'mt-2 bg-primary hover:bg-green-600 text-white py-2.5 px-4 rounded-lg font-medium text-sm',
      child: WText('Create Monitor'),
    ),
  ],
)
```

### 11. List Item (with icon + text + action)
A standard row in a list or table-like view. Note the `flex-1` which is required for text truncation to work properly.
```dart
WButton(
  onTap: () {},
  className: 'w-full px-4 py-3 flex flex-row items-center gap-3 hover:bg-gray-50 dark:hover:bg-gray-800/50 border-b border-gray-100 dark:border-gray-700',
  child: WDiv(
    className: 'flex flex-row items-center gap-3 w-full',
    children: [
      WDiv(
        className: 'p-2 rounded-lg bg-primary/10',
        child: WIcon(Icons.language_outlined, className: 'text-primary text-lg'),
      ),
      WDiv(
        className: 'flex-1', // CRITICAL: flex-1 required for truncate on children
        children: [
          WText('monitor.example.com', className: 'text-sm font-medium text-gray-900 dark:text-white truncate'),
          WText('HTTP • 500ms avg', className: 'text-xs text-gray-500 dark:text-gray-400'),
        ],
      ),
      WIcon(Icons.chevron_right_outlined, className: 'text-gray-400 text-lg'),
    ],
  ),
)
```

### 12. Alert/Banner (inline)
For showing important contextual information, warnings, or errors.
```dart
WDiv(
  className: 'flex flex-row items-start gap-3 p-4 rounded-xl bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800',
  children: [
    WIcon(Icons.warning_amber_outlined, className: 'text-yellow-600 dark:text-yellow-400 text-lg mt-0.5'),
    WDiv(
      className: 'flex-1',
      children: [
        WText('Warning', className: 'text-sm font-semibold text-yellow-800 dark:text-yellow-300'),
        WText('Your account has limited features.', className: 'text-sm text-yellow-700 dark:text-yellow-400'),
      ],
    ),
  ],
)
```

### 13. Loading Skeleton
Placeholder content while data is fetching. Wrap the whole container in `animate-pulse`.
```dart
WDiv(
  className: 'animate-pulse flex flex-col gap-3 p-4 bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700',
  children: [
    WDiv(className: 'h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4'),
    WDiv(className: 'h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/2'),
    const WSpacer(className: 'h-2'),
    WDiv(className: 'h-4 bg-gray-200 dark:bg-gray-700 rounded w-5/6'),
  ],
)
```

### 14. Divider / Section Separator
Horizontal rule.
```dart
WDiv(className: 'w-full h-px bg-gray-200 dark:bg-gray-700 my-4')
```

### 15. Navigation Item (Sidebar)
For main app navigation links. Handles active, hover, and default states.
```dart
WButton(
  onTap: () {},
  states: isActive ? {'active'} : {},
  className: 'w-full flex flex-row items-center gap-3 px-3 py-2.5 rounded-lg text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 active:bg-primary/10 active:text-primary transition-colors',
  child: WDiv(
    className: 'flex flex-row items-center gap-3 flex-1',
    children: [
      WIcon(Icons.monitor_outlined, className: 'text-lg'),
      WText('Monitors', className: 'text-sm font-medium'),
    ],
  ),
)
```

### 16. Badge Overlay (Relative + Absolute Positioning)
Position a badge, dot, or count indicator over a parent element using `relative`/`absolute` positioning.
```dart
WDiv(
  className: 'relative',
  children: [
    // Base content (icon, avatar, card, etc.)
    WDiv(
      className: 'p-3 rounded-xl bg-gray-100 dark:bg-gray-800',
      child: WIcon(Icons.notifications_outlined, className: 'text-gray-600 dark:text-gray-300 text-xl'),
    ),
    // Positioned badge
    WDiv(
      className: 'absolute top-0 right-0 -mt-1 -mr-1 w-4 h-4 rounded-full bg-red-500 flex items-center justify-center',
      child: WText('3', className: 'text-[10px] font-bold text-white'),
    ),
  ],
)
```

**Positioning tokens:**
| Token | Maps to |
|-------|---------|
| `relative` | `Stack` (parent) |
| `absolute` | `Positioned` (child) |
| `top-0 right-0` | Positioned(top: 0, right: 0) |
| `bottom-0 left-0` | Positioned(bottom: 0, left: 0) |
| `inset-0` | Positioned.fill() |

### 17. Pulsing Status Dot
Real-time status indicator with animation. Used for live/online/active indicators.
```dart
// Standalone pulsing dot
WDiv(className: 'w-2 h-2 rounded-full bg-green-500 animate-pulse')

// Status dot inside a badge row
WDiv(
  className: 'inline-flex items-center gap-1.5 px-2 py-1 rounded-full bg-green-100 dark:bg-green-900/30',
  children: [
    WDiv(className: 'w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse'),
    WText('Online', className: 'text-xs font-medium text-green-700 dark:text-green-400'),
  ],
)
```

**Animation tokens:**
| Token | Effect |
|-------|--------|
| `animate-pulse` | Gentle opacity fade in/out (ideal for skeletons, status dots) |
| `animate-spin` | Continuous 360° rotation (ideal for loading spinners) |
| `animate-bounce` | Vertical bounce (ideal for scroll indicators) |