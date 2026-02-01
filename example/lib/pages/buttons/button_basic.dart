import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WButton example showing button variants and state handling.
class ButtonBasicExamplePage extends StatefulWidget {
  const ButtonBasicExamplePage({super.key});

  @override
  State<ButtonBasicExamplePage> createState() => _ButtonBasicExamplePageState();
}

class _ButtonBasicExamplePageState extends State<ButtonBasicExamplePage> {
  int _counter = 0;
  bool _isLoading = false;

  void _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
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
              bg-gradient-to-r from-indigo-500 to-blue-500
            ''',
            children: const [
              WText('WButton', className: 'text-lg font-bold text-white'),
              WText(
                'Utility-first button with loading and state support',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),

          // Button variants
          _buildSection(
            title: 'Button Variants',
            description: 'Style buttons with className',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: [
                  WButton(
                    onTap: () => setState(() => _counter++),
                    className: '''
                      bg-blue-600 hover:bg-blue-700
                      text-white px-4 py-2 rounded-lg
                      duration-200
                    ''',
                    child: const Text('Primary'),
                  ),
                  WButton(
                    onTap: () {},
                    className: '''
                      bg-gray-200 hover:bg-gray-300
                      text-gray-800 px-4 py-2 rounded-lg
                      duration-200
                    ''',
                    child: const Text('Secondary'),
                  ),
                  WButton(
                    onTap: () {},
                    className: '''
                      border-2 border-blue-600 hover:bg-blue-50
                      text-blue-600 px-4 py-2 rounded-lg
                      duration-200
                    ''',
                    child: const Text('Outline'),
                  ),
                  WButton(
                    onTap: () {},
                    className: '''
                      bg-red-500 hover:bg-red-600
                      text-white px-4 py-2 rounded-lg
                      duration-200
                    ''',
                    child: const Text('Danger'),
                  ),
                ],
              ),
              WText(
                'Counter: $_counter',
                className: 'text-sm text-gray-500 mt-2',
              ),
            ],
          ),

          // Loading state
          _buildSection(
            title: 'Loading State',
            description: 'Use isLoading prop for spinner',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: [
                  WButton(
                    onTap: _simulateLoading,
                    isLoading: _isLoading,
                    loadingText: 'Loading...',
                    className: '''
                      bg-blue-600 loading:opacity-70
                      text-white px-6 py-2 rounded-lg
                    ''',
                    child: const Text('Click to Load'),
                  ),
                  WButton(
                    onTap: () {},
                    isLoading: true,
                    className: '''
                      bg-green-600 text-white px-6 py-2 rounded-lg
                    ''',
                    child: const Text('Always Loading'),
                  ),
                ],
              ),
            ],
          ),

          // Disabled state
          _buildSection(
            title: 'Disabled State',
            description: 'Use disabled prop for disabled styling',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: [
                  WButton(
                    onTap: () {},
                    className: '''
                      bg-blue-600 hover:bg-blue-700
                      text-white px-4 py-2 rounded-lg
                    ''',
                    child: const Text('Enabled'),
                  ),
                  WButton(
                    onTap: () {},
                    disabled: true,
                    className: '''
                      bg-blue-600 disabled:bg-gray-400 disabled:opacity-50
                      text-white px-4 py-2 rounded-lg
                    ''',
                    child: const Text('Disabled'),
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
                  _referenceRow('hover:', 'Mouse over'),
                  _referenceRow('focus:', 'Keyboard focus'),
                  _referenceRow('disabled:', 'disabled = true'),
                  _referenceRow('loading:', 'isLoading = true'),
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
