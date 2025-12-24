import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TypographyColorsPage extends StatelessWidget {
  const TypographyColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WText(
                "text-red-500",
                className: "text-red-500 text-xl font-bold p-2",
              ),
              WText(
                "text-blue-500",
                className: "text-blue-500 text-xl font-bold p-2",
              ),
              WText(
                "text-green-500",
                className: "text-green-500 text-xl font-bold p-2",
              ),
              WText(
                "text-[#FF00FF] (Arbitrary)",
                className: "text-[#FF00FF] text-xl font-bold p-2",
              ),
              WAnchor(
                onTap: () {},
                child: WText(
                  "text-blue-500 (Hover me)",
                  className:
                      "text-gray-500 hover:text-blue-500 text-xl font-bold p-2",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
