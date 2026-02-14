import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Styled date picker with hover, focus, and selected states.
class DatePickerStyledExamplePage extends StatefulWidget {
  const DatePickerStyledExamplePage({super.key});

  @override
  State<DatePickerStyledExamplePage> createState() =>
      _DatePickerStyledExamplePageState();
}

class _DatePickerStyledExamplePageState
    extends State<DatePickerStyledExamplePage> {
  DateTime? _ringDate;
  DateTime? _compactDate;
  DateTime? _shadowDate;
  DateTime? _dashedDate;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          // Header
          WDiv(
            className:
                'bg-gradient-to-r from-pink-500 to-rose-600 rounded-xl p-6',
            children: const [
              WText('Styled Date Picker',
                  className: 'text-2xl font-bold text-white'),
              WText(
                'Using Wind utilities for hover, focus, selected, and disabled states.',
                className: 'text-pink-100 mt-1',
              ),
            ],
          ),

          // Ring Focus
          _buildSection(
            title: 'Interactive with Ring Focus',
            description:
                'Hover changes border, focus activates ring, selected tints background.',
            child: WDatePicker(
              value: _ringDate,
              onChanged: (date) => setState(() => _ringDate = date),
              className: 'w-full p-3 bg-white dark:bg-gray-800 '
                  'border border-gray-300 dark:border-gray-600 rounded-lg '
                  'hover:border-blue-400 dark:hover:border-blue-500 '
                  'focus:border-blue-500 focus:ring-2 focus:ring-blue-200 '
                  'dark:focus:ring-blue-800 '
                  'selected:border-blue-500',
            ),
          ),

          // Compact Inline
          _buildSection(
            title: 'Compact Inline',
            description: 'Minimal padding and small text for inline usage.',
            child: WDatePicker(
              value: _compactDate,
              onChanged: (date) => setState(() => _compactDate = date),
              className:
                  'px-2 py-1 text-sm border rounded bg-gray-50 dark:bg-gray-900 hover:bg-white dark:hover:bg-gray-800',
              placeholder: 'Date',
            ),
          ),

          // Borderless with Shadow
          _buildSection(
            title: 'Borderless with Shadow',
            description: 'No border, shadow-based depth that grows on hover.',
            child: WDatePicker(
              value: _shadowDate,
              onChanged: (date) => setState(() => _shadowDate = date),
              className:
                  'w-full p-3 bg-white dark:bg-gray-800 rounded-xl shadow-md hover:shadow-lg',
            ),
          ),

          // Dashed Border
          _buildSection(
            title: 'Dashed Border with Transition',
            description: 'Custom dashed border that changes color on hover.',
            child: WDatePicker(
              value: _dashedDate,
              onChanged: (date) => setState(() => _dashedDate = date),
              placeholder: 'Custom Styled Picker',
              className: 'w-full p-4 bg-slate-100 dark:bg-slate-900 '
                  'border-2 border-dashed border-slate-300 dark:border-slate-700 '
                  'rounded-2xl hover:border-blue-500 dark:hover:border-blue-400 '
                  'duration-300',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        child,
      ],
    );
  }
}
