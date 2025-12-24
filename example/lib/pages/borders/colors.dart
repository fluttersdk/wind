import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Colors Example Page
class BorderColorsPage extends StatelessWidget {
  const BorderColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: WDiv(
        className: "flex flex-col gap-8 p-8",
        children: [
          WText("Border Color", className: "text-2xl font-bold text-gray-900"),
          WText(
            "Utilities for controlling the color of an element's borders.",
            className: "text-gray-600",
          ),

          // Demo Section
          WDiv(
            className: "rounded-xl bg-gray-100 p-4",
            children: [
              WDiv(
                className: "bg-white rounded-lg p-8",
                children: [
                  WDiv(
                    className: "flex flex-row gap-4 flex-wrap justify-center",
                    children: [
                      _buildColorDemo("border-red-500", "Red"),
                      _buildColorDemo("border-orange-500", "Orange"),
                      _buildColorDemo("border-yellow-500", "Yellow"),
                      _buildColorDemo("border-green-500", "Green"),
                      _buildColorDemo("border-blue-500", "Blue"),
                      _buildColorDemo("border-indigo-500", "Indigo"),
                      _buildColorDemo("border-purple-500", "Purple"),
                      _buildColorDemo("border-pink-500", "Pink"),
                    ],
                  ),
                ],
              ),
              WDiv(
                className: "bg-gray-900 rounded-lg p-4 mt-2",
                children: [
                  WText(
                    'WDiv(className: "border-2 border-red-500 ...")',
                    className: "text-sky-300 text-sm",
                  ),
                  WText(
                    'WDiv(className: "border-2 border-blue-500 ...")',
                    className: "text-sky-300 text-sm",
                  ),
                ],
              ),
            ],
          ),

          // Arbitrary colors
          WText(
            "Arbitrary Colors",
            className: "text-xl font-semibold text-gray-900 mt-4",
          ),
          WDiv(
            className: "flex flex-row gap-4 items-center",
            children: [
              WDiv(
                className: "flex flex-col items-center gap-2",
                children: [
                  WText("#FF5733", className: "text-xs text-gray-500"),
                  WDiv(
                    className: "w-16 h-16 border-2 border-[#FF5733] rounded-lg",
                  ),
                ],
              ),
              WDiv(
                className: "flex flex-col items-center gap-2",
                children: [
                  WText("#3498DB", className: "text-xs text-gray-500"),
                  WDiv(
                    className: "w-16 h-16 border-2 border-[#3498DB] rounded-lg",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorDemo(String colorClass, String label) {
    return WDiv(
      className: "flex flex-col items-center gap-2",
      children: [
        WText(label, className: "text-xs font-medium text-gray-500"),
        WDiv(className: "w-12 h-12 border-2 $colorClass rounded-lg bg-white"),
      ],
    );
  }
}
