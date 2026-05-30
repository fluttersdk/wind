# Get Started with Wind

Wind enables seamless styling in Flutter by interpreting class names directly in your widget trees, transforming them into optimized designs.

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Binding the Flutter Theme](#binding-the-flutter-theme)
- [Related Documentation](#related-documentation)

<a name="requirements"></a>
## Requirements

Wind is a pure Flutter package with no platform-specific setup. To use it you need:

- Flutter `>=3.3.0`
- Dart `>=3.6.0`

<a name="installation"></a>
## Installation

To get started, run the following command in your terminal:

```bash
flutter pub add fluttersdk_wind
```

Or add the following to your `pubspec.yaml`:

```yaml
dependencies:
  fluttersdk_wind: ^0.0.5
```

Then run `flutter pub get`.

<a name="usage"></a>
## Usage

Below is an example of how to use Wind to style your Flutter widgets.

This example builds a card component with several text elements, each styled with Wind classes:

```dart
WCard(
  className: 'shadow-lg rounded-lg m-4 p-4 bg-black',
  child: WFlex(
    className: 'flex-col axis-min gap-2 items-start',
    children: [
      WText('12', className: 'text-4xl leading-6 font-bold text-white'),
      WText(
        'Active users on the website',
        className: 'text-white leading-4',
      ),
      WText(
        'A short summary of recent activity across the platform.',
        className: 'text-gray-300 text-xs',
      ),
    ],
  ),
)
```

`WCard` provides the surface, `WFlex` arranges its children along an axis, and each `WText` carries its own typography and color utilities.

<a name="binding-the-flutter-theme"></a>
## Binding the Flutter Theme

By binding the Wind theme to your Flutter application, you can merge your app's colors and styles with Wind's theming system.

This step is optional, but recommended: it keeps your Material design and your Wind utilities consistent across the whole app.

See [Binding the Flutter Theme](binding-the-flutter-theme.md) for how to wire the Wind theme into your `MaterialApp`.

<a name="related-documentation"></a>
## Related Documentation

- [Binding the Flutter Theme](binding-the-flutter-theme.md) — connect Wind's theme to your `MaterialApp`.
- [Utility-First](../concepts/utility-first.md) — the styling philosophy behind Wind.
- [WCard](../widgets/wcard.md) — the card widget used above.
- [WFlex](../widgets/wflex.md) — the flex layout widget used above.
- [WText](../widgets/wtext.md) — the text widget used above.
