import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class InputBasicExamplePage extends StatefulWidget {
  const InputBasicExamplePage({super.key});

  @override
  State<InputBasicExamplePage> createState() => _InputBasicExamplePageState();
}

class _InputBasicExamplePageState extends State<InputBasicExamplePage> {
  String _text = '';
  String _email = '';
  String _password = '';
  String _number = '';
  String _multiline = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: WDiv(
        className: 'flex flex-col gap-6 w-full p-6',
        children: [
          const WText(
            'Input Types',
            className: 'text-2xl font-bold text-gray-900',
          ),
          const WText(
            'Different input types with React-style controlled state',
            className: 'text-gray-500',
          ),
          const SizedBox(height: 8),

          // Text Input
          _buildInputRow(
            label: 'Text Input',
            value: _text,
            child: WInput(
              value: _text,
              onChanged: (value) => setState(() => _text = value),
              placeholder: 'Enter text',
              className:
                  'w-full p-3 border border-gray-300 rounded-lg text-gray-900',
            ),
          ),

          // Email Input
          _buildInputRow(
            label: 'Email Input',
            value: _email,
            child: WInput(
              type: InputType.email,
              value: _email,
              onChanged: (value) => setState(() => _email = value),
              placeholder: 'name@example.com',
              className:
                  'w-full p-3 border border-gray-300 rounded-lg text-gray-900',
            ),
          ),

          // Password Input
          _buildInputRow(
            label: 'Password Input',
            value: _password.isNotEmpty ? '•' * _password.length : '',
            child: WInput(
              type: InputType.password,
              value: _password,
              onChanged: (value) => setState(() => _password = value),
              placeholder: 'Enter password',
              className:
                  'w-full p-3 border border-gray-300 rounded-lg text-gray-900',
            ),
          ),

          // Number Input
          _buildInputRow(
            label: 'Number Input',
            value: _number,
            child: WInput(
              type: InputType.number,
              value: _number,
              onChanged: (value) => setState(() => _number = value),
              placeholder: '0',
              className:
                  'w-full p-3 border border-gray-300 rounded-lg text-gray-900',
            ),
          ),

          // Multiline Input
          _buildInputRow(
            label: 'Multiline (Textarea)',
            value: _multiline,
            child: WInput(
              type: InputType.multiline,
              value: _multiline,
              onChanged: (value) => setState(() => _multiline = value),
              placeholder: 'Enter your message...',
              minLines: 3,
              maxLines: 6,
              className:
                  'w-full p-3 border border-gray-300 rounded-lg text-gray-900',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required String label,
    required String value,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2 w-full',
      children: [
        WText(label, className: 'text-sm font-medium text-gray-700'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: child,
        ),
        if (value.isNotEmpty)
          WText('Value: $value', className: 'text-xs text-gray-400'),
      ],
    );
  }
}
