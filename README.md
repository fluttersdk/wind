# Wind v1 - Utility-First Styling for Flutter

**Wind** is a utility-first styling framework for Flutter, inspired by TailwindCSS. Build beautiful, responsive UIs using simple class names directly in your widget trees.

## 🚀 What's New in v1

Wind v1 is a **complete architectural rewrite** with a new parsing engine, widget system, and theme management.

### Major Changes from v0

- **New Widget System**: `WDiv`, `WText`, `WInput`, `WAnchor` replace old widgets
- **Intelligent Composition**: Widgets dynamically build optimal Flutter widget trees
- **Specialist Parsers**: Modular parsing engine with 7 dedicated parsers
- **State-based Styling**: Built-in `hover:`, `focus:`, `disabled:` and custom states (`loading:`, `active:`)
- **Color Opacity**: Support for `/50` opacity modifier on all colors
- **Ring Utilities**: Tailwind-like focus rings with `ring-2`, `ring-offset`, `ring-inset`
- **Platform Prefixes**: `ios:`, `android:`, `web:`, `mobile:` modifiers
- **CSS-like Text Inheritance**: Text styles cascade through `DefaultTextStyle`

## 📦 Installation

```yaml
dependencies:
  fluttersdk_wind: ^1.0.0
```

```sh
flutter pub get
```

