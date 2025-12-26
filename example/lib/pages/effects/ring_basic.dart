import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class RingBasicExamplePage extends StatelessWidget {
  const RingBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Wrap(
          spacing: 32,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: [
            _RingBox(className: "ring-0 ring-blue-500", label: "ring-0"),
            _RingBox(className: "ring-1 ring-blue-500", label: "ring-1"),
            _RingBox(className: "ring-2 ring-blue-500", label: "ring-2"),
            _RingBox(className: "ring ring-blue-500", label: "ring"),
            _RingBox(className: "ring-4 ring-blue-500", label: "ring-4"),
            _RingBox(className: "ring-8 ring-blue-500", label: "ring-8"),
          ],
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
          "$className w-24 h-24 bg-white rounded-lg flex items-center justify-center text-sm font-medium text-gray-600",
      children: [Text(label)],
    );
  }
}
