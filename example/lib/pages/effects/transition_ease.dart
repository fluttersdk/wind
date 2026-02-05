import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example page demonstrating transition ease/timing utilities.
class TransitionEasePage extends StatelessWidget {
  const TransitionEasePage({super.key});

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
              bg-gradient-to-r from-emerald-500 to-teal-500
            ''',
            children: [
              WText(
                'Transition Ease',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control timing curves for smooth animations',
                className: 'text-sm text-emerald-100',
              ),
            ],
          ),

          // Ease examples section
          _buildSection(
            title: 'Timing Curves',
            description:
                'Hover over each box to compare different easing functions (all use 700ms duration)',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  _easeBox(
                    'ease-linear',
                    'Linear',
                    'bg-gray-500 hover:bg-gray-700',
                  ),
                  _easeBox('ease-in', 'Ease In', 'bg-sky-500 hover:bg-sky-700'),
                  _easeBox(
                    'ease-out',
                    'Ease Out',
                    'bg-violet-500 hover:bg-violet-700',
                  ),
                  _easeBox(
                    'ease-in-out',
                    'In Out',
                    'bg-rose-500 hover:bg-rose-700',
                  ),
                ],
              ),
            ],
          ),

          // When to use
          _buildSection(
            title: 'When to Use',
            description: 'Each curve is best suited for different scenarios',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  _usageRow('ease-linear', 'Constant speed, good for spinners'),
                  _usageRow('ease-in', 'Accelerates, good for exits'),
                  _usageRow('ease-out', 'Decelerates, good for entrances'),
                  _usageRow('ease-in-out', 'Most natural for UI transitions'),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('ease-linear', 'Curves.linear'),
                  _referenceRow('ease-in', 'Curves.easeIn'),
                  _referenceRow('ease-out', 'Curves.easeOut'),
                  _referenceRow('ease-in-out', 'Curves.easeInOut'),
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

  Widget _easeBox(String easeClass, String label, String colors) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className: '''
          $colors duration-700 $easeClass
          w-[120px] py-5 rounded-xl shadow-md hover:shadow-xl
        ''',
        child: WText(label, className: 'text-white font-bold text-center'),
      ),
    );
  }

  Widget _usageRow(String className, String description) {
    return WDiv(
      className: 'flex gap-3 items-start',
      children: [
        WText(
          className,
          className:
              'text-sm font-mono text-emerald-600 dark:text-emerald-400 min-w-[100px]',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
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
        WText(
          value,
          className: 'text-sm text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
