import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Radius Basic Demo - for iframe preview
/// Shows rounded-sm, rounded-md, rounded-lg, rounded-xl
class RadiusBasicPage extends StatelessWidget {
  const RadiusBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: WDiv(
          className: "flex flex-row gap-8 items-center justify-center",
          children: [
            _buildRadiusDemo("rounded-sm"),
            _buildRadiusDemo("rounded-md"),
            _buildRadiusDemo("rounded-lg"),
            _buildRadiusDemo("rounded-xl"),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusDemo(String radiusClass) {
    return WDiv(
      className: "flex flex-col items-center gap-3",
      children: [
        WText(radiusClass, className: "text-xs font-medium text-gray-500"),
        WDiv(className: "w-16 h-16 $radiusClass bg-purple-500"),
      ],
    );
  }
}
