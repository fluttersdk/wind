import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class VisibilityExamplePage extends StatelessWidget {
  const VisibilityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const WText("Visible", className: "p-4 bg-gray-200"),
          const WText("Hidden below:", className: "p-4 bg-gray-300"),
          const WDiv(
            className: "hidden p-4 bg-red-500",
            children: [Text("You should not see me")],
          ),
          const WText("Visible again", className: "p-4 bg-gray-200"),
          // Last class wins check
          const WDiv(
            className: "hidden flex p-4 bg-blue-500",
            children: [Text("I should be visible (hidden flex)")],
          ),
          const WDiv(
            className: "flex hidden p-4 bg-red-500",
            children: [Text("I should be hidden (flex hidden)")],
          ),
        ],
      ),
    );
  }
}
