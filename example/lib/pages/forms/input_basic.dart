import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WInput example with different input types.
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
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header with gradient
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-violet-500 to-purple-500
            ''',
            children: const [
              WText('WInput', className: 'text-lg font-bold text-white'),
              WText(
                'Utility-first input with controlled state',
                className: 'text-sm text-violet-100',
              ),
            ],
          ),

          // Text Input
          _buildSection(
            title: 'Text Input',
            description: 'Basic text input',
            children: [
              WInput(
                value: _text,
                onChanged: (value) => setState(() => _text = value),
                placeholder: 'Enter text',
                className: '''
                  w-full p-3 border border-gray-300 dark:border-gray-600
                  rounded-lg text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                ''',
              ),
              if (_text.isNotEmpty)
                WText('Value: $_text', className: 'text-xs text-gray-400'),
            ],
          ),

          // Email Input
          _buildSection(
            title: 'Email Input',
            description: 'Email keyboard type',
            children: [
              WInput(
                type: InputType.email,
                value: _email,
                onChanged: (value) => setState(() => _email = value),
                placeholder: 'name@example.com',
                className: '''
                  w-full p-3 border border-gray-300 dark:border-gray-600
                  rounded-lg text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                ''',
              ),
            ],
          ),

          // Password Input
          _buildSection(
            title: 'Password Input',
            description: 'Obscured text entry',
            children: [
              WInput(
                type: InputType.password,
                value: _password,
                onChanged: (value) => setState(() => _password = value),
                placeholder: 'Enter password',
                className: '''
                  w-full p-3 border border-gray-300 dark:border-gray-600
                  rounded-lg text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                ''',
              ),
            ],
          ),

          // Number Input
          _buildSection(
            title: 'Number Input',
            description: 'Numeric keyboard',
            children: [
              WInput(
                type: InputType.number,
                value: _number,
                onChanged: (value) => setState(() => _number = value),
                placeholder: '0',
                className: '''
                  w-full p-3 border border-gray-300 dark:border-gray-600
                  rounded-lg text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                ''',
              ),
            ],
          ),

          // Multiline Input
          _buildSection(
            title: 'Multiline (Textarea)',
            description: 'Multiple lines with minLines/maxLines',
            children: [
              WInput(
                type: InputType.multiline,
                value: _multiline,
                onChanged: (value) => setState(() => _multiline = value),
                placeholder: 'Enter your message...',
                minLines: 3,
                maxLines: 6,
                className: '''
                  w-full p-3 border border-gray-300 dark:border-gray-600
                  rounded-lg text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                ''',
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Input Types',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('text', 'Standard text'),
                  _referenceRow('password', 'Obscured'),
                  _referenceRow('email', 'Email keyboard'),
                  _referenceRow('number', 'Numeric keyboard'),
                  _referenceRow('multiline', 'Multiple lines'),
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
