import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WAnchor example showing state management for hover, focus, and disabled.
class AnchorBasicExamplePage extends StatelessWidget {
  const AnchorBasicExamplePage({super.key});

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
              WText('WAnchor', className: 'text-lg font-bold text-white'),
              WText(
                'State wrapper for hover, focus, and disabled',
                className: 'text-sm text-violet-100',
              ),
            ],
          ),

          // Hover state
          _buildSection(
            title: 'Hover State',
            description: 'WAnchor enables hover: prefix on children',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        px-4 py-2 rounded-lg
                        bg-blue-500 hover:bg-blue-600
                        duration-200
                      ''',
                      child: const WText(
                        'Hover Me',
                        className: 'text-white font-medium',
                      ),
                    ),
                  ),
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        px-4 py-2 rounded-lg border border-gray-300
                        bg-white hover:bg-blue-100 hover:border-blue-400
                        duration-200
                      ''',
                      child: const WText(
                        'Light Button',
                        className: 'text-gray-700',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Hover color changes
          _buildSection(
            title: 'Hover Color Effects',
            description: 'Color transitions work with duration-* classes',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        w-16 h-16 rounded-lg
                        bg-pink-500 hover:bg-rose-600
                        duration-200
                      ''',
                    ),
                  ),
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        w-16 h-16 rounded-lg
                        bg-cyan-500 hover:bg-blue-600
                        duration-200
                      ''',
                    ),
                  ),
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        w-16 h-16 rounded-lg
                        bg-green-500 hover:bg-emerald-600
                        duration-200
                      ''',
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Disabled state
          _buildSection(
            title: 'Disabled State',
            description: 'Use isDisabled prop for disabled: prefix',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        px-4 py-2 rounded-lg
                        bg-blue-500 hover:bg-blue-600
                      ''',
                      child: const WText('Enabled', className: 'text-white'),
                    ),
                  ),
                  WAnchor(
                    onTap: () {},
                    isDisabled: true,
                    child: WDiv(
                      className: '''
                        px-4 py-2 rounded-lg
                        bg-blue-500 disabled:bg-gray-400
                        disabled:opacity-50
                      ''',
                      child: const WText('Disabled', className: 'text-white'),
                    ),
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
                  _referenceRow('disabled:', 'isDisabled = true'),
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
