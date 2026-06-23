import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class InputBasicExamplePage extends StatefulWidget {
  const InputBasicExamplePage({super.key});

  @override
  State<InputBasicExamplePage> createState() => _InputBasicExamplePageState();
}

class _InputBasicExamplePageState extends State<InputBasicExamplePage> {
  String _email = '';
  bool _hasError = false;

  // Realistic prefilled text for the selection demo.
  static const _selectionSample =
      'Order #ORD-20240614 was shipped to 42 Maple Street, Portland OR 97201. '
      'Expected delivery: Monday 17 June. Tracking: 1Z999AA10123456784.';

  static const _inputCls = '''
    w-full px-3 py-2 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
    error:border-red-500 error:ring-2 error:ring-red-500/30
  ''';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WInput',
      description:
          'Utility-styled text input. value + onChanged for controlled state, type for keyboard mode, prefix/suffix for adornments. focus: / error: prefixes activate automatically.',
      gradient: 'from-blue-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Controlled email field. focus:border-blue-500 fires when the field gains focus.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WInput(
                value: _email,
                onChanged: (v) => setState(() => _email = v),
                type: InputType.email,
                placeholder: 'you@example.com',
                className: _inputCls,
              ),
              WText(
                'Typed: ${_email.isEmpty ? "—" : _email}',
                className:
                    'text-sm text-slate-500 dark:text-slate-400 font-mono',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Input Types',
          description:
              'type changes the keyboard and obfuscation. text, email, password, number.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WInput(
                type: InputType.text,
                placeholder: 'text — default',
                className: _inputCls,
              ),
              WInput(
                type: InputType.email,
                placeholder: 'email — email keyboard',
                className: _inputCls,
              ),
              WInput(
                type: InputType.password,
                placeholder: 'password — obscured',
                className: _inputCls,
              ),
              WInput(
                type: InputType.number,
                placeholder: 'number — numeric keyboard',
                className: _inputCls,
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Error State',
          description:
              'states: {"error"} activates error: prefix. Toggle the button to see.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WInput(
                states: _hasError ? const {'error'} : const {},
                placeholder: 'Enter your name',
                className: _inputCls,
              ),
              if (_hasError)
                WText(
                  'This field is required',
                  className: 'text-sm text-red-600 dark:text-red-400',
                ),
              WButton(
                onTap: () => setState(() => _hasError = !_hasError),
                className:
                    'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg self-start',
                child: WText(
                  _hasError ? 'Clear error' : 'Trigger error state',
                  className: 'text-white font-medium',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Text Selection',
          description:
              'Mouse-drag to select a range, double-click to select a word, '
              'or long-press on mobile for platform-adaptive handles. '
              'The field is read-only so the value stays intact while you explore.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WInput(
                readOnly: true,
                value: _selectionSample,
                className: '''
                  w-full px-3 py-2 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-slate-300 dark:border-slate-600
                  text-slate-800 dark:text-slate-200
                  focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
                ''',
              ),
              WDiv(
                className: '''
                  flex flex-row items-start gap-2 px-3 py-2 rounded-lg
                  bg-blue-50 dark:bg-blue-950
                  border border-blue-200 dark:border-blue-800
                ''',
                children: [
                  WIcon(
                    Icons.info_outline_rounded,
                    className:
                        'text-blue-500 dark:text-blue-400 w-4 h-4 mt-0.5',
                  ),
                  WDiv(
                    className: 'flex flex-col gap-1',
                    children: [
                      WText(
                        'Native text selection',
                        className:
                            'text-sm font-semibold text-blue-700 dark:text-blue-300',
                      ),
                      WText(
                        'Desktop / web: drag to select, double-click for a word, Ctrl+A for all. '
                        'Mobile: long-press for handles, then drag.',
                        className: 'text-xs text-blue-600 dark:text-blue-400',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Disabled vs Read-only',
          description:
              'disabled = uninteractive + dimmed. readOnly = focusable but value locked.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WInput(
                enabled: false,
                value: 'disabled value',
                className: '$_inputCls '
                    'disabled:bg-slate-100 dark:disabled:bg-slate-900 '
                    'disabled:text-slate-400 dark:disabled:text-slate-500 '
                    'disabled:border-slate-200 dark:disabled:border-slate-700',
              ),
              WInput(
                readOnly: true,
                value: 'read-only value',
                className: '$_inputCls '
                    'readonly:bg-slate-100 dark:readonly:bg-slate-800 '
                    'readonly:text-slate-500 dark:readonly:text-slate-400',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
