import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TypographyDecorationPage extends StatelessWidget {
  const TypographyDecorationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText("underline", className: "underline text-xl p-2"),
            WText("line-through", className: "line-through text-xl p-2"),
            WText("overline", className: "overline text-xl p-2"),
            WText("no-underline", className: "no-underline text-xl p-2"),
            WText(
              "decoration-red-500 underline",
              className: "underline decoration-red-500 text-xl p-2",
            ),
            WText(
              "decoration-wavy underline",
              className: "underline decoration-wavy text-xl p-2",
            ),
            WText(
              "decoration-2 underline",
              className: "underline decoration-2 text-xl p-2",
            ),
          ],
        ),
      ),
    );
  }
}
