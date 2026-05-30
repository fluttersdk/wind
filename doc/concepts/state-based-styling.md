# State-Based Styling

Apply styles that react to a widget's state, such as `hover` or `disabled`, using prefixed utility classes. Wind's `classNameParser` function resolves these prefixes against the list of currently active states you pass in, so state-aware styling stays declarative.

- [Basic Usage](#basic-usage)
- [How It Works](#how-it-works)
- [Building a Stateful Widget](#building-a-stateful-widget)
- [Best Practices](#best-practices)
- [Related Documentation](#related-documentation)

<x-preview path="core/state_based_styling" size="lg" source="example/lib/pages/core/state_based_styling.dart"></x-preview>

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

// Inside a widget that tracks its own active states:
final List<String> states = [];
if (isHovered) states.add('hover');
if (isDisabled) states.add('disabled');

final String parsed = classNameParser(
  'bg-primary-500 p-4 rounded-lg hover:bg-white disabled:bg-gray-500',
  states: states,
);

WFlexContainer(
  className: parsed,
  children: [
    WText('Submit', className: 'text-white'),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

Prefix a utility with a state name and pass the active states to `classNameParser`. When a state is active, its prefix is stripped and the underlying utility applies; when it is not active, the prefixed token is removed:

```dart
final String parsed = classNameParser(
  'bg-primary-500 hover:bg-white disabled:bg-gray-500',
  states: ['hover'],
);
// hover active -> bg-white wins; disabled token dropped.
```

State names are not a fixed set. Any token you list in `states` matches the corresponding prefix, so `hover`, `disabled`, `pressed`, `selected`, or your own custom name all work the same way.

<a name="how-it-works"></a>
## How It Works

`classNameParser(className, {states})` walks the `className` and, for each active state, strips the matching `state:` prefix so the utility behind it is applied. Prefixed tokens whose state is not active are dropped before the parsers run.

This is why state-based styling needs a stateful host widget: your widget decides which states are active (a hover from an `InkWell`, a `disabled` flag, a selection), assembles them into a list, and feeds that list to `classNameParser`. Wind does not track widget state for you; it resolves the class names against the states you report.

<a name="building-a-stateful-widget"></a>
## Building a Stateful Widget

Here is a reusable button that tracks hover and disabled states and styles itself through `classNameParser`:

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class AppButton extends StatefulWidget {
  final String? className;
  final String? textClassName;
  final String? text;
  final bool disabled;

  const AppButton({
    super.key,
    this.className,
    this.textClassName,
    this.text,
    this.disabled = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final List<String> states = [];
    if (widget.disabled) states.add('disabled');
    if (isHovered) states.add('hover');

    final String parsedClassName = classNameParser(widget.className, states: states);
    final String parsedTextClassName = classNameParser(widget.textClassName, states: states);

    return InkWell(
      onHover: (hovered) {
        if (!widget.disabled) {
          setState(() => isHovered = hovered);
        }
      },
      onTap: widget.disabled ? null : () {},
      child: WFlexContainer(
        className: parsedClassName,
        children: [
          WText(widget.text ?? 'Button', className: parsedTextClassName),
        ],
      ),
    );
  }
}
```

Used like this, the prefixed utilities resolve as the button's state changes:

```dart
AppButton(
  className: 'bg-primary-500 p-4 rounded-lg hover:bg-white',
  textClassName: 'text-white hover:text-primary-600',
  text: 'Submit',
);
```

<a name="best-practices"></a>
## Best Practices

- Drive states from your widget's own logic (hover callbacks, flags) and pass them into `classNameParser`; Wind does not manage state for you.
- Parse every class string that should react to state, including separate text class names, with the same `states` list.
- Keep base styles unprefixed and add only the state-specific overrides behind a prefix.
- Reuse one stateful wrapper (like `AppButton`) across your app instead of wiring state tracking into every call site.

<a name="related-documentation"></a>
## Related Documentation
- [Dark Mode](dark-mode.md) — the `dark:` prefix, resolved separately from interaction states.
- [Responsive Design](responsive-design.md) — breakpoint prefixes that compose with utilities.
- [Background Color](../backgrounds/background-color.md) — the `bg-*` utilities commonly toggled per state.
- [Text Color](../typography/text-color.md) — the `text-*` utilities for state-driven text styling.
