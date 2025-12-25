import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class RingColorsExamplePage extends StatelessWidget {
  const RingColorsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: [
              _RingBox(className: "ring-4 ring-red-500", label: "ring-red-500"),
              _RingBox(
                className: "ring-4 ring-green-500",
                label: "ring-green-500",
              ),
              _RingBox(
                className: "ring-4 ring-blue-500",
                label: "ring-blue-500",
              ),
              _RingBox(
                className: "ring-4 ring-yellow-500",
                label: "ring-yellow-500",
              ),
              _RingBox(
                className: "ring-4 ring-purple-500",
                label: "ring-purple-500",
              ),
              _RingBox(
                className: "ring-4 ring-[#1da1f2]",
                label: "ring-[#1da1f2]",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingBox extends StatelessWidget {
  final String className;
  final String label;

  const _RingBox({required this.className, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          "$className w-28 h-24 bg-white rounded-lg flex items-center justify-center text-xs font-medium text-gray-600",
      children: [Text(label, textAlign: TextAlign.center)],
    );
  }
}
