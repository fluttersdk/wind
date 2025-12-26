import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ShadowsBasicExamplePage extends StatelessWidget {
  const ShadowsBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ShadowBox(className: "shadow-sm", label: "shadow-sm"),
            SizedBox(height: 32),
            _ShadowBox(className: "shadow", label: "shadow"),
            SizedBox(height: 32),
            _ShadowBox(className: "shadow-md", label: "shadow-md"),
            SizedBox(height: 32),
            _ShadowBox(className: "shadow-lg", label: "shadow-lg"),
            SizedBox(height: 32),
            _ShadowBox(className: "shadow-xl", label: "shadow-xl"),
            SizedBox(height: 32),
            _ShadowBox(className: "shadow-2xl", label: "shadow-2xl"),
          ],
        ),
      ),
    );
  }
}

class _ShadowBox extends StatelessWidget {
  final String className;
  final String label;

  const _ShadowBox({required this.className, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          "$className w-32 h-32 bg-white rounded-lg flex items-center justify-center text-sm font-medium text-gray-500",
      children: [Text(label)],
    );
  }
}
