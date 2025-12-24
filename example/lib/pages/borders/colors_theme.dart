import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Colors Demo - theme colors
class ColorsThemePage extends StatelessWidget {
  const ColorsThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: WDiv(
          className: "flex flex-row gap-4 flex-wrap justify-center",
          children: [
            _buildColorDemo("border-red-500", "Red"),
            _buildColorDemo("border-orange-500", "Orange"),
            _buildColorDemo("border-green-500", "Green"),
            _buildColorDemo("border-blue-500", "Blue"),
            _buildColorDemo("border-purple-500", "Purple"),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDemo(String colorClass, String label) {
    return WDiv(
      className: "flex flex-col items-center gap-2",
      children: [
        WText(label, className: "text-xs font-medium text-gray-500"),
        WDiv(className: "w-12 h-12 border-2 $colorClass rounded-lg bg-white"),
      ],
    );
  }
}
