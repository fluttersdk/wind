import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FlexGrowExamplePage extends StatelessWidget {
  const FlexGrowExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WText("flex-1 (grow)", className: "mb-1 text-xs"),
            WDiv(
              className: "flex bg-gray-100 mb-4 p-2 gap-2",
              children: [
                WDiv(
                  className:
                      "w-10 h-10 bg-blue-500 flex items-center justify-center",
                  children: [Text("Fixed")],
                ),
                WDiv(
                  className:
                      "flex-1 h-10 bg-purple-500 flex items-center justify-center",
                  children: [Text("Flex-1")],
                ),
                WDiv(
                  className:
                      "w-10 h-10 bg-blue-500 flex items-center justify-center",
                  children: [Text("Fixed")],
                ),
              ],
            ),

            WText("flex-none (no grow)", className: "mb-1 text-xs"),
            WDiv(
              className: "flex bg-gray-100 mb-4 p-2 gap-2",
              children: [
                WDiv(
                  className:
                      "flex-none w-32 h-10 bg-blue-500 flex items-center justify-center",
                  children: [Text("Flex-None")],
                ),
                WDiv(
                  className:
                      "flex-1 h-10 bg-purple-500 flex items-center justify-center",
                  children: [Text("Flex-1")],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
