import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Input states example demonstrating focus, error, and disabled states.
class InputStatesExamplePage extends StatefulWidget {
  const InputStatesExamplePage({super.key});

  @override
  State<InputStatesExamplePage> createState() => _InputStatesExamplePageState();
}

class _InputStatesExamplePageState extends State<InputStatesExamplePage> {
  String _focusRing = '';
  String _email = '';
  String? _emailError;

  void _validateEmail(String value) {
    if (value.isEmpty) {
      _emailError = null;
    } else {
      final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
      if (!emailRegex.hasMatch(value)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    }
  }

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
              bg-gradient-to-r from-cyan-500 to-blue-500
            ''',
            children: const [
              WText('Input States', className: 'text-lg font-bold text-white'),
              WText(
                'Focus, error, and disabled states',
                className: 'text-sm text-cyan-100',
              ),
            ],
          ),

          // Focus Ring
          _buildSection(
            title: 'Focus Ring',
            description: 'Click input to see focus:ring-* effect',
            children: [
              WInput(
                value: _focusRing,
                onChanged: (value) => setState(() => _focusRing = value),
                placeholder: 'Click to see focus ring',
                className: '''
                  w-full p-3 rounded-lg
                  border border-gray-300 dark:border-gray-600
                  text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                  focus:ring-2 focus:ring-blue-500 focus:border-blue-500
                ''',
              ),
            ],
          ),

          // Error State
          _buildSection(
            title: 'Error State',
            description: 'Type invalid email to see error:* classes',
            children: [
              WInput(
                type: InputType.email,
                value: _email,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                    _validateEmail(value);
                  });
                },
                placeholder: 'Enter email to validate',
                states: _emailError != null ? {'error'} : {},
                className: '''
                  w-full p-3 rounded-lg
                  border border-gray-300 dark:border-gray-600
                  text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                  focus:ring-2 focus:ring-blue-500
                  error:border-red-500 error:ring-red-500
                ''',
              ),
              if (_emailError != null)
                WText(_emailError!, className: 'text-sm text-red-500'),
            ],
          ),

          // Disabled State
          _buildSection(
            title: 'Disabled State',
            description: 'Use enabled: false and disabled:* classes',
            children: [
              const WInput(
                enabled: false,
                value: 'Cannot edit this',
                className: '''
                  w-full p-3 rounded-lg
                  border border-gray-300
                  disabled:bg-gray-100 disabled:text-gray-400
                ''',
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
                  _referenceRow('focus:', 'Input focused'),
                  _referenceRow('error:', 'states: {\'error\'}'),
                  _referenceRow('disabled:', 'enabled: false'),
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
}
