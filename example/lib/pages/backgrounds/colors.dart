import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BackgroundColorsPage extends StatelessWidget {
  const BackgroundColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText("bg-red-500", className: "bg-red-500 p-4 mb-2 text-white"),
            WText(
              "bg-[#1da1f2]",
              className: "bg-[#1da1f2] p-4 mb-2 text-white",
            ),
            WText("Opacities:", className: "font-bold mt-4 mb-2"),
            WText(
              "bg-red-500/50",
              className: "bg-red-500/50 p-4 mb-2 text-black",
            ),
            WText(
              "bg-blue-500/[0.2]",
              className: "bg-blue-500/[0.2] p-4 mb-2 text-black",
            ),
          ],
        ),
      ),
    );
  }
}
