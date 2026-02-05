# WPopover

A flexible popover component for dropdowns, notification panels, user menus, and tooltips.

<x-preview path="popover/popover_basic" size="md" source="example/lib/pages/popover/popover_basic.dart"></x-preview>

## Basic Usage

```dart
WPopover(
  alignment: PopoverAlignment.bottomLeft,
  className: 'w-64 bg-white rounded-lg shadow-xl p-2',
  triggerBuilder: (context, isOpen, isHovering) => WDiv(
    className: 'px-3 py-2 border rounded hover:bg-gray-100',
    child: WText('Open Menu'),
  ),
  contentBuilder: (context, close) => WDiv(
    className: 'flex flex-col',
    children: [
      WAnchor(
        onTap: close,
        child: WDiv(
          className: 'px-4 py-2 hover:bg-gray-100 rounded',
          child: WText('Edit'),
        ),
      ),
    ],
  ),
)
```

## Alignment Options

<x-preview path="popover/popover_alignment" size="md" source="example/lib/pages/popover/popover_alignment.dart"></x-preview>

Position the popover relative to the trigger:

| Alignment | Description |
| :--- | :--- |
| `bottomLeft` | Below trigger, left-aligned (default) |
| `bottomRight` | Below trigger, right-aligned |
| `bottomCenter` | Below trigger, centered |
| `topLeft` | Above trigger, left-aligned |
| `topRight` | Above trigger, right-aligned |
| `topCenter` | Above trigger, centered |

## Styling

Use Wind `className` for popover container:

```dart
WPopover(
  className: '''
    w-80 bg-white dark:bg-gray-800
    border border-gray-200 dark:border-gray-700
    rounded-xl shadow-xl p-2
  ''',
)
```

If no width specified, popover matches trigger width.

## Programmatic Control

Use `PopoverController` to control the popover programmatically:

```dart
final _controller = PopoverController();

// Control methods
_controller.show();   // Open
_controller.hide();   // Close
_controller.toggle(); // Toggle

WPopover(
  controller: _controller,
  enableTriggerOnTap: false, // Disable default tap
  triggerBuilder: (context, isOpen, isHovering) => ...,
  contentBuilder: (context, close) => ...,
)
```

## Builder Signatures

```dart
// Trigger builder
typedef PopoverTriggerBuilder = Widget Function(
  BuildContext context,
  bool isOpen,      // Popover is currently open
  bool isHovering,  // Mouse is over trigger
);

// Content builder
typedef PopoverContentBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,  // Call to close popover
);
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `triggerBuilder` | `PopoverTriggerBuilder` | required | Builds trigger widget |
| `contentBuilder` | `PopoverContentBuilder` | required | Builds popover content |
| `controller` | `PopoverController?` | - | Controller for programmatic control |
| `alignment` | `PopoverAlignment` | `bottomLeft` | Position relative to trigger |
| `className` | `String?` | - | Wind utility classes |
| `offset` | `Offset` | `(0, 4)` | Gap between trigger and popover |
| `maxHeight` | `double` | `400` | Maximum popover height |
| `disabled` | `bool` | `false` | Disable popover interaction |
| `closeOnContentTap` | `bool` | `false` | Close when content tapped |
| `enableTriggerOnTap` | `bool` | `true` | Toggle on trigger tap |
| `onOpen` | `VoidCallback?` | - | Callback when opens |
| `onClose` | `VoidCallback?` | - | Callback when closes |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `max-w-*` | Popover width |
| **Background** | `bg-*` | Fill color |
| **Border** | `border-*`, `rounded-*` | Border style |
| **Shadow** | `shadow-*` | Drop shadow |
| **Padding** | `p-*`, `px-*`, `py-*` | Content padding |

## Related Documentation

- [WButton](./w-button.md) - Button widget
- [WAnchor](./w-anchor.md) - Anchor for menu items
