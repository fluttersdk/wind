# Installation

Wind is available as a Flutter package. Since it relies on Dart-based utility parsing, it works with any Flutter project.

<x-preview path="examples/showcase"></x-preview>

## Requirements

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher

## Adding Wind to your project

The fastest way to add Wind is via the Flutter CLI:

```bash
flutter pub add fluttersdk_wind
```

Alternatively, you can manually add it to your `pubspec.yaml`:

```yaml
dependencies:
  fluttersdk_wind: ^1.0.0
```

Then run `flutter pub get` to install.

## Setup

Wind works out of the box without complex setup. However, to unlock the full power of theming and responsiveness, wrap your application in `WindTheme`.

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      theme: WindThemeData(
        colors: {
          'primary': Colors.indigo,
          'secondary': Colors.teal,
        },
      ),
      child: MaterialApp(
        title: 'Wind Demo',
        home: const HomePage(),
      ),
    );
  }
}
```

Now you can start using `WDiv`, `WText`, and other Wind widgets anywhere in your app!

## Next Steps

- **[Theme Configuration](../core-concepts/theming.md):** Learn how to customize colors, typography, and spacing.
- **[Utility-First Fundamentals](../core-concepts/utility-first.md):** Understand the core philosophy and syntax.
- **[Responsive Design](../core-concepts/responsive-design.md):** Build layouts that adapt to any screen size.
