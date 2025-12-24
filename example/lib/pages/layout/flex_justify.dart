import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FlexJustifyExamplePage extends StatelessWidget {
  const FlexJustifyExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WText("justify-start", className: "mb-1 text-xs"),
              WDiv(
                className: "flex justify-start bg-gray-100 mb-2 p-2 rounded",
                children: [Box(), Box(), Box()],
              ),
              WText("justify-center", className: "mb-1 text-xs"),
              WDiv(
                className: "flex justify-center bg-gray-100 mb-2 p-2 rounded",
                children: [Box(), Box(), Box()],
              ),
              WText("justify-between", className: "mb-1 text-xs"),
              WDiv(
                className: "flex justify-between bg-gray-100 mb-2 p-2 rounded",
                children: [Box(), Box(), Box()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  const Box({super.key});

  @override
  Widget build(BuildContext context) {
    return const WDiv(className: "w-8 h-8 bg-purple-500 rounded");
  }
}
