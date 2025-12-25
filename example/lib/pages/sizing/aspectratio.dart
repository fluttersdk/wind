import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class AspectRatioExamplePage extends StatelessWidget {
  const AspectRatioExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WDiv(
        className: "flex justify-evenly gap-4",
        children: [
          _AspectBox(
            className: "aspect-square",
            label: "square (1:1)",
            color: "blue",
            width: 80,
          ),
          _AspectBox(
            className: "aspect-video",
            label: "video (16:9)",
            color: "red",
            width: 120,
          ),
          _AspectBox(
            className: "aspect-[4/3]",
            label: "4:3",
            color: "green",
            width: 100,
          ),
        ],
      ),
    );
  }
}

class _AspectBox extends StatelessWidget {
  final String className;
  final String label;
  final String color;
  final double width;

  const _AspectBox({
    required this.className,
    required this.label,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        SizedBox(
          width: width,
          child: WDiv(
            className: "$className bg-$color-500 rounded-lg",
            children: const [
              Center(
                child: Text(
                  "Content",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
