import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TypographyBasicsPage extends StatelessWidget {
  const TypographyBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WText("text-xs / font-thin", className: "text-xs font-thin p-2"),
            WText("text-sm / font-light", className: "text-sm font-light p-2"),
            WText(
              "text-base / font-normal",
              className: "text-base font-normal p-2",
            ),
            WText(
              "text-lg / font-medium",
              className: "text-lg font-medium p-2",
            ),
            WText(
              "text-xl / font-semibold",
              className: "text-xl font-semibold p-2",
            ),
            WText("text-2xl / font-bold", className: "text-2xl font-bold p-2"),
            WText(
              "text-3xl / font-extrabold",
              className: "text-3xl font-extrabold p-2",
            ),
            WText(
              "text-4xl / font-black",
              className: "text-4xl font-black p-2",
            ),
          ],
        ),
      ),
    );
  }
}
