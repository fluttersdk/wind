import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Styled input examples demonstrating various styling approaches.
class InputStyledExamplePage extends StatefulWidget {
  const InputStyledExamplePage({super.key});

  @override
  State<InputStyledExamplePage> createState() => _InputStyledExamplePageState();
}

class _InputStyledExamplePageState extends State<InputStyledExamplePage> {
  String _minimal = '';
  String _filled = '';
  String _rounded = '';
  String _bordered = '';

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
              bg-gradient-to-r from-amber-500 to-orange-500
            ''',
            children: const [
              WText('Styled Inputs', className: 'text-lg font-bold text-white'),
              WText(
                'Various styling approaches',
                className: 'text-sm text-amber-100',
              ),
            ],
          ),

          // Minimal
          _buildSection(
            title: 'Minimal (Underline)',
            description: 'Border-bottom only style',
            children: [
              WInput(
                value: _minimal,
                onChanged: (value) => setState(() => _minimal = value),
                placeholder: 'Minimal input',
                className: '''
                  w-full p-3 border-b-2 border-gray-300 dark:border-gray-600
                  text-gray-900 dark:text-white
                  bg-transparent
                ''',
              ),
            ],
          ),

          // Filled
          _buildSection(
            title: 'Filled Background',
            description: 'Background color with no border',
            children: [
              WInput(
                value: _filled,
                onChanged: (value) => setState(() => _filled = value),
                placeholder: 'Filled input',
                className: '''
                  w-full p-4 rounded-lg
                  bg-gray-100 dark:bg-slate-700
                  text-gray-900 dark:text-white
                ''',
              ),
            ],
          ),

          // Rounded
          _buildSection(
            title: 'Pill Shape',
            description: 'Fully rounded corners',
            children: [
              WInput(
                value: _rounded,
                onChanged: (value) => setState(() => _rounded = value),
                placeholder: 'Rounded input',
                className: '''
                  w-full px-5 py-3 rounded-full
                  border border-gray-300 dark:border-gray-600
                  text-gray-900 dark:text-white
                  bg-white dark:bg-slate-800
                ''',
              ),
            ],
          ),

          // Bordered
          _buildSection(
            title: 'Thick Border',
            description: 'Prominent border styling',
            children: [
              WInput(
                value: _bordered,
                onChanged: (value) => setState(() => _bordered = value),
                placeholder: 'Bordered input',
                className: '''
                  w-full p-4 rounded-xl
                  border-2 border-blue-500
                  text-gray-900 dark:text-white
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
                'Style Classes',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('border-b-2', 'Underline'),
                  _referenceRow('rounded-full', 'Pill shape'),
                  _referenceRow('border-2', 'Thick border'),
                  _referenceRow('bg-gray-100', 'Filled style'),
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
