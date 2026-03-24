# Wind UI v1 - Layout Patterns & Debugging

This guide documents production-tested layout patterns for Wind UI v1 and provides a debugging guide for common Flutter layout constraints.

## 1. Full-Screen Page with Scrollable Content

The standard mobile page layout: a fixed app bar (or header) with a scrollable body.

```dart
// The root container must have bounded height (h-full or min-h-screen)
WDiv(
  className: 'flex flex-col h-full', // h-full bounds the column for the scroll child
  children: [
    // Fixed header (not scrollable)
    WDiv(
      className: 'px-4 py-3 border-b border-gray-200 dark:border-gray-700',
      child: WText('Page Title', className: 'text-2xl font-bold text-gray-900 dark:text-white'),
    ),
    // Scrollable content area
    // flex-1 is CRITICAL: It gives the scroll view a bounded height within the Column
    WDiv(
      className: 'flex-1 overflow-y-auto', 
      scrollPrimary: true, // REQUIRED for iOS tap-to-status-bar-to-scroll-to-top
      child: WDiv(
        className: 'p-4 lg:p-6 flex flex-col gap-5',
        children: [ /* page content */ ],
      ),
    ),
  ],
)
```

**Constraint Note:** `overflow-y-auto` translates to `SingleChildScrollView`. In Flutter, scroll views try to take infinite height. If placed directly inside a `flex-col` (Column) without `flex-1` (Expanded), it will throw an unbounded height error. `flex-1` forces the scroll view to fill only the *remaining* vertical space.

## 2. Responsive Sidebar + Content Layout (Desktop/Web)

A classic responsive shell that shows a fixed sidebar on large screens and relies on a Drawer (not shown in snippet) on small screens.

```dart
LayoutBuilder(
  builder: (context, constraints) {
    // Check if the screen is large enough for desktop layout
    final isDesktop = context.wScreenIs('lg');
    
    if (isDesktop) {
      return WDiv(
        // The root row needs full width and height
        className: 'flex flex-row w-full h-full',
        children: [
          // Fixed-width sidebar
          WDiv(
            className: 'w-64 h-full flex flex-col bg-white dark:bg-gray-900 border-r border-gray-200 dark:border-gray-700',
            child: AppSidebar(),
          ),
          // Main content area
          // flex-1 is CRITICAL: It forces the content area to fill the remaining horizontal space next to the 64px sidebar
          WDiv(
            className: 'flex-1 flex flex-col h-full', 
            children: [
               AppHeader(),
               WDiv(className: 'flex-1 overflow-y-auto', child: /* page content */),
            ],
          ),
        ],
      );
    }
    
    // Mobile layout uses Scaffold Drawer
    return Scaffold(
      drawer: AppSidebar(),
      body: /* mobile content */,
    );
  },
)
```

**Constraint Note:** `flex-1` on the main content `WDiv` ensures it takes up exactly `screenWidth - sidebarWidth`. Without it, the Row wouldn't know how to size the content area.

## 3. Centered Content with Max Width

Commonly used for settings pages, authentication forms, or readable text views where content shouldn't stretch edge-to-edge on desktop.

```dart
WDiv(
  className: 'flex-1 overflow-y-auto bg-gray-50 dark:bg-gray-900',
  scrollPrimary: true,
  child: WDiv(
    // mx-auto centers the container horizontally within its parent
    // max-w-2xl limits the maximum width on large screens
    // w-full ensures it takes full width on small screens (up to the max-w)
    className: 'w-full max-w-2xl mx-auto px-4 py-6 flex flex-col gap-6',
    children: [ 
      /* centered form or content */ 
    ],
  ),
)
```

**Constraint Note:** `mx-auto` only works if the parent container has a defined width. Here, the parent (`overflow-y-auto`) takes up the full width of the screen, so the child can be centered within it.

## 4. Row with Growing Text + Fixed Action

A frequent pattern in list items where a title needs to truncate gracefully while pushing an action button to the far right.

```dart
WDiv(
  className: 'flex flex-row items-center gap-3 p-4 border-b border-gray-100 dark:border-gray-800',
  children: [
    WIcon(Icons.monitor_outlined, className: 'text-primary text-xl'),
    
    // The wrapper for the truncating text
    // flex-1 is CRITICAL: It provides a strict width boundary for the Text widget
    WDiv(
      className: 'flex-1 flex flex-col min-w-0', // min-w-0 prevents flex blowout in nested layouts
      children: [
        WText(
          'Monitor Name - Very Long Title That Should Truncate On Small Screens', 
          className: 'truncate text-sm font-medium text-gray-900 dark:text-white',
        ),
        WText(
          'https://example.com/health', 
          className: 'truncate text-xs text-gray-500 font-mono',
        ),
      ],
    ),
    
    // Fixed width action button
    WButton(
      onTap: () {},
      className: 'p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800',
      child: WIcon(Icons.more_vert_outlined),
    ),
  ],
)
```

**Constraint Note:** `truncate` maps to `TextOverflow.ellipsis`. In Flutter, text inside a `Row` will try to take infinite width to render itself. If it exceeds the screen width, it causes a `RenderFlex` overflow. Wrapping the text in `flex-1` (Expanded) forces it to fit within the remaining space, allowing truncation to kick in.

## 5. Responsive Grid (Wrap)

A dashboard statistics grid that adapts from 2 columns on mobile to 4 columns on desktop.

