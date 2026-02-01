import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BasicExamplePage extends StatelessWidget {
  const BasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: "w-full h-full flex items-center justify-center bg-gray-100 dark:bg-gray-900 p-4",
      child: WDiv(
        className: "w-48 h-48 p-4 bg-white rounded-xl shadow-lg flex items-center justify-center dark:bg-slate-800",
        child: WText(
          "Hello World",
          className: "text-lg font-bold text-black dark:text-white",
        ),
      ),
    );
  }
}
