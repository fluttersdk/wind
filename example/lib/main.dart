// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
// import 'package:mcp_toolkit/mcp_toolkit.dart';  // Requires Dart 3.8.0, temporarily disabled

import 'routes.dart';

void main() {
  usePathUrlStrategy();

  // runZonedGuarded(
  //   () async {
  WidgetsFlutterBinding.ensureInitialized();
  // MCPToolkitBinding.instance
  //   ..initialize() // Initializes the Toolkit
  //   ..initializeFlutterToolkit(); // Adds Flutter related methods to the MCP server

  runApp(const MyApp());
  //   },
  //   (error, stack) {
  //     // You can place it in your error handling tool, or directly in the zone. The most important thing is to have it - otherwise the errors will not be captured and MCP server will not return error results.
  //     MCPToolkitBinding.instance.handleZoneError(error, stack);
  //   },
  // );
}

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.windTheme.toggleTheme(),
        child: const Icon(Icons.brightness_4),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your Wind theme
    final windTheme = WindThemeData(
      colors: {
        'primary': const MaterialColor(0xff0986e0, {
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
        }),
      },
    );

    return WindTheme(
      data: windTheme,
      // Use builder for reactive MaterialApp theme binding
      builder: (context, controller) => MaterialApp(
        // Theme updates automatically when controller.toggleTheme() is called
        theme: controller.toThemeData(),
        routes: appRoutes.map(
          (path, pageBuilder) =>
              MapEntry(path, (context) => AppLayout(child: pageBuilder)),
        ),
      ),
    );
  }
}
