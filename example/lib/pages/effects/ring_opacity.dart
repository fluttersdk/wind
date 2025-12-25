import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class RingOpacityExamplePage extends StatelessWidget {
  const RingOpacityExamplePage({super.key});

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
              _RingBox(className: "ring-4 ring-blue-500/100", label: "100%"),
              _RingBox(className: "ring-4 ring-blue-500/75", label: "75%"),
              _RingBox(className: "ring-4 ring-blue-500/50", label: "50%"),
              _RingBox(className: "ring-4 ring-blue-500/25", label: "25%"),
              _RingBox(className: "ring-4 ring-blue-500/10", label: "10%"),
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
          "$className w-24 h-24 bg-white rounded-lg flex items-center justify-center",
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Opacity",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
