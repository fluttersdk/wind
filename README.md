# Wind - Utility-First Styling for Flutter

**Wind** enables seamless styling in Flutter by interpreting class names directly in your widget trees, transforming them into optimized designs.

## 🚀 Features
- 🏗 **Utility-First Design** – Inspired by TailwindCSS, apply styles using class names.
- 🎨 **Customizable Themes** – Easily configure fonts, colors, and breakpoints.
- 🌙 **Dark Mode Support** – Built-in support for dynamic dark mode.
- 📱 **Responsive Design** – Define layouts with screen-size breakpoints.
- ⚡ **Optimized for Performance** – Class name parsing for efficient styling.

## 📺 Installation

Add Wind to your Flutter project by running:

```sh
flutter pub add fluttersdk_wind
```

Or manually add it to your `pubspec.yaml`:

```yaml
dependencies:
  fluttersdk_wind: ^0.0.2
```

Then, fetch dependencies:

```sh
flutter pub get
```

## 🛠 Usage

Start using Wind utilities in your Flutter widgets:

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: WindTheme.toThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: WCard(
          className: 'shadow-lg rounded-lg m-4 p-4 bg-black',
          child: WFlex(
            className: 'flex-col axis-min gap-2 items-start',
            children: [
              WText('12', className: 'text-4xl leading-6 font-bold text-white'),
              WText('Active users on the website', className: 'text-white leading-4'),
              WText(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                className: 'text-gray-300 text-xs',
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🎨 Theme Binding (Optional)

You can bind the Wind theme to your Flutter app for consistent design:

```dart
WindTheme.toThemeCallback(
  context,
  primarySwatch: Colors.blue,
  bodyFontString: 'Roboto',
  displayFontString: 'Lobster',
);
```

## 📚 Documentation

For full documentation and examples, visit: **[Wind Docs](https://wind.fluttersdk.com)**

## 🤝 Contributing

We welcome contributions! If you’d like to improve Wind, follow these steps:
1. Fork the repository.
2. Create a new branch: `git checkout -b my-feature`
3. Make your changes and commit: `git commit -m "Add my feature"`
4. Push to your branch: `git push origin my-feature`
5. Submit a pull request.

## 🐝 License

This project is licensed under the **MIT License**.