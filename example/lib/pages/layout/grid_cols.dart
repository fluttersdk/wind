import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class GridColsExamplePage extends StatelessWidget {
  const GridColsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText("grid-cols-3", className: "mb-2 font-bold"),
            WDiv(
              className: "grid grid-cols-3 gap-2 w-full",
              children: [
                WDiv(
                  className: "bg-red-200 h-10 flex items-center justify-center",
                  children: [Text("1")],
                ),
                WDiv(
                  className: "bg-red-200 h-10 flex items-center justify-center",
                  children: [Text("2")],
                ),
                WDiv(
                  className: "bg-red-200 h-10 flex items-center justify-center",
                  children: [Text("3")],
                ),
                WDiv(
                  className: "bg-red-200 h-10 flex items-center justify-center",
                  children: [Text("4")],
                ),
                WDiv(
                  className: "bg-red-200 h-10 flex items-center justify-center",
                  children: [Text("5")],
                ),
                WDiv(
                  className: "bg-red-200 h-10 flex items-center justify-center",
                  children: [Text("6")],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
