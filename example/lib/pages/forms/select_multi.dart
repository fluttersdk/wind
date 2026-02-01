import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Multi-select WSelect example with chips/tags.
class SelectMultiExamplePage extends StatefulWidget {
  const SelectMultiExamplePage({super.key});

  @override
  State<SelectMultiExamplePage> createState() => _SelectMultiExamplePageState();
}

class _SelectMultiExamplePageState extends State<SelectMultiExamplePage> {
  List<String> _selectedTags = [];
  List<String> _selectedColors = ['red', 'blue'];

  final _tagOptions = const [
    SelectOption(value: 'flutter', label: 'Flutter'),
    SelectOption(value: 'dart', label: 'Dart'),
    SelectOption(value: 'mobile', label: 'Mobile'),
    SelectOption(value: 'web', label: 'Web'),
    SelectOption(value: 'desktop', label: 'Desktop'),
    SelectOption(value: 'ui', label: 'UI/UX'),
  ];

  final _colorOptions = const [
    SelectOption(
      value: 'red',
      label: 'Red',
      icon: Icon(Icons.circle, color: Colors.red, size: 16),
    ),
    SelectOption(
      value: 'blue',
      label: 'Blue',
      icon: Icon(Icons.circle, color: Colors.blue, size: 16),
    ),
    SelectOption(
      value: 'green',
      label: 'Green',
      icon: Icon(Icons.circle, color: Colors.green, size: 16),
    ),
    SelectOption(
      value: 'purple',
      label: 'Purple',
      icon: Icon(Icons.circle, color: Colors.purple, size: 16),
    ),
  ];

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
              bg-gradient-to-r from-pink-500 to-rose-500
            ''',
            children: const [
              WText('Multi-Select', className: 'text-lg font-bold text-white'),
              WText(
                'Select multiple items with chips',
                className: 'text-sm text-pink-100',
              ),
            ],
          ),

          // Multi-select tags
          _buildSection(
            title: 'Tag Selection',
            description: 'Select multiple tags with search',
            children: [
              WSelect<String>(
                isMulti: true,
                values: _selectedTags,
                options: _tagOptions,
                searchable: true,
                placeholder: 'Select tags...',
                onMultiChange: (values) =>
                    setState(() => _selectedTags = values),
                className: '''
                  w-80 p-2 min-h-10 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-lg max-h-64
                ''',
              ),
              if (_selectedTags.isNotEmpty)
                WText(
                  'Selected: ${_selectedTags.join(", ")}',
                  className: 'text-sm text-green-600 dark:text-green-400',
                ),
            ],
          ),

          // Multi-select with icons
          _buildSection(
            title: 'With Icons',
            description: 'Options with color icons',
            children: [
              WSelect<String>(
                isMulti: true,
                values: _selectedColors,
                options: _colorOptions,
                placeholder: 'Select colors...',
                onMultiChange: (values) =>
                    setState(() => _selectedColors = values),
                className: '''
                  w-80 p-2 min-h-10 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-lg max-h-48
                ''',
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Multi-Select Props',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('isMulti:', 'true'),
                  _referenceRow('values:', 'List<T>'),
                  _referenceRow('onMultiChange:', 'Callback'),
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
