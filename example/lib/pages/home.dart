import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: "flex flex-col gap-4 p-6 bg-gray-100",
      children: [
        WDiv(
          // 1 column on mobile (default), 3 columns on 'md' and up
          className: "grid grid-cols-1 md:grid-cols-3 gap-4",
          children: [
            WDiv(className: "bg-red-200 h-24"),
            WDiv(className: "bg-green-200 h-24"),
            WDiv(className: "bg-blue-200 h-24"),
          ],
        ),
        WText("Title", className: "text-xl font-bold"),
        WText("Description text...", className: "text-gray-600"),
        WAnchor(
          onTap: () {}, // print("Home page built");
          child: WDiv(
            // Hover state: changes background and shadow
            className:
                "bg-blue-500 hover:bg-blue-600 text-white p-4 rounded shadow hover:shadow-lg transition",
            child: WText("Click Me"),
          ),
        ),
      ],
    );
  }
}
