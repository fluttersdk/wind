import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WKeyboardActionsBasicExamplePage extends StatefulWidget {
  const WKeyboardActionsBasicExamplePage({super.key});

  @override
  State<WKeyboardActionsBasicExamplePage> createState() =>
      _WKeyboardActionsBasicExamplePageState();
}

class _WKeyboardActionsBasicExamplePageState
    extends State<WKeyboardActionsBasicExamplePage> {
  // 1. One FocusNode per field so WKeyboardActions can navigate between them.
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _amountFocus = FocusNode();

  // 2. Track which platform mode the demo showcases.
  String _platform = 'all';

  static const _inputCls = '''
    w-full px-3 py-2 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    text-slate-900 dark:text-slate-100
    focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
  ''';

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WKeyboardActions',
      description:
          'Adds a Done button and field navigation toolbar above the keyboard for numeric and text inputs.',
      gradient: 'from-violet-500 to-purple-600',
      children: [
        ExampleSection(
          title: 'Basic Form',
          description:
              'Wrap any group of inputs with WKeyboardActions and pass a FocusNode for each field. '
              'The toolbar shows Previous/Next arrows and a Done button while any field is focused.',
          child: WKeyboardActions(
            focusNodes: [
              _nameFocus,
              _emailFocus,
              _amountFocus,
            ],
            toolbarClassName: 'bg-slate-100 dark:bg-slate-800',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildField(
                  label: 'Full Name',
                  placeholder: 'Jane Doe',
                  focusNode: _nameFocus,
                ),
                _buildField(
                  label: 'Email Address',
                  placeholder: 'jane@example.com',
                  focusNode: _emailFocus,
                  type: InputType.email,
                ),
                _buildField(
                  label: 'Invoice Amount',
                  placeholder: '0.00',
                  focusNode: _amountFocus,
                  type: InputType.number,
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Platform Targeting',
          description:
              'Use platform: "ios" so the toolbar only appears on iOS, where the numeric keyboard '
              'has no built-in Done button. Choose a value below to see how the prop changes behavior.',
          child: WDiv(
            className: 'flex flex-col gap-4',
            children: [
              WDiv(
                className: 'flex flex-row gap-2 flex-wrap',
                children: [
                  for (final p in ['all', 'ios', 'android'])
                    WButton(
                      onTap: () => setState(() => _platform = p),
                      className: _platform == p
                          ? 'px-4 py-2 rounded-lg bg-violet-600 text-white text-sm font-medium'
                          : '''
                              px-4 py-2 rounded-lg text-sm font-medium
                              bg-slate-100 dark:bg-slate-700
                              text-slate-700 dark:text-slate-300
                              border border-slate-200 dark:border-slate-600
                            ''',
                      child: WText(
                        'platform: "$p"',
                        className: _platform == p
                            ? 'text-white text-sm font-medium'
                            : 'text-slate-700 dark:text-slate-300 text-sm font-medium',
                      ),
                    ),
                ],
              ),
              WKeyboardActions(
                platform: _platform,
                focusNodes: [_nameFocus],
                toolbarClassName: 'bg-violet-50 dark:bg-violet-900',
                child: _buildField(
                  label: 'Quantity',
                  placeholder: '1',
                  focusNode: _nameFocus,
                  type: InputType.number,
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Custom Close Button',
          description:
              'Supply closeWidgetBuilder to replace the default "Done" label with any widget. '
              'The builder receives the currently-focused FocusNode so you can call unfocus() on it.',
          child: WKeyboardActions(
            focusNodes: [_emailFocus, _amountFocus],
            toolbarClassName: 'bg-emerald-50 dark:bg-emerald-900',
            closeWidgetBuilder: (node) => WButton(
              onTap: node.unfocus,
              className: '''
                bg-emerald-600 hover:bg-emerald-700
                text-white px-4 py-1.5 rounded-md text-sm font-medium
              ''',
              child: const WText(
                'Dismiss',
                className: 'text-white text-sm font-medium',
              ),
            ),
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildField(
                  label: 'Email',
                  placeholder: 'contractor@example.com',
                  focusNode: _emailFocus,
                  type: InputType.email,
                ),
                _buildField(
                  label: 'Hours Logged',
                  placeholder: '8',
                  focusNode: _amountFocus,
                  type: InputType.number,
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Navigation Disabled',
          description:
              'Set nextFocus: false to remove the Previous/Next arrow buttons from the toolbar '
              'and show only the Done button.',
          child: WKeyboardActions(
            focusNodes: [_nameFocus],
            nextFocus: false,
            toolbarClassName: 'bg-amber-50 dark:bg-amber-900',
            child: _buildField(
              label: 'Promo Code',
              placeholder: 'WIND2025',
              focusNode: _nameFocus,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required String placeholder,
    required FocusNode focusNode,
    InputType type = InputType.text,
  }) {
    return WDiv(
      className: 'flex flex-col gap-1',
      children: [
        WText(
          label,
          className: 'text-sm font-medium text-slate-700 dark:text-slate-300',
        ),
        WInput(
          focusNode: focusNode,
          placeholder: placeholder,
          type: type,
          className: _inputCls,
        ),
      ],
    );
  }
}
