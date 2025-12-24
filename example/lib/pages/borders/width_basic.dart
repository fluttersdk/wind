import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Width Basic Demo - for iframe preview
/// Shows border, border-2, border-4, border-8
class WidthBasicPage extends StatelessWidget {
  const WidthBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: WDiv(
          className: "flex flex-row gap-8 items-center justify-center",
          children: [
            _buildWidthDemo("border", "1px"),
            _buildWidthDemo("border-2", "2px"),
            _buildWidthDemo("border-4", "4px"),
            _buildWidthDemo("border-8", "8px"),
          ],
        ),
      ),
    );
  }

  Widget _buildWidthDemo(String widthClass, String label) {
    return WDiv(
      className: "flex flex-col items-center gap-3",
      children: [
        WText(label, className: "text-xs font-medium text-gray-500"),
        WDiv(
          className: "w-16 h-16 $widthClass border-indigo-500 bg-indigo-100",
        ),
      ],
    );
  }
}
