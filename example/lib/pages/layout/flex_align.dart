import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FlexAlignExamplePage extends StatelessWidget {
  const FlexAlignExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText("items-center (h-16)", className: "mb-1 text-xs"),
            WDiv(
              className:
                  "flex items-center bg-gray-100 h-16 w-full mb-4 p-2 rounded gap-2",
              children: [
                WDiv(className: "w-8 h-8 bg-green-500"),
                WDiv(className: "w-8 h-4 bg-green-500"),
                WDiv(className: "w-8 h-12 bg-green-500"),
              ],
            ),
            WText("items-stretch (h-16)", className: "mb-1 text-xs"),
            WDiv(
              className:
                  "flex items-stretch bg-gray-100 h-16 w-full mb-4 p-2 rounded gap-2",
              children: [
                WDiv(className: "w-8 bg-green-500"),
                WDiv(className: "w-8 bg-green-500"),
                WDiv(className: "w-8 bg-green-500"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