```dart
WDiv(
  // grid grid-cols-2 translates to a Wrap widget configured for 2 columns
  // md:grid-cols-4 changes the configuration at the medium breakpoint
  className: 'grid grid-cols-2 md:grid-cols-4 gap-4 p-4 lg:p-6',
  children: [
     StatCard(title: 'Total', value: '24'),
     StatCard(title: 'Up', value: '21'),
     StatCard(title: 'Down', value: '2'),
     StatCard(title: 'Paused', value: '1'),
  ],
)
```

**Constraint Note:** Wind UI's `grid` translates to Flutter's `Wrap` widget, *not* `GridView`. This is intentional because `Wrap` calculates its height based on its children, allowing it to be placed smoothly inside an `overflow-y-auto` view without needing a bounded height itself.

## 6. Modal / Bottom Sheet Layout

A custom slide-over or modal with a fixed header, scrollable body, and fixed footer actions.

```dart
WDiv(
  // max-h-[80vh] prevents the sheet from taking over the entire screen on tall devices
  className: 'flex flex-col max-h-[80vh] bg-white dark:bg-gray-900 rounded-t-2xl',
  children: [
    // Drag handle (for bottom sheets)
    WDiv(
      className: 'w-full py-3 flex justify-center',
      child: WDiv(className: 'w-10 h-1 rounded-full bg-gray-300 dark:bg-gray-600')
    ),
    
    // Fixed Header
    WDiv(
      className: 'px-4 py-3 flex flex-row items-center justify-between border-b border-gray-200 dark:border-gray-700',
      children: [
        WText('Modal Title', className: 'text-lg font-bold text-gray-900 dark:text-white'),
        WButton(
          onTap: () => Navigator.pop(context),
          className: 'p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800',
          child: WIcon(Icons.close_outlined, className: 'text-gray-500')
        ),
      ],
    ),
    
    // Scrollable Content
    // flex-1 is CRITICAL: It allows the content to scroll within the modal's constrained height
    WDiv(
      className: 'flex-1 overflow-y-auto',
      child: WDiv(
        className: 'p-4 flex flex-col gap-4', 
        children: [ /* form fields or details */ ]
      )
    ),
    
    // Fixed Footer Actions
    WDiv(
      className: 'px-4 py-4 border-t border-gray-200 dark:border-gray-700 flex flex-row justify-end gap-3',
      children: [
        WButton(
          onTap: () => Navigator.pop(context),
          className: 'px-4 py-2 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 rounded-lg',
          child: WText('Cancel')
        ),
        WButton(
          onTap: () {}, 
          className: 'px-4 py-2 bg-primary text-white rounded-lg',
          child: WText('Confirm')
        ),
      ]
    ),
  ],
)
```

**Constraint Note:** `max-h-[80vh]` provides the absolute height boundary. `flex-1` on the scrollable area ensures it takes up whatever space is left after the header and footer are rendered.

## 7. Safe Area Management

Handling notches and home indicators appropriately.

```dart
// For a standard page with a bottom navigation bar:
Scaffold(
  body: SafeArea(
    // bottom: false is CRITICAL when using a bottomNavigationBar,
    // otherwise you get double padding at the bottom of the screen
    bottom: false, 
    child: WDiv(
      className: 'flex flex-col h-full',
      children: [ /* content */ ],
    ),
  ),
  bottomNavigationBar: CustomBottomNav(), // The nav handles its own bottom padding
)

// Inside a custom Bottom Navigation Bar:
Widget build(BuildContext context) {
  // Get the device's bottom safe area padding (e.g., iPhone home indicator)
  final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
  
  return WDiv(
    className: 'bg-white border-t border-gray-200',
    children: [
      WDiv(
        className: 'flex flex-row justify-between px-4 py-2',
        children: [ /* nav items */ ]
      ),
      // Apply the safe area padding at the very bottom
      SizedBox(height: bottomPadding),
    ]
  );
}
```


---

## Layout Debugging Guide

Flutter constraint resolution is completely different from CSS. Wind UI uses `className` syntax, but maps it to native Flutter semantics. Here are the most common layout errors and how to fix them.

| Error | Cause | Fix |
|-------|-------|-----|
| `RenderFlex overflow (Row)` | `w-full` inside `flex flex-row` | Replace `w-full` with `flex-1` on the child that needs to expand. `w-full` means infinite width. |
| `RenderFlex overflow (Column)` | Child has no size constraint inside a constrained container | Add explicit height (e.g., `h-48`) or use `flex-1` |
| `Vertical viewport was given unbounded height` | `overflow-y-auto` used without a bounded parent | Wrap the `overflow-y-auto` `WDiv` in `flex-1` (if inside a Column) or `h-[500px]`. |
| `'h-full' shows wrong or zero height` | Parent has unbounded height (like inside a scroll view) | Replace `h-full` with `min-h-screen` on the root container. |
| `WText truncate not working` | `WText` has no bounded width in a `Row` | Wrap the `WText` in `WDiv(className: 'flex-1', child: ...)` |
| `ListView inside Column causes overflow` | Native `ListView` is unbounded inside a `Column` | Wrap the `ListView` in a native Flutter `Expanded()` widget. |
| `Center widget not centering` | The container holding the Center has no size | Add `w-full` (if inside Column) or `flex-1` (if inside Row) to the parent container. |
| `flex-wrap` is doing nothing | `flex-wrap` is a CSS concept, not a Flutter `Row` concept | Remove `flex flex-row flex-wrap` and use just `wrap` or `grid` instead. |
