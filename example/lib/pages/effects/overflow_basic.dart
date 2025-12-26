import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class OverflowBasicExamplePage extends StatelessWidget {
  const OverflowBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _OverflowBox(className: "overflow-visible", label: "visible"),
        _OverflowBox(className: "overflow-hidden", label: "hidden"),
        _OverflowBox(className: "overflow-scroll", label: "scroll"),
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
        // Container is 80x80, content is 120x120 = overflow!
        WDiv(
          className: "$className w-20 h-20 bg-gray-100 rounded",
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue.shade900, width: 2),
              ),
              child: const Center(
                child: Text(
                  "120x120",
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
