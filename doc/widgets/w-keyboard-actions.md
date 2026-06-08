# WKeyboardActions

A wrapper that renders a Done button and field-navigation toolbar above the keyboard for any group of input fields, with optional platform targeting and custom close widget.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Platform Targeting](#platform-targeting)
- [Navigation Between Fields](#navigation-between-fields)
- [Toolbar Styling](#toolbar-styling)
- [Custom Close Button](#custom-close-button)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/w_keyboard_actions_basic" size="md" source="example/lib/pages/widgets/w_keyboard_actions_basic.dart"></x-preview>

```dart
WKeyboardActions(
  focusNodes: [_nameFocus, _amountFocus],
  toolbarClassName: 'bg-gray-100 dark:bg-gray-800',
  child: Column(
    children: [
      WInput(focusNode: _nameFocus, placeholder: 'Jane Doe'),
      WInput(
        focusNode: _amountFocus,
        placeholder: '0.00',
        type: InputType.number,
      ),
    ],
  ),
)
```

<a name="basic-usage"></a>
## Basic Usage

Create a `FocusNode` for each input field and pass them all in the `focusNodes` list. `WKeyboardActions` attaches listeners to every node and shows the toolbar as long as any one of them is focused.

```dart
class _MyFormState extends State<MyForm> {
  final _nameFocus = FocusNode();
  final _amountFocus = FocusNode();

  @override
  void dispose() {
    _nameFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WKeyboardActions(
      focusNodes: [_nameFocus, _amountFocus],
      child: Column(
        children: [
          WInput(focusNode: _nameFocus, placeholder: 'Full Name'),
          WInput(
            focusNode: _amountFocus,
            placeholder: '0.00',
            type: InputType.number,
          ),
        ],
      ),
    );
  }
}
```

<a name="constructor"></a>
## Constructor

```dart
const WKeyboardActions({
  Key? key,
  required Widget child,
  required List<FocusNode> focusNodes,
  String platform = 'all',
  bool nextFocus = true,
  String? toolbarClassName,
  Widget Function(FocusNode)? closeWidgetBuilder,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `child` | `Widget` | **Required** | The form or column of inputs the toolbar is attached to. |
| `focusNodes` | `List<FocusNode>` | **Required** | FocusNodes for the inputs that need keyboard actions. Order determines navigation order. |
| `platform` | `String` | `'all'` | Platform gate: `'all'`, `'ios'`, or `'android'`. |
| `nextFocus` | `bool` | `true` | When true, Previous/Next arrow buttons appear in the toolbar for field navigation. |
| `toolbarClassName` | `String?` | `null` | Wind utility classes applied to the toolbar background (typically `bg-*` classes). |
| `closeWidgetBuilder` | `Widget Function(FocusNode)?` | `null` | Builder that replaces the default "Done" button. Receives the currently-focused FocusNode. |

<a name="platform-targeting"></a>
## Platform Targeting

The `platform` prop gates the toolbar to a specific OS. The most common value is `'ios'`, because iOS numeric keyboards have no built-in Done button.

| Value | Toolbar visible on |
|:------|:-------------------|
| `'all'` | iOS and Android (default) |
| `'ios'` | iOS only |
| `'android'` | Android only |

```dart
WKeyboardActions(
  platform: 'ios',
  focusNodes: [_amountFocus],
  child: WInput(
    focusNode: _amountFocus,
    placeholder: '0.00',
    type: InputType.number,
  ),
)
```

<a name="navigation-between-fields"></a>
## Navigation Between Fields

When `nextFocus: true` (the default), the toolbar shows Previous and Next arrow buttons. They move focus to the previous or next node in the `focusNodes` list, in the order they were provided. The Previous button is disabled at the first field; the Next button is disabled at the last.

Set `nextFocus: false` to show only the Done button, which is useful for single-field forms.

```dart
WKeyboardActions(
  focusNodes: [_nameFocus, _emailFocus, _amountFocus],
  nextFocus: true,
  child: Column(
    children: [
      WInput(focusNode: _nameFocus, placeholder: 'Jane Doe'),
      WInput(focusNode: _emailFocus, placeholder: 'jane@example.com'),
      WInput(focusNode: _amountFocus, placeholder: '0.00'),
    ],
  ),
)
```

<a name="toolbar-styling"></a>
## Toolbar Styling

Pass Wind `bg-*` utility classes via `toolbarClassName` to set the toolbar background. The `dark:` pair is required.

```dart
WKeyboardActions(
  toolbarClassName: 'bg-gray-100 dark:bg-gray-800',
  focusNodes: [_focusNode],
  child: myInputField,
)
```

When `toolbarClassName` is null, the toolbar uses `Theme.of(context).colorScheme.surfaceContainerHighest`.

<a name="custom-close-button"></a>
## Custom Close Button

Supply `closeWidgetBuilder` to replace the default "Done" label with any widget. The builder receives the currently-focused `FocusNode`, which you can call `unfocus()` on.

```dart
WKeyboardActions(
  focusNodes: [_focusNode],
  closeWidgetBuilder: (node) => WButton(
    onTap: node.unfocus,
    className: 'bg-blue-600 text-white px-4 py-1.5 rounded-md text-sm font-medium',
    child: const WText('Save & Close', className: 'text-white text-sm font-medium'),
  ),
  child: myInputField,
)
```

<a name="styling-examples"></a>
## Styling Examples

### Minimal (single field, iOS only)

```dart
WKeyboardActions(
  platform: 'ios',
  nextFocus: false,
  focusNodes: [_amountFocus],
  toolbarClassName: 'bg-white dark:bg-gray-900',
  child: WInput(
    focusNode: _amountFocus,
    placeholder: '0.00',
    type: InputType.number,
  ),
)
```

### Multi-field form with custom toolbar color

```dart
WKeyboardActions(
  focusNodes: [_nameFocus, _emailFocus, _amountFocus],
  toolbarClassName: 'bg-blue-50 dark:bg-blue-950',
  child: Column(
    children: [
      WInput(focusNode: _nameFocus, placeholder: 'Jane Doe'),
      WInput(focusNode: _emailFocus, placeholder: 'jane@example.com'),
      WInput(focusNode: _amountFocus, placeholder: '0.00'),
    ],
  ),
)
```

### Custom close widget

```dart
WKeyboardActions(
  focusNodes: [_focusNode],
  toolbarClassName: 'bg-emerald-50 dark:bg-emerald-900',
  closeWidgetBuilder: (node) => TextButton.icon(
    onPressed: node.unfocus,
    icon: const Icon(Icons.check_circle_outlined),
    label: const Text('Done'),
  ),
  child: myInputField,
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WInput - The unstyled text input widget](./w-input.md)
- [WFormInput - Form-bound WInput with validator](./w-form-input.md)
- [WDiv - General-purpose container for laying out form fields](../widgets/w-div.md)
