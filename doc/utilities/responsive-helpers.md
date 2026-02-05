# Responsive Helpers

Programmatic access to responsive breakpoints.

## wScreen Function

Get breakpoint pixel value:

```dart
int? md = wScreen(context, 'md');  // 768
int? lg = wScreen(context, 'lg');  // 1024
int? xl = wScreen(context, 'xl');  // 1280
```

## wScreenIs Function

Check if screen is at least a breakpoint:

```dart
if (wScreenIs(context, 'lg')) {
  // Desktop layout
} else if (wScreenIs(context, 'md')) {
  // Tablet layout
} else {
  // Mobile layout
}
```

## wScreenCurrent Function

Get current active breakpoint:

```dart
String current = wScreenCurrent(context);  // 'md', 'lg', etc.
```

## Context Extensions

Convenient shortcuts:

```dart
// Check breakpoints
bool isMobile = context.wIsMobile;    // < md
bool isTablet = context.wIsTablet;    // >= md && < lg
bool isDesktop = context.wIsDesktop;  // >= lg

// Get current breakpoint
String bp = context.wActiveBreakpoint;

// Check specific breakpoint
bool isLarge = context.wScreenIsExt('lg');
```

## Default Breakpoints

| Name | Width |
| :--- | :--- |
| `sm` | 640px |
| `md` | 768px |
| `lg` | 1024px |
| `xl` | 1280px |
| `2xl` | 1536px |

## Function Reference

| Function | Description |
| :--- | :--- |
| `wScreen(context, name)` | Returns breakpoint pixels |
| `wScreenIs(context, name)` | Returns true if >= breakpoint |
| `wScreenCurrent(context)` | Returns current breakpoint |
| `context.wIsMobile` | True if < md |
| `context.wIsTablet` | True if md <= screen < lg |
| `context.wIsDesktop` | True if >= lg |

## Related

- [Spacing Helpers](./spacing-helpers.md)
- [Style Parser](./style-parser.md)
