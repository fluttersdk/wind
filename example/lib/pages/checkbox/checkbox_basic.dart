import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WCheckbox examples with toggle/switch style.
class CheckboxBasicExamplePage extends StatefulWidget {
  const CheckboxBasicExamplePage({super.key});

  @override
  State<CheckboxBasicExamplePage> createState() =>
      _CheckboxBasicExamplePageState();
}

class _CheckboxBasicExamplePageState extends State<CheckboxBasicExamplePage> {
  bool _isChecked1 = false;
  bool _isChecked2 = true;
  bool _isChecked3 = false;
  bool _isChecked4 = true;
  bool _toggle1 = false;
  bool _toggle2 = true;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full w-screen',
      children: [
        // Basic checkbox
        const WText(
          'Basic Checkbox',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: [
            WCheckbox(
              value: _isChecked1,
              onChanged: (val) => setState(() => _isChecked1 = val),
            ),
            WCheckbox(
              value: _isChecked2,
              onChanged: (val) => setState(() => _isChecked2 = val),
            ),
          ],
        ),

        // Custom colors
        const WText(
          'Custom Colors',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: [
            WCheckbox(
              value: _isChecked3,
              onChanged: (val) => setState(() => _isChecked3 = val),
              className:
                  'w-5 h-5 rounded border border-gray-300 items-center justify-center checked:bg-green-500 checked:border-transparent',
            ),
            WCheckbox(
              value: _isChecked4,
              onChanged: (val) => setState(() => _isChecked4 = val),
              className:
                  'w-5 h-5 rounded border border-gray-300 items-center justify-center checked:bg-red-500 checked:border-transparent',
            ),
          ],
        ),

        // Toggle Switch Style
        const WText(
          'Toggle Switch Style',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-6 mb-6',
          children: [
            // Toggle OFF
            _buildToggle(_toggle1, (val) => setState(() => _toggle1 = val)),
            // Toggle ON
            _buildToggle(_toggle2, (val) => setState(() => _toggle2 = val)),
          ],
        ),

        // Different sizes
        const WText(
          'Different Sizes',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-center gap-4 mb-6',
          children: [
            WCheckbox(
              value: true,
              onChanged: (_) {},
              className:
                  'w-4 h-4 rounded border border-gray-300 items-center justify-center checked:bg-blue-500 checked:border-transparent',
              iconClassName: 'text-white text-xs',
            ),
            WCheckbox(
              value: true,
              onChanged: (_) {},
              className:
                  'w-5 h-5 rounded border border-gray-300 items-center justify-center checked:bg-blue-500 checked:border-transparent',
              iconClassName: 'text-white text-sm',
            ),
            WCheckbox(
              value: true,
              onChanged: (_) {},
              className:
                  'w-6 h-6 rounded border border-gray-300 items-center justify-center checked:bg-blue-500 checked:border-transparent',
              iconClassName: 'text-white text-base',
            ),
          ],
        ),

        // Disabled state
        const WText(
          'Disabled State',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4',
          children: const [
            WCheckbox(
              value: false,
              disabled: true,
              className:
                  'w-5 h-5 rounded border border-gray-200 items-center justify-center bg-gray-100 disabled:opacity-50',
            ),
            WCheckbox(
              value: true,
              disabled: true,
              className:
                  'w-5 h-5 rounded border border-gray-200 items-center justify-center checked:bg-blue-300 checked:border-transparent disabled:opacity-50',
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a toggle-style switch
  Widget _buildToggle(bool value, ValueChanged<bool> onChanged) {
    final Set<String> states = {if (value) 'checked'};

    return WAnchor(
      onTap: () => onChanged(!value),
      states: states,
      child: WDiv(
        className: 'w-12 h-6 rounded-full p-1 bg-gray-300 checked:bg-blue-500',
        states: states,
        children: [
          // Sliding knob
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
