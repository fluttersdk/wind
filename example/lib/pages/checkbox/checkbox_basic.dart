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
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header with gradient
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-teal-500 to-cyan-500
            ''',
            children: const [
              WText('WCheckbox', className: 'text-lg font-bold text-white'),
              WText(
                'Utility-first checkbox with custom styling',
                className: 'text-sm text-teal-100',
              ),
            ],
          ),

          // Basic checkbox
          _buildSection(
            title: 'Basic Checkbox',
            description: 'Click to toggle checked state',
            children: [
              WDiv(
                className: 'flex gap-4',
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
            ],
          ),

          // Custom colors
          _buildSection(
            title: 'Custom Colors',
            description: 'Use checked:bg-* for different colors',
            children: [
              WDiv(
                className: 'flex gap-4',
                children: [
                  WCheckbox(
                    value: _isChecked3,
                    onChanged: (val) => setState(() => _isChecked3 = val),
                    className: '''
                      w-5 h-5 rounded border border-gray-300
                      items-center justify-center
                      checked:bg-green-500 checked:border-transparent
                    ''',
                  ),
                  WCheckbox(
                    value: _isChecked4,
                    onChanged: (val) => setState(() => _isChecked4 = val),
                    className: '''
                      w-5 h-5 rounded border border-gray-300
                      items-center justify-center
                      checked:bg-red-500 checked:border-transparent
                    ''',
                  ),
                ],
              ),
            ],
          ),

          // Toggle switch
          _buildSection(
            title: 'Toggle Switch Style',
            description: 'Custom toggle using WAnchor + WDiv',
            children: [
              WDiv(
                className: 'flex gap-6',
                children: [
                  _buildToggle(
                    _toggle1,
                    (val) => setState(() => _toggle1 = val),
                  ),
                  _buildToggle(
                    _toggle2,
                    (val) => setState(() => _toggle2 = val),
                  ),
                ],
              ),
            ],
          ),

          // Different sizes
          _buildSection(
            title: 'Sizes',
            description: 'Use w-{n} h-{n} for size',
            children: [
              WDiv(
                className: 'flex items-center gap-4',
                children: [
                  WCheckbox(
                    value: true,
                    onChanged: (_) {},
                    className: '''
                      w-4 h-4 rounded border border-gray-300
                      items-center justify-center
                      checked:bg-blue-500 checked:border-transparent
                    ''',
                    iconClassName: 'text-white text-xs',
                  ),
                  WCheckbox(
                    value: true,
                    onChanged: (_) {},
                    className: '''
                      w-5 h-5 rounded border border-gray-300
                      items-center justify-center
                      checked:bg-blue-500 checked:border-transparent
                    ''',
                    iconClassName: 'text-white text-sm',
                  ),
                  WCheckbox(
                    value: true,
                    onChanged: (_) {},
                    className: '''
                      w-6 h-6 rounded border border-gray-300
                      items-center justify-center
                      checked:bg-blue-500 checked:border-transparent
                    ''',
                    iconClassName: 'text-white text-base',
                  ),
                ],
              ),
            ],
          ),

          // Disabled
          _buildSection(
            title: 'Disabled State',
            description: 'Use disabled prop',
            children: [
              WDiv(
                className: 'flex gap-4',
                children: const [
                  WCheckbox(
                    value: false,
                    disabled: true,
                    className: '''
                      w-5 h-5 rounded border border-gray-200
                      items-center justify-center bg-gray-100
                      disabled:opacity-50
                    ''',
                  ),
                  WCheckbox(
                    value: true,
                    disabled: true,
                    className: '''
                      w-5 h-5 rounded border border-gray-200
                      items-center justify-center
                      checked:bg-blue-300 checked:border-transparent
                      disabled:opacity-50
                    ''',
                  ),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'State Prefixes',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('checked:', 'value = true'),
                  _referenceRow('hover:', 'Mouse over'),
                  _referenceRow('focus:', 'Keyboard focus'),
                  _referenceRow('disabled:', 'disabled = true'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        ...children,
      ],
    );
  }

  Widget _referenceRow(String className, String value) {
    return WDiv(
      className: 'flex justify-between',
      children: [
        WText(
          className,
          className: 'text-sm font-mono text-gray-600 dark:text-gray-300',
        ),
        WText(value, className: 'text-sm text-gray-500 dark:text-gray-400'),
      ],
    );
  }

  Widget _buildToggle(bool value, ValueChanged<bool> onChanged) {
    final Set<String> states = {if (value) 'checked'};

    return WAnchor(
      onTap: () => onChanged(!value),
      states: states,
      child: WDiv(
        className: 'w-12 h-6 rounded-full p-1 bg-gray-300 checked:bg-blue-500',
        states: states,
        children: [
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
