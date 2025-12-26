import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class InputStyledExamplePage extends StatefulWidget {
  const InputStyledExamplePage({super.key});

  @override
  State<InputStyledExamplePage> createState() => _InputStyledExamplePageState();
}

class _InputStyledExamplePageState extends State<InputStyledExamplePage> {
  String _minimal = '';
  String _filled = '';
  String _rounded = '';
  String _bordered = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: WDiv(
          className: 'flex flex-col gap-8 w-full bg-gray-100',
          children: [
            const WText(
              'Styled Inputs',
              className: 'text-2xl font-bold text-gray-900',
            ),
            const WText(
              'Use Tailwind classes to style your inputs',
              className: 'text-gray-500',
            ),

            // Minimal Style
            _buildExample(
              label: 'Minimal (Underline)',
              child: WInput(
                value: _minimal,
                onChanged: (value) => setState(() => _minimal = value),
                placeholder: 'Minimal input',
                className:
                    'w-full p-3 border-b-2 border-gray-300 text-gray-900',
              ),
            ),

            // Filled Style
            _buildExample(
              label: 'Filled Background',
              child: WInput(
                value: _filled,
                onChanged: (value) => setState(() => _filled = value),
                placeholder: 'Filled input',
                className: 'w-full p-4 bg-gray-100 rounded-lg text-gray-900',
              ),
            ),

            // Rounded Style
            _buildExample(
              label: 'Fully Rounded',
              child: WInput(
                value: _rounded,
                onChanged: (value) => setState(() => _rounded = value),
                placeholder: 'Rounded input',
                className:
                    'w-full px-5 py-3 border border-gray-300 rounded-full text-gray-900',
              ),
            ),

            // Bordered Style
            _buildExample(
              label: 'Thick Border',
              child: WInput(
                value: _bordered,
                onChanged: (value) => setState(() => _bordered = value),
                placeholder: 'Bordered input',
                className:
                    'w-full p-4 border-2 border-blue-500 rounded-xl text-gray-900',
              ),
            ),

            // Code Example
            WDiv(
              className: 'w-full p-4 bg-gray-800 rounded-lg',
              children: const [
                WText('''WInput(
  className: 'w-full p-4 bg-gray-100 rounded-lg',
  placeholder: 'Filled input',
)''', className: 'text-xs text-white font-mono'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExample({required String label, required Widget child}) {
    return WDiv(
      className: 'flex flex-col gap-2 w-full',
      children: [
        WText(label, className: 'text-sm font-semibold text-gray-700'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: child,
        ),
      ],
    );
  }
}
