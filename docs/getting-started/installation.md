# Installation

Wind is available as a Flutter package. Since it relies on Dart-based utility parsing, it works with any Flutter project.

## Requirements

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher

## Adding Wind to your project

Add `fluttersdk_wind` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  fluttersdk_wind: ^1.0.0
```

Then run:

```bash
flutter pub get
```

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

Now you can start using `WDiv` and `WText` anywhere in your app!
