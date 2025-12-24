import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Arbitrary Colors Demo - hex colors
class ColorsArbitraryPage extends StatelessWidget {
  const ColorsArbitraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: WDiv(
          className: "flex flex-row gap-8 items-center justify-center",
          children: [
            WDiv(
              className: "flex flex-col items-center gap-2",
              children: [
                WText("#FF5733", className: "text-xs text-gray-500"),
                WDiv(
                  className: "w-16 h-16 border-2 border-[#FF5733] rounded-lg",
                ),
              ],
            ),
            WDiv(
              className: "flex flex-col items-center gap-2",
              children: [
                WText("#3498DB", className: "text-xs text-gray-500"),
                WDiv(
                  className: "w-16 h-16 border-2 border-[#3498DB] rounded-lg",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
