import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BackgroundGradientsPage extends StatelessWidget {
  const BackgroundGradientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WDiv(
              className:
                  "h-32 w-64 bg-gradient-to-r from-cyan-500 to-blue-500 mb-4 rounded-lg flex items-center justify-center",
              children: [
                Text(
                  "To Right (Cyan -> Blue)",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            WDiv(
              className:
                  "h-32 w-64 bg-gradient-to-b from-yellow-400 via-orange-500 to-red-500 mb-4 rounded-lg flex items-center justify-center",
              children: [
                Text(
                  "To Bottom (Yellow -> Orange -> Red)",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            WDiv(
              className:
                  "h-32 w-64 bg-gradient-to-tr from-purple-500 to-pink-500 mb-4 rounded-lg flex items-center justify-center",
              children: [
                Text("To Top Right", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
