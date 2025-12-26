import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ButtonBasicExamplePage extends StatefulWidget {
  const ButtonBasicExamplePage({super.key});

  @override
  State<ButtonBasicExamplePage> createState() => _ButtonBasicExamplePageState();
}

class _ButtonBasicExamplePageState extends State<ButtonBasicExamplePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: WDiv(
          className: 'flex flex-col gap-8 w-full items-center',
          children: [
            const WText(
              'Basic Buttons',
              className: 'text-2xl font-bold text-gray-900',
            ),
            const WText(
              'WButton with Tailwind-like className styling',
              className: 'text-gray-500',
            ),

            // Primary Button
            WButton(
              onTap: () => setState(() => _counter++),
              className:
                  'bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium',
              child: const Text('Primary Button'),
            ),

            // Secondary Button
            WButton(
              onTap: () {},
              className:
                  'bg-gray-200 hover:bg-gray-300 text-gray-800 px-6 py-3 rounded-lg font-medium',
              child: const Text('Secondary Button'),
            ),

            // Outline Button
            WButton(
              onTap: () {},
              className:
                  'border-2 border-blue-600 hover:bg-blue-50 text-blue-600 px-6 py-3 rounded-lg font-medium',
              child: const Text('Outline Button'),
            ),

            // Danger Button
            WButton(
              onTap: () {},
              className:
                  'bg-red-500 hover:bg-red-600 text-white px-6 py-3 rounded-lg font-medium',
              child: const Text('Danger Button'),
            ),

            // Counter Display
            WText(
              'Counter: $_counter',
              className: 'text-lg font-semibold text-gray-700',
            ),

            // Code Example
            WDiv(
              className: 'w-full p-4 bg-gray-800 rounded-lg',
              children: const [
                WText('''WButton(
  onTap: () => print('Tapped!'),
  className: 'bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg',
  child: Text('Click Me'),
)''', className: 'text-xs text-white font-mono'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
