import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class MarginExamplePage extends StatelessWidget {
  const MarginExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText(
              "Margin creates space OUTSIDE the element (Yellow Box)",
              className: "mb-4 font-bold text-center",
            ),

            WDiv(
              className: "bg-yellow-200 border-2 border-yellow-400 mb-4",
              children: [
                WText(
                  "m-4 (16px all sides)",
                  className: "m-4 bg-red-200 p-2 text-center text-white",
                ),
              ],
            ),
            WDiv(
              className: "bg-yellow-200 border-2 border-yellow-400 mb-4",
              children: [
                WText(
                  "mx-8 (32px horizontal)",
                  className: "mx-8 bg-blue-200 p-2 text-center text-white",
                ),
              ],
            ),
            WDiv(
              className: "bg-yellow-200 border-2 border-yellow-400 mb-4",
              children: [
                WText(
                  "my-4 (16px vertical)",
                  className: "my-4 bg-green-200 p-2 text-center text-white",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
