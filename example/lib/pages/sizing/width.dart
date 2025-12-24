import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WidthExamplePage extends StatelessWidget {
  const WidthExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity, // Force full width for the page
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WText(
                "Parent is full width (Screen width)",
                className: "p-4 font-bold text-center",
              ),

              // w-32 in a full width column (via stretch) might be stretched?
              // No, WText/WDiv might respect w- class if present?
              // If WDiv has w-32, it sets width: 32.
              // If Column stretches, it forces width?
              // Column stretch forces width constraint to be tight.
              // Use Align or Center to allow child to have its own size.
              Center(
                child: WText(
                  "w-32 (128px)",
                  className: "w-32 bg-red-200 mb-2 block text-center",
                ),
              ),
              Center(
                child: WText(
                  "w-1/2 (50% of screen)",
                  className: "w-1/2 bg-blue-200 mb-2 block text-center",
                ),
              ),

              // w-full
              WText(
                "w-full (100% of screen)",
                className: "w-full bg-green-200 mb-2 block text-center",
              ),

              Center(
                child: WText(
                  "max-w-[200px]",
                  className:
                      "max-w-[200px] w-full bg-yellow-200 mb-2 block text-center",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
