import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class GridBasicExamplePage extends StatelessWidget {
  const GridBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              WText("Grid Cols 3", className: "p-2 font-bold"),
              WDiv(
                className: "grid grid-cols-3 gap-2 p-4 bg-gray-100",
                children: [
                  WDiv(
                    className:
                        "h-20 bg-purple-500 flex items-center justify-center",
                    children: [Text("1")],
                  ),
                  WDiv(
                    className:
                        "h-20 bg-purple-500 flex items-center justify-center",
                    children: [Text("2")],
                  ),
                  WDiv(
                    className:
                        "h-20 bg-purple-500 flex items-center justify-center",
                    children: [Text("3")],
                  ),
                  WDiv(
                    className:
                        "h-20 bg-purple-500 flex items-center justify-center",
                    children: [Text("4")],
                  ),
                  WDiv(
                    className:
                        "h-20 bg-purple-500 flex items-center justify-center",
                    children: [Text("5")],
                  ),
                  WDiv(
                    className:
                        "h-20 bg-purple-500 flex items-center justify-center",
                    children: [Text("6")],
                  ),
                ],
              ),
              WText("Grid Cols 2 Gap 4", className: "p-2 font-bold mt-4"),
              WDiv(
                className: "grid grid-cols-2 gap-4 p-4 bg-gray-100",
                children: [
                  WDiv(className: "h-20 bg-orange-500"),
                  WDiv(className: "h-20 bg-orange-500"),
                  WDiv(className: "h-20 bg-orange-500"),
                  WDiv(className: "h-20 bg-orange-500"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
