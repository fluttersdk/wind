import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart' as wind;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import 'routes.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate merged colors map
    // We need to cast dynamic values from defaults to MaterialColor
    final Map<String, MaterialColor> mergedColors = {};

    // 1. Add defaults from the package export
    wind.colors.forEach((key, value) {
      if (value is MaterialColor) {
        mergedColors[key] = value;
      } else if (value is Color) {
        // Convert single color to MaterialColor
        // ignore: deprecated_member_use
        mergedColors[key] = MaterialColor(value.value, {
          50: value,
          100: value,
          200: value,
          300: value,
          400: value,
          500: value,
          600: value,
          700: value,
          800: value,
          900: value,
        });
      } else if (value is Map<int, Color>) {
        // Convert Map<int, Color> to MaterialColor
        // Assuming 500 shade exists or using first available
        // ignore: deprecated_member_use
        final int primary = value[500]?.value ?? value.values.first.value;
        mergedColors[key] = MaterialColor(primary, value);
      }
    });

    // 2. Add/Override primary
    mergedColors['primary'] = const MaterialColor(0xff0986e0, {
      50: Color(0xffa5d7fb),
      100: Color(0xff92cffb),
      200: Color(0xff6abdf9),
      300: Color(0xff43acf7),
      400: Color(0xff1c9bf6),
      500: Color(0xff0986e0),
      600: Color(0xff0766aa),
      700: Color(0xff054574),
      800: Color(0xff02253e),
      900: Color(0xff000508),
      950: Color(0xff000000),
    });

    return WindTheme(
      data: WindThemeData(colors: mergedColors),
      child: MaterialApp(
        routes: appRoutes.map(
          (path, pageBuilder) =>
              MapEntry(path, (context) => AppLayout(child: pageBuilder)),
        ),
      ),
    );
  }
}
