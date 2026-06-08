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
                className:
                    "bg-blue-500 dark:bg-blue-600 hover:bg-blue-700 dark:hover:bg-blue-800 px-6 py-3 rounded-lg",
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
                    "bg-white dark:bg-slate-800 border border-gray-300 dark:border-gray-600 focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 px-6 py-3 rounded-lg",
                children: const [
                  WText(
                    "Click to focus",
                    className: "text-gray-700 dark:text-gray-200 font-medium",
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
                        "bg-green-500 dark:bg-green-600 hover:bg-green-700 dark:hover:bg-green-800 px-6 py-3 rounded-lg",
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
                        "bg-green-500 dark:bg-green-600 disabled:bg-gray-400 dark:disabled:bg-gray-600 px-6 py-3 rounded-lg",
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
                    "bg-purple-500 dark:bg-purple-600 hover:bg-purple-700 dark:hover:bg-purple-800 hover:shadow-lg px-6 py-3 rounded-lg duration-300",
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
