# Spacing Helpers

Wind provides programmatic access to your theme's spacing scale through helper functions and extensions. This allows you to maintain consistency when building custom widgets or manual layouts that aren't using `className` strings.

> [!NOTE]
> This page covers the **Dart API** for spacing. For CSS-like utility classes such as `p-4`, `m-2`, or `gap-6`, see the [Spacing Layout](../layout/spacing.md) documentation.

<x-preview path="utilities/spacing_helpers_basic" size="md" source="example/lib/pages/utilities/spacing_helpers_basic.dart"></x-preview>

- [The wSpacing Function](#wspacing-function)
- [Context Extensions](#context-extensions)
- [Programmatic Access](#programmatic-access)
- [Theme Configuration](#theme-configuration)

<a name="wspacing-function"></a>
## The wSpacing Function

The `wSpacing` helper is the primary way to calculate pixel values based on your theme's `baseSpacingUnit` (defaulting to 4px).

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

// Calculates: multiplier * baseSpacingUnit
double padding = wSpacing(context, 4);    // 16.0
double gap = wSpacing(context, 2.5);      // 10.0
double tight = wSpacing(context, 0.5);    // 2.0
```

### Signature

```dart
double wSpacing(BuildContext context, num multiplier)
```

| Parameter | Type | Description |
|:---|:---|:---|
| `context` | `BuildContext` | Required to look up the active `WindTheme`. |
| `multiplier` | `num` | The scale factor (e.g., 4 in `p-4`). |

<a name="context-extensions"></a>
## Context Extensions

For more ergonomic access, Wind adds the `wSpacingExt` shortcut to `BuildContext`.

```dart
Container(
  padding: EdgeInsets.all(context.wSpacingExt(4)), // 16.0
  child: MyWidget(),
)
```

<a name="programmatic-access"></a>
## Programmatic Access

If you need to access the raw spacing unit or the entire theme configuration, you can use the `windThemeData` extension.

```dart
// Access the base unit directly
final unit = context.windThemeData.baseSpacingUnit; // 4.0

// Use it in complex calculations
double customCalc = (unit * 4) + 2.0;
```

<a name="theme-configuration"></a>
## Theme Configuration

The spacing scale is controlled by the `baseSpacingUnit` property in your `WindThemeData`. Changing this value will globally update both your programmatic spacing and all CSS utility classes (like `p-4`).

```dart
WindTheme(
  data: WindThemeData(
    baseSpacingUnit: 5.0, // 1 unit = 5px
  ),
  child: MyApp(),
)
```

With the above configuration:
- `wSpacing(context, 4)` returns **20.0**
- `WDiv(className: 'p-4')` applies **20.0px** padding.

Related Documentation:
- [Spacing Layout Utilities](../layout/spacing.md)
- [Theming Guide](../core-concepts/theming.md)
- [Context Extensions](./context-extensions.md)
