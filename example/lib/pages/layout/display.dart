import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DisplayExamplePage extends StatelessWidget {
  const DisplayExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText("block (default)", className: "block p-4 bg-red-200 mb-2"),
            // Hidden elements shouldn't take space/render
            WDiv(
              className: "hidden p-4 bg-blue-200 mb-2",
              children: [Text("I am hidden")],
            ),
            WDiv(
              className: "flex p-4 bg-green-200 mb-2 gap-2",
              children: [Text("Item 1"), Text("Item 2")],
            ),
            WDiv(
              className: "grid p-4 bg-purple-200 mb-2 gap-2",
              children: [Text("Grid 1"), Text("Grid 2")],
            ),
          ],
        ),
      ),
    );
  }
}
