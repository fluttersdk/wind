import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FlexBasicExamplePage extends StatelessWidget {
  const FlexBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            WText("Flex Row (default)", className: "p-2 font-bold"),
            WDiv(
              className: "flex gap-2 p-4 bg-gray-100",
              children: [
                WDiv(className: "w-10 h-10 bg-blue-500"),
                WDiv(className: "w-10 h-10 bg-blue-500"),
                WDiv(className: "w-10 h-10 bg-blue-500"),
              ],
            ),
            WText("Flex Column", className: "p-2 font-bold"),
            WDiv(
              className: "flex flex-col gap-2 p-4 bg-gray-100",
              children: [
                WDiv(className: "w-10 h-10 bg-green-500"),
                WDiv(className: "w-10 h-10 bg-green-500"),
                WDiv(className: "w-10 h-10 bg-green-500"),
              ],
            ),
            WText("Justify Between", className: "p-2 font-bold"),
            WDiv(
              className: "flex justify-between p-4 bg-gray-100",
              children: [
                WDiv(className: "w-10 h-10 bg-red-500"),
                WDiv(className: "w-10 h-10 bg-red-500"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
