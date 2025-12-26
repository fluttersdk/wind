import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class OverflowDirectionalExamplePage extends StatelessWidget {
  const OverflowDirectionalExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _OverflowBox(className: "overflow-x-scroll", label: "x-scroll"),
        _OverflowBox(className: "overflow-y-scroll", label: "y-scroll"),
        _OverflowBox(className: "overflow-x-hidden", label: "x-hidden"),
      ],
    );
  }
}

class _OverflowBox extends StatelessWidget {
  final String className;
  final String label;

  const _OverflowBox({required this.className, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        // Container is 80x80, content is 150x150 = overflow!
        WDiv(
          className: "$className w-20 h-20 bg-gray-100 rounded",
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green.shade900, width: 2),
              ),
              child: const Center(
                child: Text(
                  "150x150",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text("container: 80x80", style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
