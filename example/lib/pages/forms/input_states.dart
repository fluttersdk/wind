import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

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
      // Basic email regex for demonstration
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: WDiv(
            className: 'flex flex-col gap-8 w-full',
            children: [
              const WText(
                'Focus & Validation States',
                className: 'text-2xl font-bold text-gray-900',
              ),
              const WText(
                'WInput supports custom states like error, success via the states prop',
                className: 'text-gray-500',
              ),

              // Focus Ring Example
              WDiv(
                className: 'flex flex-col gap-2 w-full',
                children: [
                  const WText(
                    'Focus Ring',
                    className: 'text-sm font-medium text-gray-700',
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: WInput(
                      value: _focusRing,
                      onChanged: (value) => setState(() => _focusRing = value),
                      placeholder: 'Click to see focus ring',
                      className:
                          'w-full p-3 border border-gray-300 rounded-lg text-gray-900 focus:ring-2 focus:ring-blue-500 focus:border-blue-500',
                    ),
                  ),
                ],
              ),

              // Validation/Error State Example
              WDiv(
                className: 'flex flex-col gap-2 w-full',
                children: [
                  const WText(
                    'Email Validation (Error State)',
                    className: 'text-sm font-medium text-gray-700',
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: WInput(
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
                      className:
                          'w-full p-3 border border-gray-300 rounded-lg text-gray-900 focus:ring-2 focus:ring-blue-500 error:border-red-500 error:ring-red-500',
                    ),
                  ),
                  if (_emailError != null)
                    WText(_emailError!, className: 'text-sm text-red-500'),
                ],
              ),

              // Disabled State
              WDiv(
                className: 'flex flex-col gap-2 w-full',
                children: [
                  const WText(
                    'Disabled State',
                    className: 'text-sm font-medium text-gray-700',
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: const WInput(
                      enabled: false,
                      value: 'Cannot edit this',
                      className:
                          'w-full p-3 border border-gray-300 rounded-lg disabled:bg-gray-100 disabled:text-gray-400',
                    ),
                  ),
                ],
              ),

              // Code Example
              WDiv(
                className: 'w-full p-4 bg-gray-800 rounded-lg',
                children: const [
                  WText(
                    '''// Error state with custom states prop
WInput(
  value: _email,
  onChanged: (v) => setState(() {
    _email = v;
    _emailError = validate(v);
  }),
  states: _emailError != null ? {'error'} : {},
  className: '''
                    '''
    border border-gray-300 rounded-lg
    error:border-red-500 error:ring-red-500
  '''
                    ''',
)''',
                    className: 'text-xs text-white font-mono',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