## 🛠 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(),
      child: MaterialApp(
        home: Scaffold(
          body: WDiv(
            className: 'flex flex-col gap-4 p-6 bg-gray-100',
            children: [
              WText('Hello Wind!', className: 'text-2xl font-bold text-blue-600'),
              WText('Utility-first styling for Flutter', className: 'text-gray-500'),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 📚 Core Widgets

### WDiv - The Container Widget

```dart
// Flex layout
WDiv(
  className: 'flex flex-row gap-4 p-4 bg-white rounded-lg',
  children: [...],
)

// Grid layout
WDiv(
  className: 'grid grid-cols-3 gap-4',
  children: [...],
)

// Single child
WDiv(
  className: 'w-full h-screen bg-blue-500',
  child: WText('Full screen'),
)
```

### WText - The Typography Widget

```dart
WText(
  'Styled Text',
  className: 'text-xl font-bold text-red-500 uppercase underline',
)
```

### WIcon, WImage, WSvg - Media Widgets

```dart
// Icon with tailwind sizing/color
WIcon(Icons.star, className: 'text-yellow-500 text-3xl')

// Image with object-fit and aspect-ratio
WImage(
  src: 'https://via.placeholder.com/150',
  className: 'w-full aspect-video object-cover rounded-xl',
)

// SVG with fill/stroke control
WSvg(
  src: 'assets/logo.svg',
  className: 'fill-blue-600 w-12 h-12',
)
```

### WInput - The Form Input Widget

```dart
WInput(
  value: _email,
  onChanged: (value) => setState(() => _email = value),
  type: InputType.email,
  placeholder: 'Enter email',
  className: 'p-3 border rounded-lg focus:ring-2 focus:ring-blue-500',
  placeholderClassName: 'text-gray-400',
)
```

### WCheckbox & WSelect - Selection Controls

```dart
// Utility-first Checkbox
WCheckbox(
  value: _isChecked,
  onChanged: (v) => setState(() => _isChecked = v),
  className: 'w-5 h-5 rounded checked:bg-blue-500 checked:border-transparent',
)

// Searchable Dropdown
WSelect<String>(
  value: _selected,
  options: [
    SelectOption(label: 'Flutter', value: 'flutter'),
    SelectOption(label: 'React', value: 'react'),
  ],
  onChange: (val) => setState(() => _selected = val),
  className: 'w-full p-2 border rounded',
  searchable: true,
)
```

### WAnchor - The Interactive Widget

```dart
WAnchor(
  onTap: () => print('Tapped!'),
  child: WDiv(
    className: 'bg-blue-500 hover:bg-blue-600 p-4 rounded',
    child: WText('Click me', className: 'text-white'),
  ),
)
```

## 🎨 Supported Utilities

### Layout
`flex`, `grid`, `block`, `wrap`, `hidden`, `flex-row`, `flex-col`, `justify-center`, `items-center`, `gap-4`

### Sizing
`w-full`, `h-screen`, `w-1/2`, `min-w-0`, `max-w-lg`, `w-[200px]`, `aspect-square`, `aspect-video`

### Spacing
`p-4`, `px-2`, `py-3`, `m-4`, `mx-auto`, `mt-8`

### Typography
`text-lg`, `font-bold`, `font-sans`, `font-serif`, `text-red-500`, `uppercase`, `underline`, `truncate`

### Background
`bg-blue-500`, `bg-[#FF5733]`, `bg-red-500/50`, `bg-[url(...)]`, `bg-cover`, `bg-center`

### Borders & Effects
`border`, `border-2`, `border-red-500/50`, `rounded-lg`, `shadow-md`, `shadow-blue-500/20`, `opacity-75`, `ring-2`, `ring-blue-500/50`, `ring-offset-2`

### Transitions & Animations
`duration-300`, `duration-500`, `ease-in`, `ease-out`, `animate-spin`, `animate-pulse`, `animate-bounce`, `animate-ping`

### Responsive
`sm:`, `md:`, `lg:`, `xl:`, `2xl:`

### State
`hover:`, `focus:`, `disabled:`, `loading:`, `selected:`, `custom:`

### Dark Mode
`dark:`

### Platform
`ios:`, `android:`, `web:`, `mobile:`

## 🌙 Dark Mode

```dart
WindTheme(
  data: WindThemeData(brightness: Brightness.dark),
  child: MaterialApp(...),
)
```

Use `dark:` prefix for dark-mode-only styles:

```dart
WDiv(className: 'bg-white dark:bg-gray-900')
```

### Toggle Theme at Runtime

```dart
// Toggle between light/dark
WindTheme.of(context).toggleTheme();
// or
context.windTheme.toggleTheme();
```

For reactive `MaterialApp.theme` updates, use the `builder` pattern:

```dart
WindTheme(
  data: windTheme,
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(), // Auto-updates on toggle
    home: MyHomePage(),
  ),
)
```

## 📱 Responsive Design

```dart
WDiv(
  className: 'flex flex-col md:flex-row gap-4',
  children: [
    WDiv(className: 'w-full md:w-1/2', child: ...),
    WDiv(className: 'w-full md:w-1/2', child: ...),
  ],
)
```

## 🎯 Custom Theme

```dart
WindTheme(
  data: WindThemeData(
    colors: {
      'primary': MaterialColor(0xFF0986E0, {
        50: Color(0xFFA5D7FB),
        100: Color(0xFF92CFFB),
        // ... more shades
        500: Color(0xFF0986E0),
        900: Color(0xFF000508),
      }),
    },
    baseSpacingUnit: 4.0,
  ),
  child: MaterialApp(...),
)
```

## 🛠 Helper Functions & Extensions

Access theme values and utilities programmatically:

```dart
// BuildContext extensions
Color primary = context.windColors['primary']!;
bool isDark = context.windIsDark;
bool isDesktop = context.wScreenIs('lg');

// Helper functions
double spacing = wSpacing(context, 4); // 16.0
Color red = wColor(context, 'red', 500)!;
```

## 📚 Documentation

For full documentation and examples, visit: **[wind.fluttersdk.com](https://wind.fluttersdk.com)**

## 🤝 Contributing

1. Fork the repository
2. Create a new branch: `git checkout -b my-feature`
3. Make your changes and commit: `git commit -m "Add my feature"`
4. Push to your branch: `git push origin my-feature`
5. Submit a pull request

## 📄 License

This project is licensed under the **MIT License**.
