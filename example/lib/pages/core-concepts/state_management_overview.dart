import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class StateManagementOverviewExamplePage extends StatefulWidget {
  const StateManagementOverviewExamplePage({super.key});

  @override
  State<StateManagementOverviewExamplePage> createState() =>
      _StateManagementOverviewExamplePageState();
}

class _StateManagementOverviewExamplePageState
    extends State<StateManagementOverviewExamplePage> {
  bool _isSelected = false;
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'State Management',
      description:
          'Declarative interactive styles. State prefixes like hover:, focus:, active:, and disabled: react to user input without manual gesture handling.',
      gradient: 'from-cyan-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'WButton swaps background colors through three states. duration-200 smooths the transition.',
          child: WButton(
            onTap: () {},
            className: '''
              bg-blue-500 hover:bg-blue-600 active:bg-blue-700
              text-white px-4 py-3 rounded-lg duration-200 self-start
            ''',
            child: const WText('Save Changes',
                className: 'text-white font-medium'),
          ),
        ),
        ExampleSection(
          title: 'Built-in State Prefixes',
          description:
              'Four prefixes activate automatically when used inside an interactive widget (WButton, WAnchor, WInput).',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-2 gap-3',
            children: const [
              _PrefixCard(
                prefix: 'hover:',
                trigger: 'Pointer enters bounds',
                useCase: 'Change background or elevation on desktop.',
              ),
              _PrefixCard(
                prefix: 'focus:',
                trigger: 'Widget receives focus',
                useCase: 'Show a ring or border on inputs.',
              ),
              _PrefixCard(
                prefix: 'active:',
                trigger: 'Pointer pressed',
                useCase: 'Scale down or darken a button on tap.',
              ),
              _PrefixCard(
                prefix: 'disabled:',
                trigger: 'Interactivity off',
                useCase: 'Reduce opacity or grey out actions.',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'WAnchor: The Core Wrapper',
          description:
              'Wraps any subtree to make it interactive. No visual styling itself; it propagates state to descendants.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                p-6 rounded-xl duration-300
                bg-white dark:bg-slate-800
                hover:bg-slate-50 dark:hover:bg-slate-700
                border border-slate-200 dark:border-slate-700
              ''',
              children: const [
                WText('Interactive Card',
                    className: 'font-semibold text-slate-900 dark:text-white'),
                WText('Hover anywhere on this card; the bg eases over 300ms.',
                    className:
                        'text-sm text-slate-600 dark:text-slate-400 mt-1'),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'WButton: The High-Level Action',
          description:
              'WButton extends WAnchor with loading states, padding defaults, and an isDisabled prop that activates the disabled: prefix.',
          child: WDiv(
            className: 'wrap gap-3',
            children: [
              WButton(
                onTap: _isDisabled ? null : () {},
                disabled: _isDisabled,
                className: '''
                  bg-indigo-600 hover:bg-indigo-700
                  disabled:opacity-50 disabled:bg-slate-400
                  text-white px-6 py-3 rounded duration-150
                ''',
                child:
                    const WText('Submit', className: 'text-white font-medium'),
              ),
              WButton(
                onTap: () => setState(() => _isDisabled = !_isDisabled),
                className: '''
                  bg-slate-200 hover:bg-slate-300
                  dark:bg-slate-700 dark:hover:bg-slate-600
                  px-4 py-3 rounded
                ''',
                child: WText(
                  _isDisabled ? 'Enable' : 'Disable',
                  className: 'text-slate-700 dark:text-slate-200 font-medium',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'WInput: Focus States',
          description:
              'Inputs manage their own focus. focus: classes activate when the field gains keyboard focus.',
          child: WInput(
            placeholder: 'Search...',
            className: '''
              w-full px-3 py-2 rounded-lg
              bg-white dark:bg-slate-800
              border border-gray-300 dark:border-gray-600
              focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20
            ''',
          ),
        ),
        ExampleSection(
          title: 'Custom States',
          description:
              'Pass any string through the states: parameter to activate matching prefixed classes.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDiv(
                states: _isSelected ? const {'selected'} : const {},
                className: '''
                  p-4 rounded-lg border-2 duration-200
                  border-gray-200 dark:border-slate-700
                  bg-white dark:bg-slate-800
                  selected:border-blue-500 selected:bg-blue-50
                  dark:selected:border-blue-400 dark:selected:bg-blue-900/30
                ''',
                child: WText(
                  _isSelected
                      ? 'I am selected.'
                      : 'Click the button below to select me.',
                  className: 'text-slate-700 dark:text-slate-200',
                ),
              ),
              WButton(
                onTap: () => setState(() => _isSelected = !_isSelected),
                className: '''
                  bg-blue-600 hover:bg-blue-700
                  text-white px-4 py-2 rounded self-start
                ''',
                child: WText(
                  _isSelected ? 'Deselect' : 'Select',
                  className: 'text-white font-medium',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'State Propagation',
          description:
              'A parent WAnchor shares its hover state with every WText below it. The descendant picks up hover:text-blue-600 even when the cursor is on the padding.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                p-4 rounded-lg duration-200
                bg-white dark:bg-slate-800
                hover:bg-gray-50 dark:hover:bg-slate-700
                border border-slate-200 dark:border-slate-700
              ''',
              children: const [
                WText(
                  'Card Title',
                  className: '''
                    font-bold duration-200
                    text-slate-900 dark:text-white
                    hover:text-blue-600 dark:hover:text-blue-400
                  ''',
                ),
                WText(
                  'Hover anywhere on this card and the title above adopts the blue accent because state propagates through WindContext.',
                  className: 'text-sm text-slate-500 dark:text-slate-400',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrefixCard extends StatelessWidget {
  final String prefix;
  final String trigger;
  final String useCase;

  const _PrefixCard({
    required this.prefix,
    required this.trigger,
    required this.useCase,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-1 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WText(
          prefix,
          className: 'font-mono font-bold text-cyan-600 dark:text-cyan-400',
        ),
        WText(
          trigger,
          className: 'text-sm text-slate-700 dark:text-slate-300',
        ),
        WText(
          useCase,
          className: 'text-xs text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }
}
