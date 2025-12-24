import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Radius Example Page - Tailwind Style Demo
class BorderBasicPage extends StatelessWidget {
  const BorderBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: WDiv(
        className: "flex flex-col gap-8 p-8",
        children: [
          // Title
          WText("Border Radius", className: "text-2xl font-bold text-gray-900"),
          WText(
            "Utilities for controlling the border radius of an element.",
            className: "text-gray-600",
          ),

          // Demo Section
          WDiv(
            className: "rounded-xl bg-gray-100 p-4",
            children: [
              // Visual Demo
              WDiv(
                className: "bg-white rounded-lg p-8",
                children: [
                  WDiv(
                    className:
                        "flex flex-row gap-8 items-center justify-center",
                    children: [
                      _buildRadiusDemo("rounded-sm"),
                      _buildRadiusDemo("rounded-md"),
                      _buildRadiusDemo("rounded-lg"),
                      _buildRadiusDemo("rounded-xl"),
                    ],
                  ),
                ],
              ),
              // Code Preview
              WDiv(
                className: "bg-gray-900 rounded-lg p-4 mt-2",
                children: [
                  WText(
                    'WDiv(className: "rounded-sm ...")',
                    className: "text-sky-300 text-sm",
                  ),
                  WText(
                    'WDiv(className: "rounded-md ...")',
                    className: "text-sky-300 text-sm",
                  ),
                  WText(
                    'WDiv(className: "rounded-lg ...")',
                    className: "text-sky-300 text-sm",
                  ),
                  WText(
                    'WDiv(className: "rounded-xl ...")',
                    className: "text-sky-300 text-sm",
                  ),
                ],
              ),
            ],
          ),

          // More sizes
          WText(
            "All Sizes",
            className: "text-xl font-semibold text-gray-900 mt-4",
          ),
          WDiv(
            className: "flex flex-row flex-wrap gap-6 items-end",
            children: [
              _buildRadiusDemo("rounded-none"),
              _buildRadiusDemo("rounded-sm"),
              _buildRadiusDemo("rounded"),
              _buildRadiusDemo("rounded-md"),
              _buildRadiusDemo("rounded-lg"),
              _buildRadiusDemo("rounded-xl"),
              _buildRadiusDemo("rounded-2xl"),
              _buildRadiusDemo("rounded-3xl"),
              _buildRadiusDemo("rounded-full"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusDemo(String radiusClass) {
    return WDiv(
      className: "flex flex-col items-center gap-3",
      children: [
        WText(radiusClass, className: "text-xs font-medium text-gray-500"),
        WDiv(className: "w-16 h-16 $radiusClass bg-purple-500"),
      ],
    );
  }
}
