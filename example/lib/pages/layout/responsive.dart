import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ResponsiveExamplePage extends StatelessWidget {
  const ResponsiveExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    String breakpoint = 'sm';
    if (width >= 1536) {
      breakpoint = '2xl';
    } else if (width >= 1280) {
      breakpoint = 'xl';
    } else if (width >= 1024) {
      breakpoint = 'lg';
    } else if (width >= 768) {
      breakpoint = 'md';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WText(
            "Current Width: ${width.toStringAsFixed(1)}",
            className: "mb-1 font-bold",
          ),
          WText(
            "Breakpoint: $breakpoint",
            className: "mb-4 text-sm text-gray-500",
          ),
          WText("Resize the window to see changes:", className: "mb-4"),

          // Hidden on mobile, Flex on MD (768px) and up
          WDiv(
            className:
                "hidden md:flex w-64 h-24 bg-blue-500 text-white items-center justify-center rounded",
            children: [Text("Desktop / Tablet (MD+)")],
          ),

          // Flex on mobile, Hidden on MD and up
          WDiv(
            className:
                "flex md:hidden w-64 h-24 bg-red-500 text-white items-center justify-center rounded",
            children: [Text("Mobile (Small)")],
          ),
        ],
      ),
    );
  }
}
