import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TypographyAlignmentPage extends StatelessWidget {
  const TypographyAlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WText("text-left", className: "text-left bg-gray-200 p-2 mb-2"),
          WText("text-center", className: "text-center bg-gray-200 p-2 mb-2"),
          WText("text-right", className: "text-right bg-gray-200 p-2 mb-2"),
          WText(
            "text-justify: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            className: "text-justify bg-gray-200 p-2 mb-2",
          ),
        ],
      ),
    );
  }
}
