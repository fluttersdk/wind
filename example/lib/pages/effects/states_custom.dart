import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class StatesCustomExamplePage extends StatefulWidget {
  const StatesCustomExamplePage({super.key});

  @override
  State<StatesCustomExamplePage> createState() =>
      _StatesCustomExamplePageState();
}

class _StatesCustomExamplePageState extends State<StatesCustomExamplePage> {
  bool isLoading = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom "loading" State
              const Text(
                "Custom 'loading' State",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() => isLoading = !isLoading);
                },
                child: WDiv(
                  className:
                      "bg-blue-500 loading:bg-gray-400 px-6 py-3 rounded-lg",
                  states: isLoading ? {'loading'} : {},
                  children: [
                    WText(
                      isLoading ? "Loading..." : "Click to toggle loading",
                      className: "text-white font-medium",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "isLoading: $isLoading",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 32),

              // Custom "selected" State
              const Text(
                "Custom 'selected' State",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() => isSelected = !isSelected);
                },
                child: WDiv(
                  className:
                      "bg-white border-2 border-gray-300 selected:border-blue-500 selected:bg-blue-50 px-6 py-3 rounded-lg",
                  states: isSelected ? {'selected'} : {},
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        WText(
                          isSelected ? "Selected" : "Click to select",
                          className: isSelected
                              ? "text-blue-600 font-medium"
                              : "text-gray-600 font-medium",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "isSelected: $isSelected",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 32),

              // Code Example
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '''WDiv(
  className: "bg-blue-500 loading:bg-gray-400",
  states: isLoading ? {'loading'} : {},
  children: [...],
)''',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
