# WPopover

A flexible popover component for dropdowns, notification panels, user menus, and tooltips.

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
      WAnchor(
        onTap: close,
        child: WDiv(
          className: 'px-4 py-2 hover:bg-gray-100 rounded',
          child: WText('Delete'),
        ),
      ),
    ],
  ),
)
```

<x-preview path="popover/popover_basic" size="md"></x-preview>

---

## Alignment Options

Position the popover relative to the trigger:

| Alignment | Description |
|-----------|-------------|
| `bottomLeft` | Below trigger, left-aligned (default) |
| `bottomRight` | Below trigger, right-aligned |
| `bottomCenter` | Below trigger, centered |
| `topLeft` | Above trigger, left-aligned |
| `topRight` | Above trigger, right-aligned |
| `topCenter` | Above trigger, centered |

```dart
WPopover(
  alignment: PopoverAlignment.bottomRight,
  // ...
)
```

<x-preview path="popover/popover_alignment" size="md"></x-preview>

---

## Styling

Use Wind `className` for popover container:

```dart
WPopover(
  className: '''
    w-80 bg-white dark:bg-gray-800
    border border-gray-200 dark:border-gray-700
    rounded-xl shadow-xl p-2
  ''',
  // ...
)
```

If no width specified, popover matches trigger width.

---

## Props Reference

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `triggerBuilder` | `PopoverTriggerBuilder` | required | Builds trigger widget |
| `contentBuilder` | `PopoverContentBuilder` | required | Builds popover content |
| `alignment` | `PopoverAlignment` | `bottomLeft` | Position relative to trigger |
| `className` | `String?` | | Wind utility classes |
| `offset` | `Offset` | `(0, 4)` | Gap between trigger and popover |
| `maxHeight` | `double` | `400` | Maximum popover height |
| `disabled` | `bool` | `false` | Disable popover interaction |
| `closeOnContentTap` | `bool` | `false` | Close when content tapped |

---

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

---

## Examples

### Dropdown Menu

```dart
WPopover(
  alignment: PopoverAlignment.bottomLeft,
  className: 'w-48 bg-white shadow-lg rounded-lg py-1',
  triggerBuilder: (context, isOpen, isHovering) => WButton(
    onTap: null,
    className: 'px-4 py-2 bg-blue-600 text-white rounded-lg',
    child: WDiv(
      className: 'flex items-center gap-2',
      children: [
        WText('Actions'),
        WIcon(isOpen ? Icons.expand_less : Icons.expand_more),
      ],
    ),
  ),
  contentBuilder: (context, close) => WDiv(
    className: 'flex flex-col',
    children: [
      WAnchor(
        onTap: () { close(); edit(); },
        child: WDiv(
          className: 'flex items-center gap-3 px-4 py-2 hover:bg-gray-100',
          children: [
            WIcon(Icons.edit, className: 'text-gray-500'),
            WText('Edit'),
          ],
        ),
      ),
      WAnchor(
        onTap: () { close(); delete(); },
        child: WDiv(
          className: 'flex items-center gap-3 px-4 py-2 hover:bg-red-50 text-red-600',
          children: [
            WIcon(Icons.delete, className: 'text-red-500'),
            WText('Delete'),
          ],
        ),
      ),
    ],
  ),
)
```

### User Menu

```dart
WPopover(
  alignment: PopoverAlignment.bottomRight,
  className: 'w-64 bg-white rounded-xl shadow-xl',
  triggerBuilder: (context, isOpen, isHovering) => WDiv(
    className: 'w-10 h-10 rounded-full bg-blue-500 flex items-center justify-center',
    child: WText('JD', className: 'text-white font-bold'),
  ),
  contentBuilder: (context, close) => WDiv(
    className: 'p-4 flex flex-col gap-2',
    children: [
      WText('John Doe', className: 'font-semibold text-gray-900'),
      WText('john@example.com', className: 'text-sm text-gray-500'),
      WDiv(className: 'border-t border-gray-200 my-2'),
      WAnchor(
        onTap: close,
        child: WDiv(
          className: 'py-2 text-center hover:bg-gray-100 rounded text-red-600',
          child: WText('Sign Out'),
        ),
      ),
    ],
  ),
)
```

