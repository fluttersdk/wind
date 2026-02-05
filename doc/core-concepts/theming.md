# Theme Configuration

Wind uses a centralized, immutable theme system to configure all design tokens. You can customize the look and feel of your application by defining values in `WindTheme`.

## Setup

To customize the theme, wrap your app (or a specific subtree) with `WindTheme`.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WindTheme(
      theme: WindThemeData(
        colors: {
          'brand': Colors.indigo, // Automatically generates 50-900 shades
          'accent': Colors.teal,
        },
        baseSpacingUnit: 4.0,
        fontFamilies: {
          'sans': 'Inter',
          'serif': 'Merriweather',
        },
      ),
      child: MaterialApp(
        title: 'My App',
        home: HomePage(),
      ),
    );
  }
}
```

## Configurable Options

### 1. General Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `brightness` | `Brightness` | `light` | Sets theme mode. In `dark`, colors are automatically inverted unless manually overridden. |
| `baseSpacingUnit` | `double` | `4.0` | Base pixel value for spacing utilities (`p-4` = 4 * 4.0 = 16px). |
| `applyDefaultFontFamily` | `bool` | `true` | If true, applies `font-sans` globally via `DefaultTextStyle`. |

### 2. Typography

Define your typographic scale and font families.

```dart
WindThemeData(
  fontFamilies: {
    'sans': 'Roboto',      // Used by default
    'display': 'Oswald',   // Use as font-display
    'mono': 'Fira Code',   // Use as font-mono
  },
  fontSizes: {
    'xs': 12.0,
    'sm': 14.0,
    'base': 16.0,
    'lg': 18.0,
    'xl': 20.0,
    '2xl': 24.0,
    // ...
  },
  fontWeights: {
    'thin': FontWeight.w100,
    'normal': FontWeight.w400,
    'bold': FontWeight.w700,
  },
)
```

### 3. Colors

Wind generates a full Material palette (50-900) from a single `Color`.

```dart
WindThemeData(
  colors: {
    'primary': Color(0xFF3B82F6), // Generates primary-50 to primary-900
    'secondary': Colors.purple,
    'custom': {
      50: Color(0xFFF0F9FF),
      500: Color(0xFF0EA5E9),
      900: Color(0xFF0C4A6E),
    }, // Manual definition
  },
)
```

**Usage:** `bg-primary-500`, `text-secondary-600`, `border-custom-900`

### 4. Spacing & Sizing

Customize breakpoints and spacing logic.

```dart
WindThemeData(
  screens: {
    'sm': 640,
    'md': 768,
    'lg': 1024,
    'xl': 1280,
  },
  // Custom container max-widths per breakpoint
  containers: {
    'sm': 600,
    'md': 720,
    'lg': 960,
    'xl': 1140,
  },
)
```

### 5. Borders & Effects

Fine-tune radii, shadows, and transitions.

```dart
WindThemeData(
  borderRadius: {
    'none': 0,
    'sm': 2,
    'DEFAULT': 4, // Used for 'rounded'
    'md': 6,
    'lg': 8,
    'full': 9999,
  },
  shadows: {
    'sm': [BoxShadow(blurRadius: 2, color: Colors.black12)],
    'DEFAULT': [BoxShadow(blurRadius: 4, color: Colors.black26)],
  },
)
```

## Programmatic Access

Access theme data programmatically using context extensions.

### Reading Values

```dart
// Get raw theme data
final theme = context.windThemeData;

// Get specific resolved values
final primaryColor = theme.getColor('primary', 500);
final padding = theme.getSpacing('4'); // 16.0
final isDark = context.windIsDark;
```

### Modifying Theme (Runtime)

Use the controller to toggle or update the theme dynamically.

```dart
// Toggle Dark/Light Mode
context.windTheme.toggleTheme();

// Update Theme
context.windTheme.updateTheme(
  colors: {'primary': Colors.red},
);
```

## Default Theme Reference

Wind comes pre-configured with a default theme inspired by Tailwind CSS v3.

- **Colors:** Full Tailwind palette (Slate, Gray, Zinc, Neutral, Stone, Red, Orange, Amber, Yellow, Lime, Green, Emerald, Teal, Cyan, Sky, Blue, Indigo, Violet, Purple, Fuchsia, Pink, Rose).
- **Screens:** `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), `2xl` (1536px).
- **Spacing:** Base unit is `4.0` pixels.

## Integration

To ensure seamless integration with standard Flutter widgets, you can bind your Wind theme to Flutter's `ThemeData`. This allows standard Material widgets to automatically reflect your Wind configuration.

Learn more in the [Theme Binding](./theme-binding.md) guide.
