import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class OpacityExamplePage extends StatelessWidget {
  const OpacityExamplePage({super.key});

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
              _OpacityBox(className: "opacity-100", label: "100%"),
              SizedBox(height: 16),
              _OpacityBox(className: "opacity-75", label: "75%"),
              SizedBox(height: 16),
              _OpacityBox(className: "opacity-50", label: "50%"),
              SizedBox(height: 16),
              _OpacityBox(className: "opacity-25", label: "25%"),
              SizedBox(height: 16),
              _OpacityBox(className: "opacity-0", label: "0%"),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpacityBox extends StatelessWidget {
  final String className;
  final String label;

  const _OpacityBox({required this.className, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          "$className w-32 h-32 bg-blue-500 rounded-lg flex items-center justify-center",
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
