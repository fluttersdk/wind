import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TransitionBasicExamplePage extends StatelessWidget {
  const TransitionBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      children: [
        // Header
        _buildHeader(
          title: 'Transitions',
          description:
              'Utilities for controlling transition duration and easing curves.',
        ),

        const WSpacer(className: 'h-6'),

        // Transition Colors
        _buildSection(
          title: 'Transition Colors',
          description:
              'Use duration utilities to animate color changes on hover.',
          child: WDiv(
            className: 'flex wrap gap-4',
            children: [
              _buildDemoBox(
                className:
                    'bg-blue-500 hover:bg-red-500 duration-300 text-white',
                label: 'Hover me (Color)',
                subLabel: 'duration-300',
              ),
              _buildDemoBox(
                className:
                    'bg-purple-500 hover:bg-purple-700 duration-700 text-white',
                label: 'Hover me (Color)',
                subLabel: 'duration-700',
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Transition Opacity
        _buildSection(
          title: 'Transition Opacity',
          description: 'Animate opacity changes smoothly.',
          child: WDiv(
            className: 'flex wrap gap-4',
            children: [
              _buildDemoBox(
                className:
                    'bg-green-500 opacity-100 hover:opacity-50 duration-300 text-white',
                label: 'Hover me (Opacity)',
                subLabel: 'duration-300',
              ),
              _buildDemoBox(
                className:
                    'bg-green-500 opacity-25 hover:opacity-100 duration-1000 text-white',
                label: 'Hover me (Opacity)',
                subLabel: 'duration-1000',
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Transition Shadow & Border (Simulating Transform/Scale visually)
        // Note: Scale transforms might depend on specific parser availability,
        // so we demonstrate standard layout/decoration transitions which are core.
        _buildSection(
          title: 'Transition Effects',
          description: 'Animate shadows, borders, and sizing.',
          child: WDiv(
            className: 'flex wrap gap-4',
            children: [
              _buildDemoBox(
                className:
                    'bg-white dark:bg-gray-800 border-2 border-transparent hover:border-blue-500 duration-300 text-gray-800 dark:text-white shadow-sm hover:shadow-xl',
                label: 'Hover me (Border/Shadow)',
                subLabel: 'duration-300',
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Duration Scale
        _buildSection(
          title: 'Duration Scale',
          description: 'Control the speed of transitions.',
          child: WDiv(
            className: 'grid grid-cols-2 md:grid-cols-4 gap-4',
            children: [
              _buildDurationDemo('duration-75', 75),
              _buildDurationDemo('duration-150', 150),
              _buildDurationDemo('duration-300', 300),
              _buildDurationDemo('duration-500', 500),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Easing Curves
        _buildSection(
          title: 'Easing Curves',
          description: 'Control the velocity curve of transitions.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
            children: [
              _buildEaseDemo('ease-linear', 'Linear'),
              _buildEaseDemo('ease-in', 'Ease In'),
              _buildEaseDemo('ease-out', 'Ease Out'),
              _buildEaseDemo('ease-in-out', 'Ease In Out'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({required String title, required String description}) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(title,
            className: 'text-2xl font-bold text-gray-900 dark:text-white'),
        WText(description,
            className: 'text-base text-gray-600 dark:text-gray-400'),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-gray-800 dark:text-white'),
            WText(description,
                className: 'text-sm text-gray-500 dark:text-gray-400'),
          ],
        ),
        WDiv(
          className:
              'p-6 border border-gray-200 dark:border-gray-700 rounded-xl bg-gray-50 dark:bg-gray-900',
          child: child,
        ),
      ],
    );
  }

  Widget _buildDemoBox({
    required String className,
    required String label,
    required String subLabel,
  }) {
    return WDiv(
      className:
          'w-40 h-32 rounded-lg flex flex-col justify-center items-center cursor-pointer $className',
      children: [
        WText(label, className: 'text-sm font-medium text-center px-2'),
        WText(subLabel, className: 'text-xs opacity-75 mt-1'),
      ],
    );
  }

  Widget _buildDurationDemo(String durationClass, int ms) {
    return WDiv(
      className: 'flex flex-col gap-2 items-center',
      children: [
        WDiv(
          className:
              'w-full h-12 bg-blue-500 hover:bg-green-500 $durationClass rounded-lg flex items-center justify-center cursor-pointer',
          children: [
            WText('Hover', className: 'text-white text-sm font-medium'),
          ],
        ),
        WText(durationClass,
            className: 'text-xs font-mono text-gray-600 dark:text-gray-400'),
      ],
    );
  }

  Widget _buildEaseDemo(String easeClass, String label) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WDiv(
          className:
              'w-full h-16 bg-purple-500 hover:bg-purple-700 opacity-50 hover:opacity-100 duration-1000 $easeClass rounded-lg flex items-center justify-center cursor-pointer',
          children: [
            WText('Hover to see $label',
                className: 'text-white text-sm font-medium'),
          ],
        ),
        WDiv(
          className: 'flex justify-between',
          children: [
            WText(label,
                className:
                    'text-sm font-medium text-gray-700 dark:text-gray-300'),
            WText(easeClass,
                className:
                    'text-xs font-mono text-gray-500 dark:text-gray-500'),
          ],
        ),
      ],
    );
  }
}
