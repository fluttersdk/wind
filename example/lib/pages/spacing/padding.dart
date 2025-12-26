import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class PaddingExamplePage extends StatelessWidget {
  const PaddingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText(
              "Green border shows the element boundary",
              className: "mb-4 font-bold",
            ),

            WDiv(
              className:
                  "border-2 border-green-500 bg-red-100 mb-4 inline-block",
              children: [WText("p-4", className: "p-4 bg-red-200")],
            ),

            WDiv(
              className:
                  "border-2 border-green-500 bg-blue-100 mb-4 inline-block",
              children: [WText("px-8", className: "px-8 bg-blue-200")],
            ),

            WDiv(
              className:
                  "border-2 border-green-500 bg-green-100 mb-4 inline-block",
              children: [WText("py-8", className: "py-8 bg-green-200")],
            ),

            WDiv(
              className:
                  "border-2 border-green-500 bg-yellow-100 mb-4 inline-block",
              children: [
                WText("pt-8 (Top only)", className: "pt-8 bg-yellow-200"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
