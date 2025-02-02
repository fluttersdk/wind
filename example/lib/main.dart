import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  WindTheme.addColor(
      'primary',
      MaterialColor(0xff0986e0, {
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
      }));

  runApp(MyApp(
    appCallback: (context) {
      return MaterialApp(
        title: 'Wind Demo',
        theme: WindTheme.toThemeCallback(context),
        home: Scaffold(
            backgroundColor: wColor('white'),
            body: WFlexContainer(
              className: 'w-full h-full justify-center flex-col items-center bg-gray-200',
              children: [
                WText('Welcome to wind.',
                    className: 'text-primary-500 text-5xl font-bold text-center'),
                WText('Made with ❤️ by Anılcan Çakır',
                    className: 'text-gray-500 text-center'),
              ],
            )
        ),
      );
    },
  ));
}

class MyApp extends StatelessWidget {
  final Widget Function(BuildContext) appCallback;

  const MyApp({super.key, required this.appCallback});

  @override
  Widget build(BuildContext context) {
    return appCallback(context);
  }
}
