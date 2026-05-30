# Customizing Colors

The `WindTheme` class ships a TailwindCSS-inspired color palette and lets you read, extend, and override colors through static helpers.

- [Color Palette](#color-palette)
- [Using Colors](#using-colors)
- [Customizing the Palette](#customizing-the-palette)
- [Working with Colors Programmatically](#working-with-colors-programmatically)
- [Related Documentation](#related-documentation)

```dart
WCard(
  className: 'bg-gray-100 dark:bg-gray-800 rounded-lg items-center justify-center',
  child: WText(
    'Wind colors at a glance.',
    className: 'text-gray-900 dark:text-white',
  ),
);
```

<a name="color-palette"></a>
## Color Palette

The default palette in `WindTheme` includes color families such as `slate`, `gray`, `red`, and `indigo`. Each color is a `MaterialColor` supporting shades from 50 (lightest) to 900 (darkest). The default shade is 500, used when no specific shade is provided (e.g. `bg-indigo` resolves to indigo 500).

| Name | Token |
|:---|:---|
| `slate` | `bg-slate-500` |
| `gray` | `bg-gray-500` |
| `zinc` | `bg-zinc-500` |
| `neutral` | `bg-neutral-500` |
| `stone` | `bg-stone-500` |
| `red` | `bg-red-500` |
| `orange` | `bg-orange-500` |
| `amber` | `bg-amber-500` |
| `yellow` | `bg-yellow-500` |
| `lime` | `bg-lime-500` |
| `green` | `bg-green-500` |
| `emerald` | `bg-emerald-500` |
| `teal` | `bg-teal-500` |
| `cyan` | `bg-cyan-500` |
| `sky` | `bg-sky-500` |
| `blue` | `bg-blue-500` |
| `indigo` | `bg-indigo-500` |
| `violet` | `bg-violet-500` |
| `purple` | `bg-purple-500` |
| `fuchsia` | `bg-fuchsia-500` |
| `pink` | `bg-pink-500` |
| `black` | `bg-black` |
| `white` | `bg-white` |

`primary` (mapped to `indigo`) and `secondary` (mapped to `slate`) are also registered as palette aliases.

<a name="using-colors"></a>
## Using Colors

Palette colors can be used in utility classes or read programmatically.

### Utility Classes

```dart
WCard(
  className: 'bg-gray-100 dark:bg-gray-800 rounded-lg items-center justify-center',
  child: WText(
    'Full width at small screens.',
    className: 'text-black dark:text-white',
  ),
);
```

In this example:

- `bg-gray-100` sets the background to the 100 shade of gray.
- `text-black` sets the text color to black.

### The `wColor` Helper

`wColor` retrieves a color from the palette. If no shade is specified, shade 500 is used. The name may carry an inline shade (`gray-100`) or pass `shade:` explicitly. Under `Brightness.dark`, the optional `darkName` / `darkShade` parameters override the resolved color.

```dart
return Scaffold(
  backgroundColor: wColor('gray-100'), // Background set to gray-100
  body: Center(
    child: Text(
      'Hello, Wind!',
      style: TextStyle(color: wColor('indigo')), // Defaults to indigo-500
    ),
  ),
);
```

<a name="customizing-the-palette"></a>
## Customizing the Palette

Register a custom color with `WindTheme.addColor`.

### 1. Define your `MaterialColor`

```dart
MaterialColor customColor = MaterialColor(0xff123456, {
  50: Color(0xffe3e3e3),
  100: Color(0xffd1d1d1),
  200: Color(0xffb3b3b3),
  300: Color(0xff949494),
  400: Color(0xff767676),
  500: Color(0xff123456), // Primary shade
  600: Color(0xff0e2e42),
  700: Color(0xff091b2c),
  800: Color(0xff050c16),
  900: Color(0xff000000),
});
```

### 2. Add the color to the palette

```dart
WindTheme.addColor('custom', customColor);
```

### 3. Use your custom color

```dart
// Utility class
WText('Hello, Wind!', className: 'text-custom-500');
```

```dart
// wColor helper
Color myCustomShade = wColor('custom-500');
```

<a name="working-with-colors-programmatically"></a>
## Working with Colors Programmatically

`WindTheme` exposes helpers for reading the palette at runtime.

```dart
// Retrieve a MaterialColor by name
MaterialColor indigo = WindTheme.getMaterialColor('indigo');
```

```dart
// Retrieve a specific shade. Defaults to 500 when no shade is provided.
Color indigoShade = WindTheme.getColor('indigo', shade: 300);
```

```dart
// Check whether a color exists in the palette
bool exists = WindTheme.isValidColor('indigo'); // true
bool notExists = WindTheme.isValidColor('random'); // false
```

```dart
// Retrieve every color in the palette
Map<String, MaterialColor> allColors = WindTheme.getColors();
```

<a name="related-documentation"></a>
## Related Documentation
- [Background Color](../backgrounds/background-color.md) — apply palette colors to surfaces
- [Text Color](../typography/text-color.md) — apply palette colors to text
- [Dark Mode](../concepts/dark-mode.md) — automatic color inversion with the `dark:` prefix
