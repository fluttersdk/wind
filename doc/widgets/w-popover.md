# WPopover

A flexible popover component for creating dropdown menus, notification panels, user menus, tooltips, and similar overlay patterns.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="popover/popover_basic" size="md" source="example/lib/pages/popover/popover_basic.dart"></x-preview>

```dart
WPopover(
  alignment: PopoverAlignment.bottomRight,
  className: 'w-64 bg-white dark:bg-gray-800 rounded-xl shadow-xl p-2',
  triggerBuilder: (context, isOpen, isHovering) => WButton(
    className: 'bg-blue-600 text-white',
    child: Text('Open Menu'),
  ),
  contentBuilder: (context, close) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(title: Text('Profile'), onTap: close),
      ListTile(title: Text('Settings'), onTap: close),
    ],
  ),
)
```

## Basic Usage

The `WPopover` widget uses two builders: `triggerBuilder` for the element that activates the popover, and `contentBuilder` for the overlay content. It manages the overlay state and positioning automatically.

```dart
WPopover(
  triggerBuilder: (context, isOpen, isHovering) => WText(
    'Click me',
    className: 'text-blue-500 cursor-pointer',
  ),
  contentBuilder: (context, close) => WDiv(
    className: 'p-4',
    child: WText('Hello from Popover!'),
  ),
)
```

## Constructor

```dart
const WPopover({
  Key? key,
  required PopoverTriggerBuilder triggerBuilder,
  required PopoverContentBuilder contentBuilder,
  PopoverController? controller,
  bool enableTriggerOnTap = true,
  PopoverAlignment alignment = PopoverAlignment.bottomLeft,
  String? className,
  Offset offset = const Offset(0, 4),
  double maxHeight = 400,
  bool disabled = false,
  bool closeOnContentTap = false,
  VoidCallback? onOpen,
  VoidCallback? onClose,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `triggerBuilder` | `PopoverTriggerBuilder` | **Required** | Builder for the trigger widget. Receives `isOpen` and `isHovering` states. |
| `contentBuilder` | `PopoverContentBuilder` | **Required** | Builder for the popover content. Receives a `close` callback. |
| `className` | `String?` | `null` | Wind utility classes for the popover container styling. |
| `controller` | `PopoverController?` | `null` | Optional controller for programmatic show/hide/toggle. |
| `alignment` | `PopoverAlignment` | `bottomLeft` | Where to position the popover relative to the trigger. |
| `offset` | `Offset` | `Offset(0, 4)` | Gap between the trigger and the popover. |
| `maxHeight` | `double` | `400` | Maximum height for the content. It will scroll if exceeded. |
| `enableTriggerOnTap` | `bool` | `true` | Whether tapping the trigger toggles the popover. |
| `closeOnContentTap` | `bool` | `false` | Whether tapping inside the content closes the popover. |
| `disabled` | `bool` | `false` | When true, the trigger will not respond to interactions. |
| `onOpen` | `VoidCallback?` | `null` | Callback fired when the popover is opened. |
| `onClose` | `VoidCallback?` | `null` | Callback fired when the popover is closed. |

## Layout Modes

While `WPopover` itself isn't a layout container, it supports various **Alignment Modes** to determine how the overlay is positioned relative to the trigger.

### Alignment

`WPopover` intelligently "flips" the alignment if the requested position would cause the overlay to overflow the screen edges.

<x-preview path="widgets/w_popover_alignment" size="md" source="example/lib/pages/widgets/w_popover_alignment.dart"></x-preview>

| Alignment | Description |
|:----------|:------------|
| `bottomLeft` | Below trigger, aligned to left edge (Default). |
| `bottomRight` | Below trigger, aligned to right edge. |
| `bottomCenter` | Below trigger, centered horizontally. |
| `topLeft` | Above trigger, aligned to left edge. |
| `topRight` | Above trigger, aligned to right edge. |
| `topCenter` | Above trigger, centered horizontally. |

## Event Handling

The `triggerBuilder` provides the `isOpen` and `isHovering` states, allowing you to reactively style the trigger. The `contentBuilder` provides a `close` callback to dismiss the popover from within the content (e.g., when a menu item is clicked).

```dart
WPopover(
  triggerBuilder: (context, isOpen, isHovering) => WDiv(
    className: 'p-2 rounded ${isOpen ? "bg-blue-100" : "bg-gray-100"}',
    child: WText(isOpen ? 'Active' : 'Idle'),
  ),
  contentBuilder: (context, close) => WButton(
    onTap: close,
    child: Text('Click to Close'),
  ),
)
```

## State Variants

Since the popover trigger is built via `triggerBuilder`, you can apply state-based styling manually or use Wind's state prefixes if the trigger is a Wind widget like `WButton` or `WDiv`.

```dart
WPopover(
  triggerBuilder: (context, isOpen, isHovering) => WButton(
    // Use the isOpen boolean for manual state toggling
    className: 'p-2 rounded-lg ${isOpen ? "bg-blue-600 text-white" : "bg-white text-gray-800"}',
    child: Text('Toggle Menu'),
  ),
  contentBuilder: (context, close) => MyContent(),
)
```

## Styling Examples

### Custom Size and Shadow

If no width is specified in `className`, the popover uses the trigger's width as a minimum. Use sizing utilities to define a specific width.

```dart
WPopover(
  className: 'w-80 bg-white rounded-2xl shadow-2xl border border-gray-100',
  triggerBuilder: (context, isOpen, isHovering) => Icon(Icons.more_horiz),
  contentBuilder: (context, close) => MyLargeMenu(),
)
```

### Dark Mode

`WPopover` fully supports dark mode styling using the `dark:` prefix.

```dart
WPopover(
  className: 'bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800 shadow-xl',
  triggerBuilder: (context, isOpen, isHovering) => MyTrigger(),
  contentBuilder: (context, close) => MyContent(),
)
```

## All Supported Classes

The popover overlay container is a `WDiv` and supports all standard Wind utilities.

| Category | Classes |
|:---------|:--------|
| Sizing | `w-{size}`, `max-w-{size}`, `h-{size}`, `max-h-{size}` |
| Background | `bg-{color}`, `bg-opacity-{n}` |
| Borders | `border`, `border-{color}`, `rounded-{size}` |
| Shadow | `shadow-{size}`, `shadow-{color}/{opacity}` |
| Padding | `p-{n}`, `px-{n}`, `py-{n}` |

## Customizing Theme

Popovers inherit from global theme scales. You can customize the default appearance by modifying the `WindThemeData`.

```dart
WindThemeData(
  colors: {
    'popover-bg': Colors.white,
  },
  baseSpacingUnit: 4.0,
)
```

## Related Documentation

- [WSelect - A high-level dropdown built using WPopover](./w-select.md)
- [WDiv - The base container widget](../widgets/w-div.md)
- [WAnchor - Useful for interactive elements inside the popover](./w-anchor.md)
