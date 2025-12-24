import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Sides Demo - border-t, border-b
class WidthSidesPage extends StatelessWidget {
  const WidthSidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: WDiv(
          className: "flex flex-row gap-8 items-center justify-center",
          children: [
            _buildSideDemo("border-t-4", "Top"),
            _buildSideDemo("border-r-4", "Right"),
            _buildSideDemo("border-b-4", "Bottom"),
            _buildSideDemo("border-l-4", "Left"),
          ],
        ),
      ),
    );
  }

  Widget _buildSideDemo(String borderClass, String label) {
    return WDiv(
      className: "flex flex-col items-center gap-3",
      children: [
        WText(label, className: "text-xs font-medium text-gray-500"),
        WDiv(
          className: "w-16 h-16 $borderClass border-indigo-500 bg-indigo-100",
        ),
      ],
    );
  }
}
