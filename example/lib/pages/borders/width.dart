import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Width Example Page
class BorderWidthPage extends StatelessWidget {
  const BorderWidthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: WDiv(
        className: "flex flex-col gap-8 p-8",
        children: [
          WText("Border Width", className: "text-2xl font-bold text-gray-900"),
          WText(
            "Utilities for controlling the width of an element's borders.",
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
                    className:
                        "flex flex-row gap-8 items-center justify-center",
                    children: [
                      _buildWidthDemo("border", "1px"),
                      _buildWidthDemo("border-2", "2px"),
                      _buildWidthDemo("border-4", "4px"),
                      _buildWidthDemo("border-8", "8px"),
                    ],
                  ),
                ],
              ),
              WDiv(
                className: "bg-gray-900 rounded-lg p-4 mt-2",
                children: [
                  WText(
                    'WDiv(className: "border border-indigo-500 ...")',
                    className: "text-sky-300 text-sm",
                  ),
                  WText(
                    'WDiv(className: "border-2 border-indigo-500 ...")',
                    className: "text-sky-300 text-sm",
                  ),
                  WText(
                    'WDiv(className: "border-4 border-indigo-500 ...")',
                    className: "text-sky-300 text-sm",
                  ),
                  WText(
                    'WDiv(className: "border-8 border-indigo-500 ...")',
                    className: "text-sky-300 text-sm",
                  ),
                ],
              ),
            ],
          ),

          // Directional borders
          WText(
            "Individual Sides",
            className: "text-xl font-semibold text-gray-900 mt-4",
          ),
          WDiv(
            className: "flex flex-row gap-8 items-center justify-center",
            children: [
              _buildSideDemo("border-t-4", "Top"),
              _buildSideDemo("border-r-4", "Right"),
              _buildSideDemo("border-b-4", "Bottom"),
              _buildSideDemo("border-l-4", "Left"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidthDemo(String widthClass, String label) {
    return WDiv(
      className: "flex flex-col items-center gap-3",
      children: [
        WText(label, className: "text-xs font-medium text-gray-500"),
        WDiv(
          className: "w-16 h-16 $widthClass border-indigo-500 bg-indigo-100",
        ),
      ],
    );
  }

  Widget _buildSideDemo(String borderClass, String label) {
    return WDiv(
      className: "flex flex-col items-center gap-3",
      children: [
        WText(label, className: "text-xs font-medium text-gray-500"),
        WDiv(
          className: "w-16 h-16 $borderClass border-indigo-500 bg-indigo-100",
        ),
      ],
    );
  }
}
