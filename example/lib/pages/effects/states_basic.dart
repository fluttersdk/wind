import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class StatesBasicExamplePage extends StatelessWidget {
  const StatesBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hover Example
            const Text(
              "Hover States",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            WAnchor(
              onTap: () {},
              child: WDiv(
                className: "bg-blue-500 hover:bg-blue-700 px-6 py-3 rounded-lg",
                children: const [
                  WText("Hover me", className: "text-white font-medium"),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Focus Example (with Ring)
            const Text(
              "Focus States with Ring",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            WAnchor(
              onTap: () {},
              child: WDiv(
                className:
                    "bg-white border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 px-6 py-3 rounded-lg",
                children: const [
                  WText(
                    "Click to focus",
                    className: "text-gray-700 font-medium",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Disabled Example
            const Text(
              "Disabled States",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WAnchor(
                  onTap: () {},
                  child: WDiv(
                    className:
                        "bg-green-500 hover:bg-green-700 px-6 py-3 rounded-lg",
                    children: const [
                      WText("Enabled", className: "text-white font-medium"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                WAnchor(
                  onTap: null, // Disabled
                  child: WDiv(
                    className:
                        "bg-green-500 disabled:bg-gray-400 px-6 py-3 rounded-lg",
                    children: const [
                      WText("Disabled", className: "text-white font-medium"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Combined States
            const Text(
              "Combined Hover + Transition",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            WAnchor(
              onTap: () {},
              child: WDiv(
                className:
                    "bg-purple-500 hover:bg-purple-700 hover:shadow-lg px-6 py-3 rounded-lg duration-300",
                children: const [
                  WText(
                    "Smooth transition",
                    className: "text-white font-medium",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
