import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class GridGapExamplePage extends StatelessWidget {
  const GridGapExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WText("gap-4", className: "mb-2 font-bold"),
              WDiv(
                className: "grid grid-cols-2 gap-4 w-full",
                children: [
                  WDiv(
                    className:
                        "bg-blue-200 h-10 flex items-center justify-center",
                    children: [Text("1")],
                  ),
                  WDiv(
                    className:
                        "bg-blue-200 h-10 flex items-center justify-center",
                    children: [Text("2")],
                  ),
                  WDiv(
                    className:
                        "bg-blue-200 h-10 flex items-center justify-center",
                    children: [Text("3")],
                  ),
                  WDiv(
                    className:
                        "bg-blue-200 h-10 flex items-center justify-center",
                    children: [Text("4")],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
