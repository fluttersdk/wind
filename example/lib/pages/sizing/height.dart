import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class HeightExamplePage extends StatelessWidget {
  const HeightExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            WDiv(
              className:
                  "h-32 bg-red-200 w-full mb-2 flex items-center justify-center",
              children: [Text("h-32")],
            ),
            Expanded(
              child: WDiv(
                className:
                    "h-full bg-blue-200 w-full flex items-center justify-center",
                children: [Text("h-full (inside expanded)")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
