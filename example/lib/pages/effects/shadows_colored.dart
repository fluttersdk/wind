import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ShadowsColoredExamplePage extends StatelessWidget {
  const ShadowsColoredExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ShadowBox(
                className: "shadow-xl shadow-blue-500",
                label: "shadow-blue-500",
              ),
              SizedBox(height: 32),
              _ShadowBox(
                className: "shadow-xl shadow-red-500",
                label: "shadow-red-500",
              ),
              SizedBox(height: 32),
              _ShadowBox(
                className: "shadow-xl shadow-[#1da1f2]",
                label: "shadow-[#1da1f2]",
              ),
            ],
          ),
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
