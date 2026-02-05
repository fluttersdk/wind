import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example page demonstrating transition duration utilities.
class TransitionDurationPage extends StatelessWidget {
  const TransitionDurationPage({super.key});

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
              bg-gradient-to-r from-purple-500 to-pink-500
            ''',
            children: [
              WText(
                'Transition Duration',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control how long transitions take',
                className: 'text-sm text-purple-100',
              ),
            ],
          ),

          // Preset durations
          _buildSection(
            title: 'Preset Durations',
            description: 'Hover over each box to see different duration speeds',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: [
                  _durationBox('duration-75', '75ms'),
                  _durationBox('duration-150', '150ms'),
                  _durationBox('duration-300', '300ms'),
                  _durationBox('duration-500', '500ms'),
                  _durationBox('duration-700', '700ms'),
                  _durationBox('duration-1000', '1s'),
                ],
              ),
            ],
          ),

          // Arbitrary durations
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Use duration-[Xms] for custom durations',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: [
                  _durationBox('duration-[250]', '250ms'),
                  _durationBox('duration-[400ms]', '400ms'),
                  _durationBox('duration-[800]', '800ms'),
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
                  _referenceRow('duration-75', '75ms'),
                  _referenceRow('duration-100', '100ms'),
                  _referenceRow('duration-150', '150ms'),
                  _referenceRow('duration-200', '200ms'),
                  _referenceRow('duration-300', '300ms'),
                  _referenceRow('duration-500', '500ms'),
                  _referenceRow('duration-700', '700ms'),
                  _referenceRow('duration-1000', '1000ms'),
                  _referenceRow('duration-[Xms]', 'Arbitrary'),
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

  Widget _durationBox(String durationClass, String label) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className: '''
          bg-purple-500 hover:bg-pink-600 $durationClass
          px-6 py-4 rounded-xl shadow-md hover:shadow-xl
        ''',
        child: WText(label, className: 'text-white font-bold text-lg'),
      ),
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
