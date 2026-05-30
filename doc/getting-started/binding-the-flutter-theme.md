# Binding the Flutter Theme

Bind the Wind theme to your `MaterialApp` so your app's Material defaults and Wind's utility-first styles stay consistent.

- [Dynamic Binding](#dynamic-binding)
- [Static Binding](#static-binding)
- [Customization Parameters](#customization-parameters)
- [Related Documentation](#related-documentation)

```dart
MaterialApp(
  theme: WindTheme.toThemeData(
    primarySwatch: Colors.blue,
    bodyFontString: 'Roboto',
    displayFontString: 'Lobster',
  ),
)
```

Wind exposes two ways to produce a `ThemeData`:

1. **Dynamic Mode** with `WindTheme.toThemeCallback`, which adapts to runtime changes such as light/dark mode transitions automatically.
2. **Static Mode** with `WindTheme.toThemeData`, which is simpler to set up but requires manual updates when the brightness changes at runtime.

`WindTheme` is a static class, so you call these methods directly on the type. There is no theme-data object or builder to instantiate.

<a name="dynamic-binding"></a>
## Dynamic Binding

`WindTheme.toThemeCallback` updates the theme in response to runtime changes like light or dark mode toggling. It reads the brightness from the current `BuildContext` (or from the `brightness` you pass) and keeps the app in sync without manual intervention.

```dart
class MyApp extends StatelessWidget {
  final Widget Function(BuildContext) appCallback;

  const MyApp({super.key, required this.appCallback});

  @override
  Widget build(BuildContext context) {
    return appCallback(context);
  }
}

void main() {
  runApp(MyApp(
    appCallback: (context) {
      return MaterialApp(
        theme: WindTheme.toThemeCallback(
          context,
          primarySwatch: Colors.blue,
          bodyFontString: 'Roboto',
          displayFontString: 'Lobster',
        ),
      );
    },
  ));
}
```

`toThemeCallback` resolves the brightness from the context (via `setTypeFromContext`) unless you pass an explicit `brightness`, then delegates to `toThemeData`. This makes it the right choice for dynamic theme transitions.

<a name="static-binding"></a>
## Static Binding

If you do not need runtime adaptability, `WindTheme.toThemeData` is the simpler option. It applies the theme statically. When the brightness changes during runtime, update the theme manually by calling `WindTheme.setType`.

```dart
void main() {
  runApp(MaterialApp(
    theme: WindTheme.toThemeData(
      primarySwatch: Colors.green,
      bodyFontString: 'Open Sans',
      displayFontString: 'Pacifico',
      backgroundColor: Colors.grey.shade200,
      brightness: Brightness.light,
    ),
  ));
}
```

To switch to dark mode at runtime:

```dart
WindTheme.setType(Brightness.dark);
```

Calling `setType` regenerates Wind's darkened color set so the theme reflects the new brightness state.

<a name="customization-parameters"></a>
## Customization Parameters

Both `toThemeData` and `toThemeCallback` accept the same named parameters to customize the Material theme:

| Parameter | Description | Default Value |
|:---|:---|:---|
| `textTheme` | Custom `TextTheme` for the app's typography. | `Typography.material2021().englishLike` |
| `bodyFontString` | Font family for body text. | `WindTheme.getBodyFontString()` |
| `displayFontString` | Font family for display text (e.g. headings). | `WindTheme.getDisplayFontString()` |
| `primarySwatch` | Primary color swatch for the app. | `WindTheme.getMaterialColor('primary')` |
| `accentColor` | Secondary accent color. | `WindTheme.getColor('secondary')` |
| `cardColor` | Background color for cards. | `WindTheme.getColor('white')` |
| `backgroundColor` | Default background color for the app. | `WindTheme.getColor('gray', shade: 50)` |
| `errorColor` | Color used for error states. | `WindTheme.getColor('red')` |
| `brightness` | Overall brightness (light or dark mode). | Current `WindTheme` type |

The defaults above are the ones `toThemeData` applies. `toThemeCallback` differs on two: it defaults `textTheme` to `Theme.of(context).textTheme` and resolves `brightness` from the current `BuildContext` (unless you pass an explicit value), which is what makes it adapt to runtime light/dark changes.

Choose the method that best fits your application's needs.

<a name="related-documentation"></a>
## Related Documentation

- [Get Started with Wind](installation.md) — install Wind and style your first widget.
- [Dark Mode](../concepts/dark-mode.md) — how Wind handles brightness and color inversion.
- [Colors](../customization/colors.md) — customize the palette `toThemeData` reads from.
- [Font Family](../customization/font-family.md) — set the body and display fonts.
